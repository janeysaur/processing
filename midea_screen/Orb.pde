class Orb {
  color col;
  boolean expanding, isDead;
  int minSize, maxSize, currentSize, sWeight;
  int gridPointIndex;
  PVector pos;  
  
  Orb (PVector p, int gPoint) {
    gridPointIndex = gPoint;
    pos = new PVector(p.x, p.y);
    minSize = (int) random(0, 10);
    maxSize = (int) random(10, 30);
    currentSize = (int) random(0, 20);
    expanding = true;
    isDead = false;
    col = color(random(200, 255),random(0,200),random(0,100));
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
      if (currentSize < minSize) {
        isDead = true;
      }
    }
  }


  void draw(PGraphics pg) {
//    pg.strokeWeight(1);
    pg.stroke(col);
    pg.fill(col, 30);
    pg.ellipse(pos.x, pos.y, currentSize, currentSize);
  }

}
