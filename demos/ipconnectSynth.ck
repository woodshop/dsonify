OscRecv recv;
9000 => recv.port;
recv.listen();
recv.event( "ipconnect, s" ) @=> OscEvent oe_ipconnect;

spork ~ inst_ipconnect();
1::day => now;

fun void inst_ipconnect()
{
    SqrOsc car => LPF fil => ADSR a => JCRev j => dac;
    0.5 => car.gain;
    0.08 => j.mix;
    5000 => fil.freq;
    0.5 => fil.Q;
    a.set(1::ms, 500::ms, 1.0, 500::ms);

    while(true) {
        oe_ipconnect => now;
        while (oe_ipconnect.nextMsg() != 0)
        {
            oe_ipconnect.getString() => string ptr;
            <<<"Connecting to port "+ptr>>>;
            Std.atoi(ptr) => car.freq;
            a.keyOn();
            1::ms => now;
            a.keyOff();
        }
    }
}