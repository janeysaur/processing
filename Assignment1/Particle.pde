/*
  Modified from: Processing - a programming handbook for visual designers and artists 
  Chapter: Particle Systems 
*/

class Particle {
  PVector pos;
  PVector vel;
  PVector acc;
  float radius;   // particle radius
  int timer;
  color pColor;

  Particle(PVector origin, PVector velocity, float r, int lifetime, color col) {
    acc = new PVector(0,0.05, 0);
    pos = origin.get();
    vel = velocity.get();
    radius = r;
    timer = lifetime;
    pColor = col;
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
    timer--;
  }

  void display() {
    ellipseMode(CENTER);
    noStroke();
    fill(pColor, timer);
    if (timer < 30) {
      // add a bit of 'fizzle' at the end
      ellipse(pos.x + random(-2, 2), pos.y + random(-2, 2), radius*2, radius*2);
    } else {
      ellipse(pos.x, pos.y, radius*2, radius*2);
    }
  }
  
  void run() {
    update();
    display();
  }
  
  boolean dead() {
    if (timer <= 0 || pos.y > height) {
      return true;
    } else {
      return false;
    }
  }
  
  
}

