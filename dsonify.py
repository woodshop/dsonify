import dtrace
import time
import numpy as np
import OSC
import subprocess
import signal
import sys
import argparse

"""
Written by Andy Sarroff, March 2013.
"""

client = None
thr = None
p = None

def simple_chew(cpu):
    pass

def simple_chewrec(action):
    pass

def simple_out(value):
    try:
        v = value.split();
        if len(v) == 1:
            v.append('null')
        sendOSCMsg(v[0], [v[1]])
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

def signal_handler(signal, frame):
    global thr,p
    print('Shutting down.')
    thr.stop()
    thr.join()
    p.kill()
    sys.exit(0)

def main(probeScript, synthFile):
    global thr,p
    print('Starting. Press CTRL-C to stop.')
    p = subprocess.Popen(["chuck", synthFile])
    initOSCClient()
    thr = dtrace.DTraceConsumerThread(script=probeScript, consume=True,
                                      chew_func=simple_chew,
                                      chewrec_func=simple_chewrec,
                                      out_func=simple_out,
                                      walk_func=simple_walk,
                                      sleep=0)
    signal.signal(signal.SIGINT, signal_handler)
    thr.start()
    while(1):
        time.sleep(60)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description='Sonify your operating system. This program takes ' + \
            'dtrace messages as specified in the probeFile and passes them' + \
            ' to the ChucK synthesizers as specified in the synthFile. ' + \
            'You must be root to run this application. See the ' + \
            'accompanying README for more information.')
    parser.add_argument('probeFile', type=str, 
                        help="a probe script written for dtrace")
    parser.add_argument('synthFile', type=str, 
                        help="a synth script written for ChucK")
    args = parser.parse_args()
    probeScript = open(args.probeFile, 'r').read()
    main(probeScript, args.synthFile)
