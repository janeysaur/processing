ArrayList brownianPoints = new ArrayList();
ArrayList orbs = new ArrayList();
ArrayList maskBlobs = new ArrayList();
GridPoint[] gridPoints;
int totalPoints;
int numCols, numRows;
float spawnThreshold = 10.0;
int lastUpdated = 0;


void setupForeground() {
  foregroundImage.beginDraw();
  foregroundImage.background(0);
  backgroundImage.endDraw();
  setupGrid();
}

void setupGrid() {
  totalPoints = (int) width/10 * height/10;
  numCols = (int) width/10;
  numRows = (int) height/10;
  gridPoints = new GridPoint[totalPoints];
  for (int y = 0; y < numRows; y++) {
    for (int x = 0; x < numCols; x++) {
      // initialise points 
      GridPoint g = new GridPoint(new PVector(x*10, y*10));
      gridPoints[(y * numCols) + x] = g;
    }
  }
}

void updateGrid() {
  maskBlobs.clear();
  boolean blobAdded;
  if (blobs != null) {
    PVector pos = new PVector();
    for( int i = 0; i < blobs.length; i++) {
      blobAdded = false;
      for(int j = 0; j < blobs[i].points.length; j++) {
        pos.x = blobs[i].points[j].x;
        pos.y = blobs[i].points[j].y;
        // find the grid square this point falls in
        int x = (int) pos.x / 10;
        int y = (int) pos.y / 10;
        int index = (y * numCols) + x;

        if (index < totalPoints) {
          GridPoint g = (GridPoint) gridPoints[index];
          boolean alreadyOn = g.isOn && (g.counter - 0.9 > spawnThreshold);
          // find the next blob point 
          int nextPoint = (j + 1) % blobs[i].points.length;
          PVector nextPos = new PVector(blobs[i].points[nextPoint].x, blobs[i].points[nextPoint].y);
          // get the normal of the line between this point and the next blob point
          PVector dir = PVector.sub(nextPos, pos);
          dir.normalize();
          // rotate 90 degrees around z axis
          PVector vel = new PVector(-dir.y, dir.x);
          g.inc(2.0, vel);
          if (alreadyOn && g.isOn && !blobAdded) {
            maskBlobs.add(blobs[i]);
            blobAdded = true;                        
          }
        }
      }
    }
  }
  for (int i = 0; i < totalPoints; i++) {
    GridPoint g = (GridPoint) gridPoints[i];
    g.dec(0.9);
    PVector pos = new PVector();
    pos.x = (int) (i % numCols) * 10;      
    pos.y = (int) (i / numCols) * 10;
    if (g.counter >= spawnThreshold && (g.reSpawn || !g.isOn)) {
      BrownianPoint p = new BrownianPoint(pos, g.outwardDirection, 100, i);
      brownianPoints.add(p);
      g.isOn = true;
      g.reSpawn = false;

      if (brownianPoints.size() % 4 == 0) {
        pos.add(PVector.mult(g.outwardDirection, random(10, 30)));
        pos.x += random(-10, 10);
        pos.y += random(-10, 10);
        Orb orb = new Orb(pos,  i);
        orbs.add(orb);
      }
    } 
  }
}

void updateForeground() {
  if (millis() - lastUpdated > 300) { // how often the grid is updated controls how quickly the surrounding lines are started
    updateGrid();
    lastUpdated = millis(); 
  }
  foregroundImage.beginDraw();
  foregroundImage.noStroke();
  if (keyPressed && key == 'c') {
    foregroundImage.fill(0);
  } else {
    foregroundImage.fill(0, 1);
  }
  foregroundImage.rect(0, 0, width, height);
  foregroundImage.noStroke();
  for (int i = 0; i < brownianPoints.size(); i++) {
    BrownianPoint localPoint = (BrownianPoint) brownianPoints.get(i);
    if (localPoint.isDead == true) {
      brownianPoints.remove(i);
    }
    localPoint.update();
    localPoint.draw(foregroundImage);
  }
  
  for (int i = 0; i < orbs.size(); i++) {
    Orb o = (Orb) orbs.get(i);
    if (o.isDead) {
      orbs.remove(i);
    }
    o.draw(foregroundImage);
    o.update();
  }
  
  if (maskBlobs.size() > 0) {
      foregroundImage.fill(0);
      foregroundImage.noStroke();
      drawBlobsList(maskBlobs, foregroundImage);
  }  
  foregroundImage.endDraw();
}



class GridPoint {
  float counter;
  boolean isOn, reSpawn;
  boolean updated;
  PVector origin;
  PVector outwardDirection;

  public GridPoint(PVector p) {
    counter = 0;
    isOn = false;
    origin = p;
    outwardDirection = new PVector(0,0);
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
    } else {
      counter = 0;
    }
    if (counter < 5) {
      isOn = false;
    }
  }
}



