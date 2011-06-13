/* Libraries */
import org.openkinect.*;
import org.openkinect.processing.*;
import hypermedia.video.*;
import java.awt.Point;
import java.awt.Rectangle;
import processing.video.*;

int lastTime = 0;
PVector dest;
ArrayList attractorBs;

void setup() {
  size(640, 480);
  background(0);
  smooth();
  setupBlobDetection();

  attractorBs = new ArrayList();
  
  /* set here the destination that the attractors should be running to or use the mousePressed event below to adjust */
  dest = new PVector(width/2, height+20);
}

void draw() {
  updateMask();
  fill(0,10);
  rect(0,0,width,height);

  // create a new "attractor" running from the "foot" of the blob approx. every second
  if (millis() - lastTime > 1000) {
    if (blobs != null) {
      for (int i = 0; i < blobs.length; i++) {
        // calculate the vector running from the dest to the center of this blob (center being the center of the bounding box)
        PVector bCenter = blobCenter(blobs[i]);      
        PVector dir = new PVector();
        dir.set(bCenter);
        dir.sub(dest);
        // calculate the vector which is 60% of the length of the vector running from dest to the blob center
        // 60% is what we found to work best with the skew of the projection
        float distance = dir.mag(); 
        dir.normalize();
        dir.mult(distance * 0.60); 
        dir.add(dest);
       
         // add two new attractors - a white one (because it's a brighter and bolder on the floor) and a coloured partner to make it look more interesting
        attractorBs.add(new AttractorB(dir, color(255), 10));
        attractorBs.add(new AttractorB(dir, color(random(200, 255),random(0,200),random(0,100)), 10));        
      }
    }
    lastTime = millis();
  }
  println("num attractors = " + attractorBs.size());
  stroke(255);
  strokeWeight(1);
  for (int i = 0; i < attractorBs.size(); i++) {
    AttractorB b = (AttractorB) attractorBs.get(i);
    b.update();
    b.draw();
    if (b.isDead) {
      attractorBs.remove(i);
    }
  }
  if (showBlobs) {
   drawBlobOutlines();
  }
}

void drawBlobOutlines() {
  noFill();
  stroke(255);
  for (int i = 0; i < blobs.length; i++) {
    beginShape();
    for (int j = 0; j < blobs[i].points.length; j++) {
      vertex(blobs[i].points[j].x, blobs[i].points[j].y);
    }
    endShape(CLOSE);
  }
}

void mousePressed() {
  dest.x = mouseX; 
  dest.y = mouseY;
}

void stop() {
  stopBlobDetection();
  super.stop();
}
