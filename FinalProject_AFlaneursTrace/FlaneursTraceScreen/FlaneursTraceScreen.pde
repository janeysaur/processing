/* Libraries */
import org.openkinect.*;
import org.openkinect.processing.*;
import hypermedia.video.*;
import java.awt.Point;
import processing.video.*;

int _width = 600;
int _height = 200;
int _statusHeight = 40;

IntroText intro;
boolean resetFont = true;
boolean drawOutlines = true;

void setup() {
  size(_width, _height);
  setupBlobDetection();
  setupBackground();
  setupForeground();
  setupIntro();
}

boolean drawBlack = true;
boolean startIntro = false;

void draw() {
  smooth();  
//  updateMask();
  if (!intro.done && startIntro) {
    intro.draw();
    return;
  } 
  background(0);
  if (drawBlack) {
    return;
  }
  updateBackground();  
  updateForeground();
  loadPixels();
  maskImage.loadPixels();
  backgroundImage.loadPixels();
  foregroundImage.loadPixels(); 
  for (int y = 0; y < _height; y++) {
    for (int x = 0; x < _width; x++) {
      int loc = (y * _width) + x;
      color pix = maskImage.pixels[loc];      
      if ((pix & 0xFFFFFF) == 0) {
        pixels[loc] = foregroundImage.pixels[loc];
      } 
      else {
        pixels[loc] = backgroundImage.pixels[loc];
      }
    }
  }
  updatePixels();
  if (drawOutlines) {
    drawBlobOutlines();
  }
  updateInfo();
  if (recordMovie) {
    mm.addFrame();
  }
}

void drawBlobOutlines() {
  if (blobs == null) {
    return;
  }
  noFill();
  stroke(255);
  strokeWeight(1);
  for (int i = 0; i < blobs.length; i++) {
    beginShape();
    for (int j = 0; j < blobs[i].points.length; j++) {
      vertex(blobs[i].points[j].x, blobs[i].points[j].y);
    }
    endShape(CLOSE);
  }
}


void updateInfo() {
  int numBlobs = blobs != null ? blobs.length : 0;
  println("Blobs: " + numBlobs + "   CropY: " + cropY + "   Tilt: " + kinectAngle);
}

void keyPressed() {
  if (key == '+') {
    tiltKinect(1);
  } 
  else if (key == '-') {
    tiltKinect(-1);
  } 
  else if (key == 'b') {
    roiChanged = true;
  } 
  else if (key == 'm' && recordMovie) {
    mm.finish();
    println("movie finished");
  }
  
  if (key == CODED) {
    if (keyCode == UP) {
      updateCropY(-1);
    } 
    else if (keyCode == DOWN) {
      updateCropY(1);
    }
  }
  else if (key == '1') {
    drawBlack = !drawBlack;
  }
  else if (key == 'o') {
    drawOutlines = !drawOutlines;
  } 
  else if (key == ' ') {
    startIntro = true;
    drawBlack = false;
  }
}


void stop() {
  stopBlobDetection();
  super.stop();
}

