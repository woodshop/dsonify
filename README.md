# dsonify

SOS: Sonify Your Operating System

## About
'dsonify.py' sonifies a few aspects of the Mac OS filesystem. In particular, it inserts dtrace probes on 6 syscalls related to files. Each probe triggers a unique synthesized sound:

* pread, read, readv: The frequency of a sine tone is randomly modulated between 50 and 300 Hz. Playback is in the left audio channel only.
			                
* pwrite, write, write: The frequency of a sine tone is randomly modulated between 50 and 300 Hz. Playback is in the left audio channel only.

The read and writes provide a constant babble of sound, reflecting the constant rw activity of the kernel.
	
* open: A synthesized sitar sound plays every time the kernel tries to open a file for read or write. The plucked note has a fundamental frequency of 440 hz (concert A) and is panned slightly to the left.
	                        
* close: A synthesized sitar sound plays every time the kernel tries to closes a file for read or write. The plucked note is a minor 6th ablove an A.
							
* fsync: Whenever the kernel synchronizes a file on permanant storage a low tubular sound is played.
	                        
* fnctl: Any inspection or changes to a file descripter are caught by dtrace. The lookup table for fd changes is large and has been written into dsonify.d. At the moment, dsonify.py sonifies	any gets or sets to the descriptor flags. "F_GETFL", "F_SETFL", "F_GETFD", and "F_SETFD" share the same freuency modulated tone but are separated by octaves. "F_GETFL" and "F_SETFL" are usually triggered at neraly the same time, as are "F_GETFD", and "F_SETFD".

The main script, 'dsonify.py' loads a dtrace script, 'dsonify.d'. The script is sent via a dtrace threaded consumer to be compiled. A chuck sound synthesis engine is started on another thread and loads the synthesis functions stored in 'dsonify.ck'. The dtrace consumer in python receives probe messages. The messages are parsed, and appropriate commands are sent via udp to the chuck server.

To run this program, make sure 'dsonify.d' and dsonify.ck' are in the same directory as 'dsonify.py'. It is probably best to wear headphones, since the L/R channel placement is an important part of the sonification. Then simply start a terminal session as root and enter:

    python dsonify.py

To terminate, enter CTRL-C.

This version has only been tested on a Mac running OS 10.8.3 with python version 2.7.5.


## To Install

### Dependencies:

Sound synthesis is done using ChucK. More information can be found [here](http://chuck.cs.princeton.edu/ "ChucK").

Message passing between the message dispatcher is done using the pyOsc python interface to OSC. More information: [pyOsc](https://trac.v2.nl/wiki/pyOSC "pyOsc"). Alternatively:

    sudo easy_install pyOsc

The python interface for DTrace is python-dtrace. More infor [here](http://tmetsch.github.io/python-dtrace/ "python-dtrace"). Alternatively:

    sudo easy_install python-dtrace

The python-dtrace module requires Cython
It requires [Cython](http://www.cython.org/ "Cython"):

    sudo easy_install Cython
