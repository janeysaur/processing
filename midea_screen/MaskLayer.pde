void updateMask() {
  kinectDepthImage.copy(kinect.getDepthImage(), 0, 0, kinectDepthImage.width, kinectDepthImage.height, 0, 0, kinectDepthImage.width, kinectDepthImage.height);
  if (keyPressed && key == ' ') { kinectDepthBackgroundImage.copy(kinect.getDepthImage(), 0, 0, kinectDepthImage.width, kinectDepthImage.height, 0, 0, kinectDepthBackgroundImage.width, kinectDepthBackgroundImage.height); }
  // Remove background from depth image to highlight foreground objects
  removeBackground(kinectDepthImage, kinectDepthBackgroundImage, opencvBlobImage);
  // Detect blobs in the image with the background removed
  blobs = detectBlobs(opencvBlobImage);
  scaleBlobs();

  maskImage.beginDraw();
  maskImage.background(0);
  maskImage.fill(255);
  maskImage.noStroke();
  drawBlobs(blobs, maskImage);
  maskImage.endDraw();
}

void removeBackground(PImage img, PImage bg, PImage diff) {
  diff.copy(img, 0, 0, img.width, img.height, 0, 0, diff.width, diff.height);
  diff.blend(bg, 0, 0, bg.width, bg.height, 0, 0, diff.width, diff.height, DIFFERENCE);
  diff.filter(THRESHOLD, 0.01);
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
  
  return opencv.blobs(img.width*img.height/20, img.width*img.height/2, 10, false);
}

void scaleBlobs() {
  if (blobs != null) {
    for (int i = 0; i < blobs.length; i++) {
      for(int j = 0; j < blobs[i].points.length; j++) {
        blobs[i].points[j].x = 2 * blobs[i].points[j].x;
        blobs[i].points[j].y = 2 * blobs[i].points[j].y;
      }
      blobs[i].centroid.x *= 2;
      blobs[i].centroid.y *= 2;
    }
  }
}

void drawBlobs(Blob[] blobs, PGraphics pg) {
  if (blobs != null) {
    for( int i = 0; i < blobs.length; i++) {
      pg.beginShape();
      for(int j = 0; j < blobs[i].points.length; j++) {
        pg.vertex(blobs[i].points[j].x, blobs[i].points[j].y);
      }
      pg.endShape(CLOSE);
    }
  }
}

void drawBlobsList(ArrayList blobs, PGraphics pg) {
    for( int i = 0; i < blobs.size(); i++) {
      pg.beginShape();
      Blob b = (Blob) blobs.get(i);
      for(int j = 0; j < b.points.length; j++) {
        pg.vertex(b.points[j].x, b.points[j].y);
      }
      pg.endShape(CLOSE);
    }
}



