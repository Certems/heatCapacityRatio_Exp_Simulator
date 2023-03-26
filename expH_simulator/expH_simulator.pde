ArrayList<combSystem> systems = new ArrayList<combSystem>();
combSystem s1;
combSystem s2;
combSystem s3;

void setup(){
    fullScreen();

    s1 = new combSystem( new PVector(1.0*width/4.0, height/4.0), new container(0.01285, 1.0, 0.00975), new ball(0.086, new PVector(0,0), new PVector(0,0), new PVector(0,0)), new gas(1.667) );
    s2 = new combSystem( new PVector(2.0*width/4.0, height/4.0), new container(0.01285, 1.0, 0.00975), new ball(0.086, new PVector(0,0), new PVector(0,0), new PVector(0,0)), new gas(1.4) );
    s3 = new combSystem( new PVector(3.0*width/4.0, height/4.0), new container(0.01285, 1.0, 0.00975), new ball(0.086, new PVector(0,0), new PVector(0,0), new PVector(0,0)), new gas(1.2) );
    systems.add(s1);systems.add(s2);systems.add(s3);
}
void draw(){
    background(30,30,30);

    calcSystems();
    displaySystems();

    systems.get(0).displayOverlay();
}
void keyPressed(){
    //pass
}
