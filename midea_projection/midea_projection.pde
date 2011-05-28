import org.openkinect.*;
import org.openkinect.processing.*;
import hypermedia.video.*;
import java.awt.Point;
import java.awt.Rectangle;
import processing.video.*;

OpenCV opencv;
Kinect kinect;
PImage kinectDepthBackgroundImage;
PImage kinectDepthImage;
PImage opencvBlobImage;
Blob[] blobs;

PGraphics maskImage;
PVector startPoint;

MovieMaker mm;  
boolean recordMovie = true;

void setup() {
  size(640, 480);
  startPoint = new PVector(width/2, 0);

  // Allocate some memories for working with the Kinect
  kinectDepthBackgroundImage = createImage(width, height, RGB);
  kinectDepthImage = createImage(width, height, RGB);
  opencvBlobImage = createImage(width/2, height/2, RGB);

  setupOpenCV(width/2, height/2);
  setupKinect();

  maskImage = createGraphics(width, height, JAVA2D);

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
  updateMask();
  image(maskImage, 0, 0);
}

void stop() {
  kinect.quit();
  opencv.stop();
  super.stop();
}  

