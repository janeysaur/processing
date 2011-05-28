//
//class PerlinPoint {
//
//  PVector pos, vel, noiseVec;
//  float noiseFloat, lifeTime, age;
//  boolean isDead;
//  int gridPointIndex;
//
//  public PerlinPoint(PVector _pos, PVector _vel, float _lifeTime, int gIndex) {
//    pos = _pos;
//    vel = _vel;
//    lifeTime = _lifeTime;
//    age = 0;
//    isDead = false;
//    gridPointIndex = gIndex;
//    noiseVec = new PVector();
//  }
//
//  void update() {
//    noiseFloat = noise(pos.x * 0.0025, pos.y * 0.0025, elapsedFrames * 0.001);
//    noiseVec.x = cos(((noiseFloat -0.3) * TWO_PI) * 10);
//    noiseVec.y = sin(((noiseFloat - 0.3) * TWO_PI) * 10);
//
//    vel.add(noiseVec);
//    vel.div(2);
//    PVector tempP = new PVector(pos.x, pos.y);
//    tempP.add(vel);
//    if(tempP.x < 0 || tempP.x > width || tempP.y < 0 || tempP.y > height) {
//      vel.mult(-1);
//    }
//    pos.add(vel);
//
////    if(1.0-(age/lifeTime) == 0) {
////      isDead = true;
////    }
//    
//    GridPoint g = (GridPoint) gridPoints[gridPointIndex];    
//    if (!g.isOn) {
//      isDead = true;
//    }
//
//
//    age++;
//  }
//
//  void draw(PGraphics pg) {   
//    pg.fill(255);
//    pg.noStroke();
////    pg.ellipse(pos.x-2, pos.y-2, 3-(age/lifeTime), 3-(age/lifeTime));
//    pg.ellipse(pos.x, pos.y, 3-(age/lifeTime), 3-(age/lifeTime));
////    pg.ellipse(pos.x+2, pos.y+2, 3-(age/lifeTime), 3-(age/lifeTime));
//  }
//};
