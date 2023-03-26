class container{
    float cVol;         //Volume of main gas chamber IN [m^3]
    float tHeight;      //Height of tube (total)
    float tRad;         //Radius of the tube IN [m]
    float tArea;        //Area of the tube

    float v_0;  //Total volume of chamber + tube combined

    container(float chamberVolume, float tubeHeight, float tubeRadius){
        cVol    = chamberVolume;
        tHeight = tubeHeight;
        tRad    = tubeRadius;
        tArea   = PI*pow(tubeRadius, 2);

        v_0 = cVol + tHeight*tArea;
    }

    //pass
}