class combSystem{
    PVector cPos;   //Center-Top position to display the system at

    container cCon;
    ball cBall;
    gas cGas;

    float T = 20.0;  //temperature in degrees C
    float frictionCoeff = 0.004; //How much friction is present

    int genRate = 1;
    float simSpeed = 0.1;

    float scale = 200.0;    //Scales the visuals
    float radFactor = 10.0; //
    float lenFactor = 3.0;  //
    float arrowMagVel = 5.0;
    float arrowMagAcc = 20.0;
    float arrowOffset = 0.1;    //Percentage of radius offset for arrow Xpos

    combSystem(PVector centreTopPos, container currentContainer, ball currentBall, gas currentGas){
        cPos  = centreTopPos;
        cCon  = currentContainer;
        cBall = currentBall;
        cGas  = currentGas;
    }

    void calcSystem(){
        calcDynamics();
    }
    void displaySystem(){
        displayGas();
        displayContainer();
        displayBall();
    }
    void displayOverlay(){
        /*
        ####
        ## Mostly for bug fixing
        ####
        */
        pushStyle();

        textAlign(CENTER, CENTER);
        textSize(20);
        fill(255);

        text(frameRate, 30,30);
        text("BallPos; "+cBall.pos, mouseX, mouseY+20);
        
        popStyle();
    }


    //** Ball physics calcs
    //Move pos, vel, acc over to real units, then just plot in pixel coords
    void calcDynamics(){
        /*
        genRate = number of generations to run (smaller jumps, many of them => more precise
        e.g genRate = 5 => 5 runs at 1/5th params, per frame)
        */
        for(int i=0; i<genRate; i++){
            calcAcc(calcForce());
            calcVel();
            calcPos();
        }
    }
    PVector calcForce(){
        /*
        Note; +ve is downwards
        */
        //Init
        PVector force = new PVector(0,0);

        //(1) Gravity
        force.y += cBall.m*g;

        //(2) Pressure up
        float v_enc = cCon.cVol +cCon.tArea*(cCon.tHeight*scale-cBall.pos.y)/scale;
        float pressure = (p_0*pow(cCon.v_0, cGas.gamma))/(pow(v_enc, cGas.gamma));
        if(cBall.pos.y >= 0.0){ //Force only applied is ball is within tube region (e.g. is actually trapping gas)
            force.y -= pressure*cCon.tArea;}
        
        //(2) Pressure down
        if(cBall.pos.y >= 0.0){ //Force only applied is ball is within tube region (when the pressures above and below are inbalanced)
            force.y += p_0*cCon.tArea;}

        //(3) Friction
        force.x -= frictionCoeff*cBall.vel.x;
        force.y -= frictionCoeff*cBall.vel.y;

        return new PVector(force.x/genRate, force.y/genRate);
    }
    void calcAcc(PVector force){
        //F=ma
        cBall.acc.x = simSpeed*force.x/cBall.m;
        cBall.acc.y = simSpeed*force.y/cBall.m;
    }
    void calcVel(){
        cBall.vel.x += cBall.acc.x;
        cBall.vel.y += cBall.acc.y;
    }
    void calcPos(){
        cBall.pos.x += cBall.vel.x;
        cBall.pos.y += cBall.vel.y;
    }
    //** Ball physics calcs


    void displayContainer(){
        pushStyle();

        strokeWeight(3);
        stroke(255);
        fill(60,60,60);
        rectMode(CENTER);

        float startHeight = cPos.y;
        float endHeight   = cPos.y +cCon.tHeight*lenFactor*scale;

        line(cPos.x -cCon.tRad*radFactor*scale, startHeight, cPos.x -cCon.tRad*radFactor*scale, endHeight);
        line(cPos.x +cCon.tRad*radFactor*scale, startHeight, cPos.x +cCon.tRad*radFactor*scale, endHeight);
        line(cPos.x -cCon.tRad*radFactor*scale, endHeight, cPos.x +cCon.tRad*radFactor*scale, endHeight);
        rect(cPos.x, endHeight +cCon.tRad*radFactor*scale/2.0, 4.0*cCon.tRad*radFactor*scale, cCon.tRad*radFactor*scale);

        popStyle();
    }
    void displayBall(){
        pushStyle();

        //Ball
        strokeWeight(1);
        stroke(255);
        fill(80,80,80);

        ellipse(cPos.x +cBall.pos.x, cPos.y +cBall.pos.y, 2.0*cCon.tRad*radFactor*scale, 2.0*cCon.tRad*radFactor*scale);

        //Vector arrows
        displayArrowVecs();

        popStyle();
    }
    void displayArrowVecs(){
        pushStyle();

        strokeWeight(4);
        stroke(255,80,80);    //Vel
        line(cBall.pos.x +cPos.x -arrowOffset*(cCon.tRad*radFactor*scale), cBall.pos.y +cPos.y, cBall.pos.x +cPos.x +arrowMagVel*cBall.vel.x -arrowOffset*(cCon.tRad*radFactor*scale), cBall.pos.y +cPos.y +arrowMagVel*cBall.vel.y);
        stroke(80,255,80);    //Acc
        line(cBall.pos.x +cPos.x +arrowOffset*(cCon.tRad*radFactor*scale), cBall.pos.y +cPos.y, cBall.pos.x +cPos.x +arrowMagAcc*cBall.acc.x +arrowOffset*(cCon.tRad*radFactor*scale), cBall.pos.y +cPos.y +arrowMagAcc*cBall.acc.y);
        stroke(80,80,255);    //Pos
        line(cBall.pos.x +cPos.x -1.5*cCon.tRad*radFactor*scale, cPos.y, cBall.pos.x +cPos.x -1.5*cCon.tRad*radFactor*scale, cBall.pos.y +cPos.y);
        
        popStyle();
    }
    void displayGas(){
        pushStyle();

        float propEnc = cBall.pos.y/(cCon.tHeight*scale);   //Factor for how compressed the gas is
        println(propEnc);

        noStroke();
        fill(200,200,255, 150*(propEnc+0.2));
        rectMode(CORNERS);

        rect(cPos.x -cCon.tRad*radFactor*scale, cPos.y +cBall.pos.y, cPos.x +cCon.tRad*radFactor*scale, cPos.y +cCon.tHeight*lenFactor*scale);

        popStyle();
    }
}


void calcSystems(){
    for(int i=0; i<systems.size(); i++){
        systems.get(i).calcSystem();
    }
}
void displaySystems(){
    for(int i=0; i<systems.size(); i++){
        systems.get(i).displaySystem();
    }
}