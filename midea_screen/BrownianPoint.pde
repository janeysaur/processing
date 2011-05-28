
class BrownianPoint {

  PVector pos, vel; 
  PVector newPos;
  boolean isDead;
  int gridPointIndex;
  int step;
  color col;
  float lifeTime;

  public BrownianPoint(PVector _pos, PVector _vel, float _lifeTime, int gIndex) {
    pos = _pos;
    vel = _vel;
    lifeTime = _lifeTime;
    isDead = false;
    gridPointIndex = gIndex;
    newPos = new PVector();
    newPos.set(pos);
    step = 3;
    col = color(random(200, 255),random(0,200),random(0,100));
  }

  void update() {
    GridPoint g = (GridPoint) gridPoints[gridPointIndex];    
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
    pg.stroke(col); 
    pg.line(pos.x, pos.y, newPos.x, newPos.y);
    pos.set(newPos);
  }
};

