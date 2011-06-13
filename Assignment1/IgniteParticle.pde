class IgniteParticle extends Particle {
  IgniteParticle(PVector origin, PVector velocity, float r, int lifetime, color col) {
    super(origin, velocity, r, lifetime, col);
  }
  
  void update() {
    pos.add(vel);
    timer--;
  }
  
  void display() {
    ellipseMode(CENTER);
    noStroke();
    fill(pColor, timer);
    ellipse(pos.x + random(-2, 2), pos.y + random(-2, 2), radius*2, radius*2);
  }
  
}
