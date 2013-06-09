import dtrace
import time
import numpy as np
import OSC
import subprocess
import signal
import sys

"""
Written by Andy Sarroff, March 2013. To run, make sure that you have
'dsonify.ck' and 'dsonify.d' in the same directory as this file.
"""

SCRIPT = open('dsonify.d', 'r').read()
client = None
thr = None
p = None

def simple_chew(cpu):
    pass

def simple_chewrec(action):
    pass

def simple_out(value):
    try:
        if value.split()[0] == "read":
            #print("READ: {0}".format(value))
            sendOSCMsg("dsonify/read", [np.random.randint(50, 300)])
        if value.split()[0] == "write":
            #print("WRITE: {0}".format(value))
            sendOSCMsg("dsonify/write", [np.random.randint(50, 300)])
        if value.split()[0] == "open":
            #print("OPEN: {0}".format(value))
            sendOSCMsg("dsonify/open", [440.0])
        if value.split()[0] == "close":
            #print("CLOSE: {0}".format(value))
            sendOSCMsg("dsonify/close", [440*2**(8./12)])
        if value.split()[0] == "fsync":
            #print("FSYNC: {0}".format(value))
            sendOSCMsg("dsonify/fsync", [220.0])
        if value.split()[0] == "fcntl":
            #print("FCNTL: {0}".format(value))
            if value.split()[1] == "F_GETFL":
                sendOSCMsg("dsonify/fcntl", [0])
            if value.split()[1] == "F_SETFL":
                sendOSCMsg("dsonify/fcntl", [1])
            if value.split()[1] == "F_GETFD":
                sendOSCMsg("dsonify/fcntl", [2])
            if value.split()[1] == "F_SETFD":
                sendOSCMsg("dsonify/fcntl", [3])
    except OSC.OSCClientError:
        pass
    pass

def simple_walk(action, identifier, keys, value):
    pass

def initOSCClient():
    global client
    client = OSC.OSCClient()
    client.connect(('127.0.0.1', 9000))

def sendOSCMsg(address, data):
    m = OSC.OSCMessage(address)
    m.setAddress(address)
    for d in data:
        m.append(d)
    client.send(m)

def chuck(filename):
    p = subprocess.Popen(["/usr/bin/chuck", filename])
    p.kill()

def signal_handler(signal, frame):
    global thr,p
    print('Shutting down.')
    thr.stop()
    thr.join()
    p.kill()
    sys.exit(0)

def main():
    global thr,p
    print('Starting. Press CTRL-C to stop.')
    p = subprocess.Popen(["/usr/bin/chuck", 'dsonify.ck'])
    initOSCClient()
    thr = dtrace.DTraceConsumerThread(script=SCRIPT, consume=True,
                                      chew_func=simple_chew,
                                      chewrec_func=simple_chewrec,
                                      out_func=simple_out,
                                      walk_func=simple_walk,
                                      sleep=0)
    thr.start()
    while(1):
        time.sleep(60)

signal.signal(signal.SIGINT, signal_handler)

if __name__ == '__main__':
    main()
