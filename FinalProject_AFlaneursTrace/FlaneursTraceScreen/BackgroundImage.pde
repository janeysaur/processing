// Based on Felix Turner's Perlin Noise Field 
// (airtightinteractive.com)

PGraphics backgroundImage;
float fadeAmount;
float maxLen = 100;
float strokeAmount;
ArrayList brushes;
int numBrushes = 200;

void setupBackground() {
  backgroundImage = createGraphics(_width, _height, JAVA2D);
  backgroundImage.beginDraw();
  backgroundImage.background(0);
  backgroundImage.noFill();
  backgroundImage.stroke(0);
  backgroundImage.endDraw();

  fadeAmount = 5; //random(.5,20); 
  maxLen = random(150, 200); //maxLen = random(30,200);
  strokeAmount = 0.07; //  strokeAmount = random(0.02,0.3);

  brushes = new ArrayList();
  for (int i=0; i < numBrushes; i++) {
    Brush b = new Brush(i);
    brushes.add(b);
  }
}

void updateBackground() {
  backgroundImage.beginDraw();
  backgroundImage.noStroke();
  backgroundImage.fill(0, fadeAmount);
  backgroundImage.rect(0, 0, width, height);

  for (int i = 0; i < brushes.size(); i++) {
    Brush b = (Brush) brushes.get(i);
    b.update(backgroundImage);
  }
  backgroundImage.endDraw();
}


class Brush {
  float id, s, d, sColor, len;

  PVector dir, vel;
  BrushLine center, level1_left, level1_right, level2_left, level2_right;
  boolean initBrushLines;

  Brush(float _id) {
    id = _id;
    init();
  }

  void init() {    
    float x = random(0, width);
    float y = random(0, height);
    center = new BrushLine(x, y);
    level1_left = new BrushLine(x, y);
    level1_right = new BrushLine(x, y);
    level2_left = new BrushLine(x, y);
    level2_right = new BrushLine(x, y);

    dir = new PVector();
    vel = new PVector();

    s = random(2, 7);
    len = random(1, maxLen-1);
    initBrushLines = true;
  }

  void update(PGraphics pg) {
    id += 0.01;
    float sWeight = (maxLen - len)*strokeAmount;	
    float x = center.start.x;
    float y = center.start.y;

    d = (noise(id, x/500, y/500)-0.5)*500;
    center.setEndXY(x + cos(radians(d))*s, y + sin(radians(d))*s);

    dir = PVector.sub(center.end, center.start);
    dir.normalize();

    // rotate 90 degrees counter clockwise
    vel.x = -dir.y;
    vel.y = dir.x;

    center.draw(sWeight, sColor, pg);
    len++;
    if (len >= maxLen) {
      init();
    }
  }
}

class BrushLine {
  PVector start, end;

  BrushLine(float x, float y) {
    start = new PVector(x, y);
    end = new PVector(x, y);
  }

  void setStart(PVector startPos, PVector vel) {
    setPos(start, startPos, vel);
  }  

  void setEnd(PVector endPos, PVector vel) {
    setPos(end, endPos, vel);
  }

  void setEndXY(float x, float y) {
    end.x = x;
    end.y = y;
  }

  void setPos(PVector p, PVector pos, PVector vel) {
    p.set(pos);
    p.add(vel);
  }

  void draw(float sWeight, float sColor, PGraphics pg) {
    pg.strokeWeight(sWeight);
    pg.stroke(255, 120);
    pg.line(start.x, start.y, end.x, end.y);

    start.set(end);
  }
}

