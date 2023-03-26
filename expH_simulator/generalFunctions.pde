float vecMag(PVector v){
    return sqrt( pow(v.x, 2)+pow(v.y, 2) );
}
PVector vecUnit(PVector v){
    float mag = vecMag(v);
    if(mag != 0.0){
        return new PVector(v.x/mag, v.y/mag);}
    else{
        return new PVector(0,0);}
}