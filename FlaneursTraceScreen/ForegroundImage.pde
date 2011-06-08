PGraphics foregroundImage;
ArrayList brownianPoints = new ArrayList();
ArrayList orbs = new ArrayList();
ArrayList maskBlobs = new ArrayList();
GridPoint[] gridPoints;
int totalPoints;
int numCols, numRows;
float spawnThreshold = 10.0;
float dieThreshold = 9.0;
int lastUpdated = 0;
float diagonalDistance;

void setupForeground() {
  foregroundImage = createGraphics(_width, _height, JAVA2D);
  foregroundImage.beginDraw();
  foregroundImage.background(0);
  foregroundImage.colorMode(HSB);
  backgroundImage.endDraw();
  setupGrid();
  diagonalDistance = (new PVector(_width, _height)).mag();
}

void setupGrid() {
  totalPoints = (int) _width/10 * _height/10;
  numCols = (int) _width/10;
  numRows = (int) _height/10;
  gridPoints = new GridPoint[totalPoints];
  for (int y = 0; y < numRows; y++) {
    for (int x = 0; x < numCols; x++) {
      // initialise points 
      GridPoint g = new GridPoint(new PVector(x*10, y*10));
      gridPoints[(y * numCols) + x] = g;
    }
  }
}

void updateForeground() {
  // how often the grid is updated controls how quickly the surrounding lines are started
  if (millis() - lastUpdated > 300) { 
    updateGrid();
    lastUpdated = millis();
  }
  foregroundImage.beginDraw();
  foregroundImage.noStroke();
  if (keyPressed && key == 'c') {
    foregroundImage.fill(0);
  } 
  else {
    foregroundImage.fill(0, 1);
  }
  foregroundImage.rect(0, 0, _width, _height);  
  drawBrownianPoints(foregroundImage);  
  drawOrbs(foregroundImage);
  drawMaskBlobs(foregroundImage);
  foregroundImage.endDraw();
}

void drawBrownianPoints(PGraphics pg) {  
  for (int i = 0; i < brownianPoints.size(); i++) {
    BrownianPoint localPoint = (BrownianPoint) brownianPoints.get(i);
    if (localPoint.isDead == true) {
      brownianPoints.remove(i);
    }
    localPoint.update();
    localPoint.draw(pg);
  }
}

void drawOrbs(PGraphics pg) {
  for (int i = 0; i < orbs.size(); i++) {
    Orb o = (Orb) orbs.get(i);
    if (o.isDead) {
      orbs.remove(i);
    }
    o.draw(pg);
    o.update();
  }
}

void drawMaskBlobs(PGraphics pg) {
  if (maskBlobs.size() > 0) {
    pg.fill(0);
    pg.stroke(255, 0, 0);
//    pg.noStroke();
    for ( int i = 0; i < maskBlobs.size(); i++) {
      pg.beginShape();
      Blob b = (Blob) maskBlobs.get(i);
      for (int j = 0; j < b.points.length; j++) {
        pg.vertex(b.points[j].x, b.points[j].y);
      }
      pg.endShape(CLOSE);
    }
  }
}

void updateGrid() {
  maskBlobs.clear();
  if (blobs != null) {
    incrementGridPoints();
  }   
  decrementGridPoints();
} 

void incrementGridPoints() {
  boolean blobAdded, alreadyOn;
  int x, y, index, nextPoint;
  PVector pos = new PVector();
  PVector nextPos = new PVector();
  for (int i = 0; i < blobs.length; i++) {
    blobAdded = false;
    for (int j = 0; j < blobs[i].points.length; j++) {
      setPVectorFromPoint(pos, blobs[i].points[j]);
      index = gridIndexFromPoint(pos);

      if (index < totalPoints) {
        GridPoint g = (GridPoint) gridPoints[index];
        alreadyOn = g.isOn && (g.counter - 0.9 > spawnThreshold);
        // find the next blob point 
        nextPoint = (j + 1) % blobs[i].points.length;
        setPVectorFromPoint(nextPos, blobs[i].points[nextPoint]);

        // get the normal of the line between this point and the next blob point
        PVector heading = findNormal(pos, nextPos);
        g.inc(2.0, heading);
        if (alreadyOn && g.isOn && !blobAdded) {
          maskBlobs.add(blobs[i]);
          blobAdded = true;
        }
      }
    }
  }
}

void decrementGridPoints() {
  for (int i = 0; i < totalPoints; i++) {
    GridPoint g = (GridPoint) gridPoints[i];
    g.dec(0.9);
    PVector pos = new PVector();
    pos.set(g.origin);
    if (g.counter >= spawnThreshold && (g.reSpawn || !g.isOn)) {
      BrownianPoint p = new BrownianPoint(pos, g.outwardDirection, 100, i);
      brownianPoints.add(p);
      g.isOn = true;
      g.reSpawn = false;

      if (brownianPoints.size() % 4 == 0) {
        float d = random(10, 30);
        pos.add(PVector.mult(g.outwardDirection, random(10, 30)));
        pos.x += random(-d, d);
        pos.y += random(-d, d);
        Orb orb = new Orb(pos,  i, d);
        orbs.add(orb);
      }

    }
  }
}

void setPVectorFromPoint(PVector v, Point p) {
  v.x = p.x;
  v.y = p.y;
}

int gridIndexFromPoint(PVector p) {
  int x, y;
  x = (int) p.x / 10;
  y = (int) p.y / 10;
  return (y * numCols) + x;
}

PVector findNormal(PVector v1, PVector v2) {
  PVector dir = PVector.sub(v2, v1);
  dir.normalize();
  // rotate 90 degrees around z axis
  return new PVector(-dir.y, dir.x);
}

class GridPoint {
  int x, y;
  float counter;
  boolean isOn, reSpawn;
  boolean updated;
  PVector origin;
  PVector outwardDirection;

  public GridPoint(PVector p) {
    counter = 0;
    isOn = false;
    origin = p;
    outwardDirection = new PVector(0, 0);
    updated = false;
    reSpawn = false;
  }

  void inc(float i, PVector dir) {
    if (!updated) {      
      if (counter < 10) {
        counter = max(counter+1, 10);
      }
      outwardDirection.x = dir.x;
      outwardDirection.y = dir.y;
      updated = true;
    }
  }

  void dec(float i) {
    if (counter > 0) {    
      counter -= i;
      updated = false;
    } 
    else {
      counter = 0;
    }
    if (counter < dieThreshold) {
      isOn = false;
    }
  }
}


class BrownianPoint {

  PVector pos, vel; 
  PVector newPos;
  boolean isDead;
  int gridPointIndex;
  int step;
  float lifeTime;
  float distance;

  public BrownianPoint(PVector _pos, PVector _vel, float _lifeTime, int gIndex) {
    pos = _pos;
    vel = _vel;
    lifeTime = _lifeTime;
    isDead = false;
    gridPointIndex = gIndex;
    newPos = new PVector();
    newPos.set(pos);
    step = 3;
  }

  void update() {
    GridPoint g = (GridPoint) gridPoints[gridPointIndex];  
    distance = PVector.dist(g.origin, pos);
    
    newPos.add(vel);
    newPos.x += (int) random(-step, step);
    newPos.y += (int) random(-step, step);

    if(newPos.x < 0 || newPos.x > width || newPos.y < 0 || newPos.y > height) {
      isDead = true;
    }

    if (!g.isOn) {
      isDead = true;
    }
    lifeTime--;
    if (lifeTime < 0) {
      lifeTime = 100;
      g.reSpawn = true;
    }
  }

  void draw(PGraphics pg) {   
    if (isDead) return;
    pg.strokeWeight(2);
//    pg.stroke(map(distance, 0, diagonalDistance/4, 70, 360), 
//      map(distance, 0, diagonalDistance/4, 3, 100), map(distance, 0, diagonalDistance/4, 80, 100), 60);    
//    float h = map(distance, 0, diagonalDistance/4, 170, 240);
//    float h = map(distance, 0, diagonalDistance, 120, 240);
    float h = map(distance, 0, diagonalDistance, 220, 240);

    if (distance < 0 || distance > diagonalDistance) {
      println("out of bounds");
    }
    float s = map(distance, 0, diagonalDistance, 200, 255);
    float b = 204;
    pg.stroke(h, s, b, 120);
    pg.line(pos.x, pos.y, newPos.x, newPos.y);
    pos.set(newPos);
  }
};

