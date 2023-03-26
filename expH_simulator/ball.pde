class ball{
    PVector pos;    //Treating container top as origin
    PVector vel;
    PVector acc;

    float m;    //Mass of the ball compressing the gas

    ball(float mass, PVector initPos, PVector initVel, PVector initAcc){
        m = mass;
        pos = initPos;
        vel = initVel;
        acc = initAcc;
    }

    //pass
}