OscRecv recv;
9000 => recv.port;
recv.listen();
recv.event( "ipconnect, s" ) @=> OscEvent oe_ipconnect;

main();

fun void main() {
    spork ~ inst_ipconnect();
    1::day => now;
}

fun void inst_ipconnect()
{
    // some synth shit
    SqrOsc car => LPF fil => ADSR a => JCRev j => dac;
    0.5 => car.gain;
    700 => car.freq;
    0.08 => j.mix;
    5000 => fil.freq;
    0.5 => fil.Q;
    
    a.set(10::ms, 500::ms, 1.0, 10::ms);
    a.keyOff();
    
    while(true) {
        oe_ipconnect => now;
        0::ms => now;
        a.keyOff();
        
        while (oe_ipconnect.nextMsg() != 0)
        {
            oe_ipconnect.getString() => string ptr;
            Std.atoi(ptr) => car.freq;
            a.keyOn();
        }
        520::ms => now;
        a.keyOff();
    }
}

