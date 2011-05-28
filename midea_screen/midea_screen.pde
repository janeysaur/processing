import org.openkinect.*;
import org.openkinect.processing.*;
import hypermedia.video.*;
import java.awt.Point;
import processing.video.*;



OpenCV opencv;
Kinect kinect;
PImage kinectDepthBackgroundImage;
PImage kinectDepthImage;
PImage opencvBlobImage;
Blob[] blobs;

PGraphics backgroundImage;
PGraphics foregroundImage;
PGraphics maskImage;
PImage displayImage;

boolean toggleMask = true;
boolean toggleBackground = true;
boolean toggleForeground = true;

MovieMaker mm;
boolean recordMovie = false;

void setup() {
  size(640, 480);

  // Allocate some memories for working with the Kinect
  kinectDepthBackgroundImage = createImage(width, height, RGB);
  kinectDepthImage = createImage(width, height, RGB);
  opencvBlobImage = createImage(width/2, height/2, RGB);

  setupOpenCV(width/2, height/2);
  setupKinect();

  // Allocate memory for storing background and mask images
  backgroundImage = createGraphics(width, height, JAVA2D);
  maskImage = createGraphics(width, height, JAVA2D);
  foregroundImage = createGraphics(width, height, JAVA2D);
  setupBackground();
  setupForeground();
  
  if (recordMovie) {
      mm = new MovieMaker(this, width, height, "midea-with-paintbrush.mov", 30, MovieMaker.H263, MovieMaker.HIGH);
  }
  frameRate(20);
}

void setupOpenCV(int w, int h) {
  opencv = new OpenCV(this);
  opencv.allocate(w, h);
}

void setupKinect() {
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
}

void draw() { 
  background(0);
  updateBackground();
  updateMask();
  updateForeground();
  loadPixels();
  maskImage.loadPixels();
  backgroundImage.loadPixels();
  foregroundImage.loadPixels();
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      int loc = (y * width) + x;
      color pix = maskImage.pixels[loc];      
      if ((pix & 0xFFFFFF) == 0) {
        pixels[loc] = foregroundImage.pixels[loc];
      } else {
        pixels[loc] = backgroundImage.pixels[loc];
      }
    }
  }
  updatePixels();
  if (recordMovie) {
    mm.addFrame();
  }
}

void keyPressed() {
  if (key == 'm') {
    toggleMask = !toggleMask;
    println("toggleMask = " + toggleMask);
  }
  if (key == 'b') {
    toggleBackground = !toggleBackground;
    println("toggleBackground = " + toggleBackground);
  }
  if (key == 'f') {
    toggleForeground = !toggleForeground;
  }
  if (key == 'm' && recordMovie) {
    mm.finish();
    println("movie finished");
  }
}

void stop() {
  kinect.quit();
  opencv.stop();
  super.stop();
}  

