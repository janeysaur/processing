OpenCV opencv;
Kinect kinect;
PImage bgImg; // kinect depth background image cropped
PImage depthImg; // kinect depth image cropped
PImage diffImg; // kinect difference frame cropped
PImage opencvBlobImage; // opencv blob image scaled
Blob[] blobs;

int _KinectWidth = 640;
int _KinectHeight = 480;
float kinectAngle = 0;
int scaleRatio = 2;
boolean roiChanged = false;
boolean showBlobs = true;
float threshold = 0.01;

void setupBlobDetection() {
  _KinectWidth = width;
  _KinectHeight = height;
  
  // Allocate some memories for working with the Kinect
  bgImg = createImage(_KinectWidth, _KinectHeight, RGB);
  depthImg = createImage(_KinectWidth, _KinectHeight, RGB);
  diffImg = createImage(_KinectWidth, _KinectHeight, RGB);
  
  opencvBlobImage = createImage(width/scaleRatio, height/scaleRatio, RGB);
  setupOpenCV(width/scaleRatio, height/scaleRatio);
  setupKinect();

}

void updateMask() {
  depthImg.copy(kinect.getDepthImage(), 0, 0, _KinectWidth, depthImg.height, 0, 0, depthImg.width, depthImg.height);
  if (roiChanged) {
    bgImg.copy(kinect.getDepthImage(), 0, 0, _KinectWidth, bgImg.height, 0, 0, bgImg.width, bgImg.height);
    println("Background image taken");
    roiChanged = false;
  }
  // Remove background from depth image to highlight foreground objects
  removeBackground(depthImg, bgImg, opencvBlobImage);
  // scale kinect image for opencv
  blobs = detectBlobs(opencvBlobImage);
  scaleBlobs();  
}

void removeBackground(PImage img, PImage bg, PImage diff) {
  diff.copy(img, 0, 0, img.width, img.height, 0, 0, diff.width, diff.height);
  diff.blend(bg, 0, 0, bg.width, bg.height, 0, 0, diff.width, diff.height, DIFFERENCE);
  diff.filter(THRESHOLD, threshold);
  diff.filter(ERODE);
  diff.filter(ERODE);
  diff.filter(ERODE);
  diff.filter(DILATE);
  diff.filter(DILATE);
  diff.filter(DILATE);
}

Blob[] detectBlobs(PImage img) {
  // Detect foreground objects as blobs
  opencv.copy(img);
  opencv.flip(OpenCV.FLIP_HORIZONTAL);  
//  opencv.flip(OpenCV.FLIP_VERTICAL);
  
  return opencv.blobs(img.width*img.height/20, img.width*img.height/2, 10, false);
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

void scaleBlobs() {
  if (blobs != null) {
    for (int i = 0; i < blobs.length; i++) {
      Blob b = blobs[i];
      for(int j = 0; j < blobs[i].points.length; j++) {
        b.points[j].x = scaleRatio * b.points[j].x;
        b.points[j].y = scaleRatio * b.points[j].y;
      }
      Rectangle r = b.rectangle;
      b.rectangle = new Rectangle(scaleRatio * r.x, scaleRatio * r.y, scaleRatio * r.width, scaleRatio * r.height);
    }
  }
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

PVector blobCenter (Blob b) {
  return new PVector(b.rectangle.x + b.rectangle.width/2, b.rectangle.y + b.rectangle.height/2);  
}


void keyPressed() {
  if (key == '+') {
    tiltKinect(1);
  } 
  else if (key == '-') {
    tiltKinect(-1);
  } 
  else if (key == ' ') {
    roiChanged = true;
  } 
  else if (key == 'b') {
    showBlobs = !showBlobs;
  }
  else if (key == CODED && keyCode == UP) {
    threshold++;
  } 
  else if (key == CODED && keyCode == DOWN) {
    threshold--;
  }
}

