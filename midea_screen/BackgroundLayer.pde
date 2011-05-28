// Based on Felix Turner's Perlin Noise Field 
// (airtightinteractive.com)

float fadeAmount;
float maxLen = 100;
float strokeAmount;
ArrayList brushes;
int numBrushes = 200;

void setupBackground() {
  backgroundImage.beginDraw();
  backgroundImage.colorMode(RGB, 113, 20, 10);
  backgroundImage.background(0);
  backgroundImage.noFill();
  backgroundImage.stroke(0);
  backgroundImage.endDraw();
  
  fadeAmount = 5; //random(.5,20); 
  maxLen = random(150, 200); //maxLen = random(30,200);
  strokeAmount = 0.07; //  strokeAmount = random(0.02,0.3);

  brushes = new ArrayList();
  for(int i=0; i < numBrushes; i++) {
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
    sColor = map(x, 0, width, 0, 100);
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
    
    if (initBrushLines) {
      level1_left.setStart(center.start, PVector.mult(vel, sWeight));
      level1_right.setStart(center.start, PVector.mult(vel, sWeight * -1));
      level2_left.setStart(center.start, PVector.mult(vel, sWeight * 1.5));
      level2_right.setStart(center.start, PVector.mult(vel, sWeight * -1.5));      
      initBrushLines = false;
    }

    level1_left.setEnd(center.end, PVector.mult(vel, sWeight));
    level1_right.setEnd(center.end, PVector.mult(vel, sWeight * -1));
    level2_left.setEnd(center.end, PVector.mult(vel, sWeight * 1.5));
    level2_right.setEnd(center.end, PVector.mult(vel, sWeight * -1.5));
        
    center.draw(sWeight, sColor, pg);
    level1_left.draw(sWeight / 4, sColor * 1.2, pg);
    level1_right.draw(sWeight / 4, sColor * 1.2, pg);
    level2_left.draw(sWeight / 16, sColor * 1.5, pg);
    level2_right.draw(sWeight / 16, sColor * 1.5, pg);
        
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
    pg.stroke(sColor,80,90);
    pg.line(start.x,start.y,end.x,end.y);
    
    start.set(end);
  }

}

