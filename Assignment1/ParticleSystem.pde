// Modified from the Processing.org examples
// A class to describe a group of Particles
// An ArrayList is used to manage the list of Particles 

class ParticleSystem {

  ArrayList particles;    // An arraylist for all the particles
  PVector origin;        // An origin point for where particles are born

  ParticleSystem(int num, PVector v, color col) {
    particles = new ArrayList();              // Initialize the arraylist
    origin = v.get();                        // Store the origin point
    for (int i = 0; i < num; i++) {
      PVector vel = new PVector(random(-1,1), random(-2, 0), 0);
      int lifetime = int(random(50,100)); 
      particles.add(new Particle(origin, vel, 2.5, lifetime, col));    // Add "num" amount of particles to the arraylist
    }
  }

  void run() {
    // Cycle through the ArrayList backwards b/c we are deleting
    for (int i = particles.size()-1; i >= 0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run();
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }

  // A method to test if the particle system still has particles
  boolean dead() {
    if (particles.isEmpty()) {
      return true;
    } else {
      return false;
    }
  }

}
