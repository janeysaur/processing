OpenCV opencv;
Kinect kinect;
PImage bgImg; // kinect depth background image cropped
PImage depthImg; // kinect depth image cropped
PImage diffImg; // kinect difference frame cropped
PImage opencvBlobImage; // opencv blob image scaled
PGraphics maskImage;
Blob[] blobs;

int _KinectWidth = 640;
int _KinectHeight = 480;
float kinectAngle = 0;
int cropY;
int scaleRatio = 4;
boolean roiChanged = true; // region of interest changed

void setupBlobDetection() {
  // Allocate some memories for working with the Kinect
  // kinect images are the same width as input but aspect ratio of display window
  bgImg = createImage(_KinectWidth, _KinectHeight/3, RGB);
  depthImg = createImage(_KinectWidth, _KinectHeight/3, RGB);
  diffImg = createImage(_KinectWidth, _KinectHeight/3, RGB);
  
  // cropY is the vertical offset to grab the center of the input image
  cropY = 147; // (_KinectHeight - depthImg.height)/2;

  opencvBlobImage = createImage(_width/scaleRatio, _height/scaleRatio, RGB);
  
  maskImage = createGraphics(_width, _height, JAVA2D);
  setupOpenCV(_width/scaleRatio, _height/scaleRatio);
  setupKinect();
}

void setupOpenCV(int w, int h) {
  opencv = new OpenCV(this);
  opencv.allocate(w, h);
}

void setupKinect() {
  kinect = new Kinect(this);
  kinect.start();
  kinect.enableDepth(true);
  kinect.tilt(kinectAngle);
}

void updateMask() {
  depthImg.copy(kinect.getDepthImage(), 0, cropY, _KinectWidth, depthImg.height, 0, 0, depthImg.width, depthImg.height);
  if (roiChanged) {
    bgImg.copy(kinect.getDepthImage(), 0, cropY, _KinectWidth, bgImg.height, 0, 0, bgImg.width, bgImg.height);
    println("Background image taken");
    roiChanged = false;
  }
  // Remove background from depth image to highlight foreground objects
  removeBackground(depthImg, bgImg, diffImg);
  // scale kinect image for opencv
  opencvBlobImage.copy(diffImg, 0, 0, diffImg.width, diffImg.height, 0, 0, opencvBlobImage.width, opencvBlobImage.height);    
  blobs = detectBlobs(opencvBlobImage);
  scaleBlobs();
  drawBlobs(blobs, maskImage);
}

void removeBackground(PImage img, PImage bg, PImage diff) {
  diff.copy(img, 0, 0, img.width, img.height, 0, 0, diff.width, diff.height);
  diff.blend(bg, 0, 0, bg.width, bg.height, 0, 0, diff.width, diff.height, DIFFERENCE);
  diff.filter(THRESHOLD, 0.01);
  diff.filter(ERODE);
  diff.filter(ERODE);
  diff.filter(ERODE);
//  diff.filter(DILATE);
//  diff.filter(DILATE);
//  diff.filter(DILATE);
}

Blob[] detectBlobs(PImage img) {
  int minBlobSize, maxBlobSize;
  minBlobSize = img.width*img.height/50;
  maxBlobSize = img.width*img.height*3/2;
  // Detect foreground objects as blobs
  opencv.copy(img);
  opencv.flip(OpenCV.FLIP_HORIZONTAL);  
//  opencv.flip(OpenCV.FLIP_VERTICAL);
//  opencv.convert(OpenCV.GRAY);
//  opencv.blur(OpenCV.BLUR, 11);
//  float thresholdVal = map(0.01, 0.0, 1.0, 0, 255);
//  opencv.threshold(50); //, 255, OpenCV.THRESH_BINARY);
//  img.copy(opencv.image(), 0, 0, opencv.width, opencv.height, 0, 0, img.width, img.height);
//  int numErodes = 3;
//  for (int i = 0; i < numErodes; i++) {
//    img.filter(ERODE);
//  }
//  int numDilates = 0;
//  for (int i = 0; i < numDilates; i++) {
//    img.filter(DILATE); 
//  }
//  opencv.copy(img);
  
  return opencv.blobs(minBlobSize, maxBlobSize, 20, false);
}

void scaleBlobs() {
  if (blobs != null) {
    for (int i = 0; i < blobs.length; i++) {
      for(int j = 0; j < blobs[i].points.length; j++) {
        blobs[i].points[j].x = scaleRatio * blobs[i].points[j].x;
        blobs[i].points[j].y = scaleRatio * blobs[i].points[j].y;
      }
    }
  }
}

void drawBlobs(Blob[] blobs, PGraphics pg) {
  if (blobs == null) {
    return;
  }
  pg.beginDraw();
  pg.background(0);
  pg.fill(255);
  pg.noStroke();
  pg.smooth();
  for (int i = 0; i < blobs.length; i++) {
    pg.beginShape();
    for (int j = 0; j < blobs[i].points.length; j++) {
      pg.vertex(blobs[i].points[j].x, blobs[i].points[j].y);
    }
    pg.endShape(CLOSE);
  }
  pg.endDraw();
}

void stopBlobDetection() {  
  kinect.quit();
  opencv.stop();
}  

void tiltKinect(int i) {
  kinectAngle = constrain(kinectAngle + i, 0, 30);
  kinect.tilt(kinectAngle);
  roiChanged = true;
}

void updateCropY(int i) {
  cropY = constrain(cropY + i, 0, _KinectHeight - _height);
  roiChanged = true;
}


