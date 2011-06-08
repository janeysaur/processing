class Orb {
  color col;
  boolean expanding, isDead;
  int minSize, maxSize, currentSize, sWeight;
  int gridPointIndex;
  PVector pos;  
  float distance;
  float maxDistance = diagonalDistance;
  float h, s, b;
  
  Orb (PVector p, int gPoint, float d) {
    gridPointIndex = gPoint;
    pos = new PVector(p.x, p.y);
    maxSize = (int) d;
    currentSize = (int) random(0, d);
    expanding = true;
    isDead = false;
    GridPoint g = (GridPoint) gridPoints[gridPointIndex];    
    distance = PVector.dist(p, g.origin);    
    h = map(distance, 0, maxDistance, 180, 200);
//    float h = map(distance, 0, diagonalDistance, 120, 240);
    s = map(distance, 0, maxDistance, 200, 255);
    b = 204;
  }
  
  
  void update() {
    GridPoint g = (GridPoint) gridPoints[gridPointIndex];    
    if (!g.isOn) {
      isDead = true;
    }
    
    if (expanding && currentSize < maxSize) {
      currentSize++;
      if (currentSize == maxSize) {
        expanding = false;
      }
    } else {
      currentSize--;
      if (currentSize < 0) {
        isDead = true;
      }
    }
  }

  void draw(PGraphics pg) {
    pg.noStroke();
    pg.fill(h, s, b, 60);
    pg.ellipse(pos.x, pos.y, currentSize, currentSize);
  }

}
