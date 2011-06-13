/* Jane Sivieng 

** Describe how you've been thinking about working with the SmartSlab: **

 -- animation should catch people's attention as they walk past and entice them to stop and watch
 -- need a point of interest
 -- should be interesting but not distracting so people can watch while having lunch without being bored
   -- i.e. don't try to induce epileptic fits :P
 -- from observation, when the smartslab is filled with a bright colour, the divisions in the screen (vertical and horizontal lines) become more obvious
 -- use an animation where the background is primarily black so that the lines don't detract from the visuals 

 -- final idea: 
   * black background 
   * top - random 'fireworks'
   * use particle effects modified from examples on the web/books 
    -- added a bit of random movement to the particles as they come to the end of their 'life' such that they 'fizzle out'
    -- added onion skinning to the fireworks portion of the animation to make the transitions look smoother and more realistic? 
    -- randomised the position of the fireworks explosions 
    -- randomised the color of the explosion from an array of the primary and secondary colours
    -- later added a 'rocket' element to the fireworks to simulate a rocket firing into the sky and exploding into fireworks
    -- later - changed it so that 1-4 rockets will fire together at the same time and explode ~ at the same time 
        -- this makes it look a bit more choreographed, like real fireworks, when many will go off together
    -- added a second particle explosion (white) just beneath the original coloured particle system to help highlight the 'fireworks'
        -- this helps to highlight the explosion, especially for colours like blue which don't seem to show up as well as e.g. green or purple.

   * bottom - cityscape/skyline of buildings (easier to draw and randomly generate)
      -- bold grey outline of buildings will let me test how well bold lines appear on the smartslab
   * 3 different windowsets - with lights that turn on as per a particular mode 
      -- mode 1: all lights turn on and off together 
      -- mode 2: lights turn on one level at a time starting from the bottom 
      -- mode 3: lights turn on individually from the bottom right
   * every so often, we kick off one of the windowsets 
      -- people walking past might catch a glimpse of a window set turning on/off and stop to see if it will happen again 
      -- then we can surprise them with a different mode of lights turning on 
      -- try to space them out so that they only happen one at a time
   * animation seems to work well at frameRate of 30; otherwise everything happens a bit too fast
 
   * had considered making the windows 'flicker' as they come on. but there's already so much happening in the 'background' 
     it would have made it too busy. seemed better to have them solid so that there is something easy to focus on. 
 
 */




ArrayList psystems;
ArrayList rockets;
ArrayList windowSets;
// array of all the primary and secondary colours so that i can see how they display on the smartslab.
color[] pColors = {#FF0000, #00FF00, #0000FF, #FF00FF, #00FFFF, #FFFF00, #FFFFFF};
int lastTime = 0;

void setup() {
  size(600,200); // sketch size to match aspect ratio of the SmartSlab
//  frameRate(30);
  //  setupNightSky();
  background(0);
  setupSkyline();
  psystems = new ArrayList();
  rockets = new ArrayList();
  windowSets = new ArrayList();
  // 
  windowSets.add(new WindowSet(443.97467, 101.02453, 71.94452, 98.97547, 2));
  windowSets.add(new WindowSet(94.26641, 149.04286, 79.24208, 50.957138, 1));
  windowSets.add(new WindowSet(238.91467, 101.19416, 68.81561, 98.80584, 3));
}

void draw() {
  noStroke();
  fill(0, 24);
  rect(0, 0, width, height);
  //  setupNightSky();
  setupRockets();
  drawFireworks();
  drawRockets();
  setupSkyline(); // moved this to the bottom so that the fireworks can be onion skinned in the background and the skyline is always in the foreground. 

  // check if we need to turn on a new window set
  for (int i = 0; i < windowSets.size(); i++) {
    WindowSet w = (WindowSet) windowSets.get(i);
    if (millis() > w.initialStartTime) {
      w.turnOn();
      w.initialStartTime += w.waitTime;
    }
  }  
  drawWindows();  
}

//void mousePressed() {
//  println("(" + mouseX + ", " + mouseY + ")");
//  color col = pColors[rockets.size() % (pColors.length)];  
//  int lifetime = (int(random(30, 60)));
//  rockets.add(new IgniteParticle(new PVector(mouseX, mouseY), new PVector(0, -2), 2.5, lifetime, col));   
//}

// draw each firework display / particle system.
void drawFireworks() {
    for (int i = psystems.size()-1; i >= 0; i--) {
    ParticleSystem psys = (ParticleSystem) psystems.get(i);
    psys.run();
    if (psys.dead()) {
      psystems.remove(i);
    }
  }
}

void drawRockets() {
  for (int i = rockets.size()-1; i >= 0; i--) {
    IgniteParticle p = (IgniteParticle) rockets.get(i);
    p.run();
    if (p.dead()) {
      // when the rocket reaches the end of it's life, it 'explodes' into a particle sysetm of the same colour
      PVector origin = p.pos.get();
      psystems.add(new ParticleSystem(20, new PVector(origin.x, origin.y), p.pColor));
      // added an extra particle system just below with colour white, it helps to highlight the explosion
      // especially for colours like blue which don't show up as brightly.
      psystems.add(new ParticleSystem(20, new PVector(origin.x, origin.y + 2), pColors[6]));
      rockets.remove(i);
    }
  }
}

void setupRockets() {
  if (millis() - lastTime > 1000) { // every 1 second or so, fire 1-4 new rockets (fireworks)
    randomSeed(lastTime);
    int n = int(random(1, 4));
    for (int i = 0; i < n; i++) {
      fireRocket();
    }
    lastTime = millis();
  }
}

void fireRocket() {
  float origin = int(random(0, width));
  int colIndex = int(random(0, pColors.length - 1));
  color col = pColors[colIndex];  
  int lifetime = (int(random(30, 80)));
  rockets.add(new IgniteParticle(new PVector(origin, random(height - 40, height - 20)), new PVector(0, -2), 2.5, lifetime, col));     
}

void drawWindows() {
  for (int i = windowSets.size() - 1; i >= 0; i--) {
    WindowSet ws = (WindowSet) windowSets.get(i);
    if (ws.on) {
      ws.run();
    }
  }
}
