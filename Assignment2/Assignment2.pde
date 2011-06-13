/*
  Using face detection, the colored balls are directed away from the faces in the captured image
  
  Originally I was inspired by the OpenCV Bubbles tutorial posted at http://andybest.net/2009/02/processing-opencv-tutorial-2-bubbles/
but I wanted to make a version where instead of popping the bubbles, the bubbles could either be attracted to or repelled by movement
e.g.. there would be a constant shower of bubbles like a curtain and movement could part the curtain of bubbles I decided to replace
the Bubble image with the Ball class from the CircleCollision processing example and try to appropriate some of the collision
detection code. A new ball would be added on each draw(), like in the Bubbles example, but I used the boundary collision in the
CircleCollision example so that once they appeared on the screen, they would stay and bounce around. This meant that I had to add an
upper bound on the number of balls otherwise the screen would fill up too much and obscure the interaction. I wasn't sure how to use
the object collision in the CircleCollision example. I thought about using the Blob detection in the OpenCV example, but it didn't
really work because rather than e.g. my head being a blob, my head was 4 different blobs, as was my back wall, and the back of my
chair. And playing around with the thresholds didn't seem to help. So I gave up on that and decided to just use motion detection via
frame differencing. But motion detection itself doesn't give me blobs, so there weren't any discrete objects that i could try and do
collision detection with. So I opted for making the balls stop if there was any movement in their space (for each ball, i went through
all the pixels in the movementImage and checked if the brightness > 127 i.e. if there was any movement, and if there was then i didn't
update its postion before rendering). i.e. if i moved my hand around, the balls that were on top of that movement stopped. That worked
but it was a bit boring, so i added some 'jiggle' to the otherwise stationary balls. So, it was kind of like, if you moved then the
balls would be 'interested' by the movement, otherwise they went about their business bouncing around the screen. I still wanted the
balls to be 'attracted' to something though, instead of just stopping (as though stunned) so I started playing around with Face
Detection instead. This actually worked a lot better than the blob detection because, frame to frame, the faces are a more permanent
participant in the interaction. As in, they stick around long enough for you to actually see something happening on the screen. So
then, using the faces, I added some stuff so that the balls within the bounding box of the face would be attracted toward the center
of the face. This was cool, because you could move around the screen and 'catch' all the balls because they tended to try and stay
with the face. And when you covered your face, the balls would be free to move again, resulting in an explosion of balls. For a little
while, my boyfriend and I played with this trying to 'catch' balls with our faces. I even thought about adding scores above each face.
But, once you start 'catching' too many of the balls, the screen becomes a bit boring so I thought I would try reversing the maths so
that the balls moved away / were repelled by faces detected instead. I liked this effect more than the 'attraction' effect because
multiple 'faces' could participate in affecting the directions of the balls. Finally, I added a 'showCamImage' flag which could be
toggled with a keyPress so that I could show what the animation looked like with and without the camera image. Having the camera image
hidden makes the movement of the balls a bit more obvious, as you can see them being repelled from the centre of a black "hole", and
then when you show the camera image, it become obvious what the interaction is and that the balls are moving away from faces. I have
to admit though, it feels strange to be 'pushing balls aside with my face' and i would have preferred to get something working with
e.g. blobs (?) so that you could push balls aside with your hand. It will be interesting to see how this would work in a bigger
setting. Like with people standing in the courtyard, moving around to have a look at the video and then noticing the balls moving away
from areas on the screen.
*/


import processing.video.*;
import hypermedia.video.*;
import java.awt.*;

OpenCV opencv;
PImage cropVideo, scaleVideo;
int cropY;
ArrayList balls;
boolean showCamImage = false;

//MovieMaker mm;

void setup() {
  size(600, 200);
  
//  mm = new MovieMaker(this, width, height, "assignment2.mov", 30, MovieMaker.H263, MovieMaker.HIGH);
  opencv = new OpenCV( this);
  opencv.capture(640, 480);
  opencv.cascade( OpenCV.CASCADE_FRONTALFACE_ALT );  // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"

  // cropVideo is the same width as input but aspect ratio of display window
  cropVideo = createImage(640, 640/3, ARGB);
  // scaleVideo is the same size as display window (optional but potentially useful)
  scaleVideo = createImage(600, 200, ARGB);
  // cropY is the vertical offset to grab the centre of the input image
  cropY = (opencv.height - cropVideo.height)/2;

  balls = new ArrayList();
  int r = 10; // initalise all the balls here, so that the animation starts off with all the balls on the display
  while(balls.size() < 300) {    
    balls.add(new Ball(random (0, width - r), random(0, height - r), r, new PVector(random(-5,5), random(-5,5))));
  }
}


void draw() {

  noStroke();
  fill(0);
  rect(0, 0, width, height);

  opencv.read();
  opencv.flip(OpenCV.FLIP_HORIZONTAL);  
  // Crop the centre section of the input video
  cropVideo.copy(opencv.image(), 0, cropY, opencv.width, cropVideo.height, 0, 0, cropVideo.width, cropVideo.height);
  // Rescale the cropped video to the size of the screen
  scaleVideo.copy(cropVideo, 0, 0, cropVideo.width, cropVideo.height, 0, 0, scaleVideo.width, scaleVideo.height);
  // Display the scaled image
  if (showCamImage) {
    image(scaleVideo, 0, 0);
  }
  
  // set the region of interest so that openCV is not doing unnecessary face detection on areas of the captured image that 
  // ultimately will not be rendered to the display
  opencv.ROI(0, cropY, opencv.width, cropVideo.height);    

  // proceed detection
  Rectangle[] faces = opencv.detect( 1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40 );
//
//  for (int i = 0; i < faces.length; i++) {
//    Rectangle f = faces[i];
//    noFill();
//    stroke(255, 0, 0);
//    rect(f.x, f.y, f.width, f.height);
//  }

  // go through the arrayList of balls, update their position and render them to the display
  for (int i = 0; i < balls.size(); i++) {    
    Ball b = (Ball) balls.get(i);
    // for each ball, go through the array of faces that have been detected 
    for(int j = 0; j < faces.length; j++) {
      Rectangle f = faces[j];   
      // if the ball's center is within the bounding box of the detected face
      // repel it from the center of the face by adding a unit vector with the direction pointing from center of the face to center of the ball
      if (b.x > f.x && b.x < f.x + f.width &&
        b.y > f.y && b.y < f.y + f.height) {
        PVector centreFace = new PVector(f.x + f.width/2, f.y + f.height/2);
        PVector centreBall = new PVector(b.x, b.y);        
        float d = PVector.dist(centreFace, centreBall);
        if (d > 1) {        
          centreBall.sub(centreFace); // get a vector that is pointing away from the centre of the face towards the ball
          centreBall.normalize(); 
          b.vel.add(centreBall); // this modifies the direction that the ball is currently travelling in to start it moving away from the middle of the face
        }
      }
    }    
    b.run();
  }
//  mm.addFrame();
//  if (millis() > 60000) {
//    mm.finish();
//    println("finished recording");
//  }
}

void stop() {
  opencv.stop();
  super.stop();
}

class Ball {
  float x, y, r, m;
  PVector vel, acc;
  int ballHue;

  Ball(float x, float y, float r, PVector v) {
    this.x = x;
    this.y = y;
    this.r = r; // radius
    m = r*.1; // magnitude
    vel = v;
    ballHue = int(map(x*y, 0, width*height, 0, 255));
  }

  void update() {
    // reduces the speed of the ball by 1% on each update while keeping it above a minimum velocity
    // otherwise the ball will keep moving faster and faster each time it is affected ("repelled") by a face in the draw() function.
    if (vel.mag() > 2) { 
      vel.mult(0.99);
    }
    x += vel.x;    
    y += vel.y;
  }

  void display() {
    noStroke();
    colorMode(HSB);
    fill(color(ballHue, 255, 255));
    ellipse(x, y, r*2, r*2);
    colorMode(RGB);
  }

  void run() {
    update();
    checkBoundaryCollision();
    display();
  }

  // not used anymore
  boolean dead() {
    return (x < 0 || x > width || y < 0 || y > height);
  }

  // add checks so that balls that hit the edges of the display will bounce back off the edges
  void checkBoundaryCollision() {
    if (x > width - r) {
      x = width - r;
      vel.x *= -1;
    } 
    else if (x < r) {
      x = r;
      vel.x *= -1;
    } 
    else if (y > height - r) {
      y = height - r;
      vel.y *= -1;
    } 
    else if (y < r) {
      y = r;
      vel.y *= -1;
    }
  }
}


void keyPressed() {
  showCamImage = !showCamImage; // toggles the flag for showing/hiding the camera image
}

