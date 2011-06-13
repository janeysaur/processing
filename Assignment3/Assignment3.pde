/*
  Osc code modified from Rob's OSCribble08 example
 
 Idea: 
 -- Tessalated hexagons 
 -- Slider to change size of hexagons - but this will require a redraw of the entire sketch
   -- decided not to implement this 
   
 -- Game of life type game where clicking on one hexagon affects its neighbours 
   -- simplest example is selecting a hex, toggles it and its neighbours
   -- game is to turn all the hexagons into the same colour.
   -- start state is randomly generated 
   
 -- rather than have a cursor, the 'selected' hexagon lights up to show that it is the active one. 
   -- use HSB brightness to 'highlight' selected hexagon by giving it brightness = 255 and inactive ones a lower brightness
   
 -- 'draw' button has to be pressed to 'toggle' the state of the active hexagon.
 
 -- use faders to control the 2 colours that the hexagons can be
   -- free control can result in colours that are too close to each other 
   -- opted to force the 2 colours to be complementary (across each other in the colour wheel)
   
 -- made a simpler OSC layout called OSCHex 
   -- didn't end up implementing reset button and multi-toggle buttons
   
 */

import oscP5.*;
import netP5.*;
import processing.video.*;

MovieMaker mm;

OscP5 oscP5;
int oscEventTimestamp;
int DIST_THRESHOLD = 100;
int TIME_THRESHOLD = 100;
float touchX, touchY, ptouchX, ptouchY;

float hexSize;
float hueActive, hueInactive;
boolean drawPressed;
NetAddress touchAddress;

ArrayList hexagons;
int currentSize;
int currentHex = -1;
int nCols, nRows;

boolean redrawHexs, toggleCurrentHex, checkHexs;

boolean recordMovie = false;

void setup() {
  size(600, 200);
  smooth();

  if (recordMovie == true) {
    mm = new MovieMaker(this, width, height, "capture.mov", 30, MovieMaker.H263, MovieMaker.HIGH);
  }
  setupOSC();

  hexagons = new ArrayList();
  int s = int(hexSize);
  setupHexagons(s);
  redrawHexs = false;
  toggleCurrentHex = false;
  checkHexs = false;
}

void draw() {
  if (checkHexs == true) {
    checkHexagons(new PVector(touchX, touchY));
    checkHexs = false;
  }  
  if (toggleCurrentHex == true) {
    toggleCurrentHexagon();
    toggleCurrentHex = false;
  }
  if (redrawHexs == true) {
    redrawHexagons(); 
    redrawHexs = false;
  } 
  if (recordMovie == true) {
    if (millis() > 60000) {
      mm.finish();    
      println("finished recording");
    } else {
      mm.addFrame();
    }
  }
    
}

void printlog(String msg) {
  println(millis() + ": " + msg);
}

void stop() {
  if (recordMovie == true) {
    mm.finish();    
  }
  super.stop();
}
