# dsonify

SOS: Sonify Your Operating System

## About
'dsonify.py' provides a framework for sonifying aspects of a Unix-like operating system. It operates as a message dispatcher between a set of operating system probes written for dtrace and a set of audio synthesizers written for ChucK.

To run this program, you will need a probe file and a synth file. The probe file specifies a set of probes that will be fired by dtrace. For each probe in your probe file script, use the following syntax:

	printf("message [value]");

dsonify.py will pass "message" as the OSC message address to the ChucK synthesizer. You may provide an optional [value] as a contiguous string. The message dispatcher will parse "message" and (if it exists) "value". It will send message and value to port 9000 on the local host using the OSC protocol. It is up to you to write a ChucK script that handles the events and accompanying values. See the included demos as a coding guide.

To run dsonify, type:

	sudo python dsonify.py probeFile synthFile

where probeFile and synthFile are the respective file names of the the dtrace probe script and ChucK synth script. You must have python, dtrace, and chuck in your file search path.

To terminate, enter CTRL-C.

This version has only been tested on a Mac running OS 10.8.5 with python version 2.7.5.

## To Install

### Dependencies:
We assume that you already have dtrace and python installed.

Sound synthesis is done using ChucK. More information and downloads are at:  [http://chuck.cs.princeton.edu/](http://chuck.cs.princeton.edu/ "ChucK").

Message passing between the message dispatcher and ChucK is done using the pyOsc python interface to OSC. More information: [pyOsc](https://trac.v2.nl/wiki/pyOSC "pyOsc"). Install:

    sudo easy_install pyOsc

The python interface for DTrace is python-dtrace. More information: [python-dtrace](http://tmetsch.github.io/python-dtrace/ "python-dtrace"). Install:

    sudo easy_install python-dtrace

The python-dtrace module requires Cython. More information: [Cython](http://www.cython.org/ "Cython"). Install:

    sudo easy_install Cython

## Demos
We have included two demos to get you started. The first demo sonifies all file opens, closes, reads, writes, and some other file system file managment operations. The second demo sonifies outgoing internet connections.

Both demos are based on source code available at [http://www.dtracebook.com/](http://www.dtracebook.com/ "dtracebook"), which is the online accompanient to the excellent DTrace reference:

* _Dynamic Tracing in Oracle Solaris, Mac OS X, and FreeBSD_ by Brendan Gregg and Jim Mauro, Prentice Hall 2011.

### Demo 1
It is probably best to wear headphones, since the L/R channel placement is an important part of the sonification. Then simply start a terminal session and enter:

    sudo python dsonify.py demos/filesProbe.d demos/filesSynth.ck

This demo inserts dtrace probes on 6 syscalls related to file management by the operating system. Each probe triggers a unique synthesized sound:

* pread, read, readv: The frequency of a sine tone is randomly modulated between 50 and 300 Hz. Playback is in the left audio channel only.
			                
* pwrite, write, write: The frequency of a sine tone is randomly modulated between 50 and 300 Hz. Playback is in the right audio channel only.

The read and write syscalls provide a constant babble of sound, reflecting the constant rw activity of the kernel.
	
* open: A synthesized sitar sound plays every time the kernel tries to open a file. The plucked note has a fundamental frequency of 440 hz (concert A) and is panned mostly to the left.
	                        
* close: A synthesized sitar sound plays every time the kernel tries to close a file for read or write. The plucked note is a minor 6th above a concert A and is panned mostly to the right.
							
* fsync: Whenever the kernel synchronizes a file on permanant storage a low tubular sound is played.
	                        
* fnctl: Any inspection or changes to a file descripter are caught by dtrace. The lookup table for fd changes is large and has been written into filesProbe.d. At the moment, filesSynth.ck sonifies any gets or sets to the descriptor flags. "F_GETFL", "F_SETFL", "F_GETFD", and "F_SETFD" share the same freuency modulated tone but are separated by octaves. "F_GETFL" and "F_SETFL" are usually triggered at nearly the same time, as are "F_GETFD", and "F_SETFD".

### Demo 2
To run this demo, start a terminal session and enter:

	sudo python dsonify.py demos/ipconnectProbe.d demos/ipconnectSynth.ck
	
This demo inserts a trace probe on outgoing internet connections and maps their port number to the pitch of a filtered square wave. As your operating system makes outgoing connections web servers, DNS servers, mail servers, etc. you'll hear filtered square wave tones. These events normally occur regularly on a personal computer. When one here's an unusual pitch, their operating system is connecting to the network on an unusual port.
