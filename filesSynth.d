OscRecv recv;
9000 => recv.port;
recv.listen();
recv.event( "read, s" ) @=> OscEvent oe_read;
recv.event( "write, s" ) @=> OscEvent oe_write;
recv.event( "open, s" ) @=> OscEvent oe_open;
recv.event( "close, s" ) @=> OscEvent oe_close;
recv.event( "fsync, s" ) @=> OscEvent oe_fsync;
recv.event( "fcntl, s" ) @=> OscEvent oe_fcntl;

main();

fun void main() {
    spork ~ inst_read();
    spork ~ inst_write();
    spork ~ inst_open();
    spork ~ inst_close();
    spork ~ inst_fsync();
    spork ~ inst_fcntl();
    1::day => now;
}

fun void inst_read()
{
    SinOsc s => Pan2 p => dac;
    0.2 => s.gain;
    -1 => p.pan;
    while(true) {
        oe_read => now;
        while (oe_read.nextMsg() != 0)
    	{   
	    oe_read.getString();
	    Math.random2f(50, 300) => s.freq;
    	}
    }
}

fun void inst_write()
{
    SinOsc s => Pan2 p => dac;
    0.2 => s.gain;
    1 => p.pan;
    while(true) {
        oe_write => now;
        while (oe_write.nextMsg() != 0)
    	{
	    oe_write.getString();
	    Math.random2f(50, 300) => s.freq;
    	}
    }
}

fun void inst_open()
{
    Sitar s => Pan2 p => dac;
    -0.75 => p.pan;
    0.2 => s.gain;
    while(true) {
        oe_open => now;
        while (oe_open.nextMsg() != 0)
    	{
	    oe_open.getString();
	    440.0 => s.freq;
	    1.0 => s.noteOn;
    	}
    }
}

fun void inst_close()
{
    Sitar s => Pan2 p => dac;
    0.75 => p.pan;
    0.2 => s.gain;
    while(true) {
        oe_close => now;
        while (oe_close.nextMsg() != 0)
    	{
	    oe_close.getString();
	    440.0*Math.pow(2, 8.0/12) => s.freq;
	    1.0 => s.noteOn;
    	}
    }
}

fun void inst_fsync()
{
    TubeBell s => Chorus c => dac;
    0.5 => s.gain;
    0.5 => c.mix;
    0.5 => c.modDepth;
    while(true) {
        oe_fsync => now;
        while (oe_fsync.nextMsg() != 0)
    	{
	    oe_fsync.getString();
	    220.0 => s.freq;
	    1.0 => s.noteOn;
    	}
    }
}

fun void inst_fcntl()
{
    TriOsc car => BPF fil1 => ADSR a => JCRev j => dac;
    SinOsc mod => BPF fil2 => blackhole;
    0.2 => car.gain;

    a.set(10::ms, 500::ms, 1.0, 10::ms);
    a.keyOff();
    400.0 => float cf => car.freq;
    20.0 =>  float mf =>  mod.freq;
    .2 => float depth;
    2000 => fil1.freq;
    0.5 => fil1.Q;
    5000 => fil2.freq;
    0.5 => fil2.Q;
    0.1 => j.mix;
    while(true) {
        oe_fcntl => now;
	 0::ms=> now;
	 a.keyOff();
        while (oe_fcntl.nextMsg() != 0)
    	{
	    oe_fcntl.getString() => string ptr;
	    if (ptr == "F_GETFL") {
	       120.0 => car.freq;
	    }
	    if (ptr == "F_SETFL") {
	       240.0 => car.freq;
	    }
	    if (ptr == "F_GETFD") {
	       480.0 => car.freq;
	    }
	    if (ptr == "F_SETFD") {
	       960.0 => car.freq;
	    }
	    a.keyOn();
    	}
	 250::ms=> now;
	 a.keyOff();
    }
}
