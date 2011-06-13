
void setupOSC() {
  oscP5 = new OscP5(this, 8000);

  hueActive = 60;
  hueInactive = (60 + 255/2) % 255;
  
  oscEventTimestamp = 0;
  hexSize = 30;

  touchX = width/2;
  touchY = height/2;
  ptouchX = touchX;
  ptouchY = touchY;
  
  drawPressed = false;

  touchAddress = new NetAddress("192.168.0.198", 9000);
  touchSend("/1/hueActiveFader", hueActive);
  touchSend("/1/hueActiveValueLabel", int(hueActive));
  touchSend("/1/hueInactiveFader", hueInactive);
  touchSend("/1/hueInactiveValueLabel", int(hueInactive));

  // Send initial values to the xy pad to reset to the centre
  touchSend("/1/scribblePad", touchX/width, touchY/height);
}

// Send a single float value to the TouchOSC device using the given pattern to identify the receiving component
void touchSend(String addr, float value) {
  OscMessage msg = new OscMessage(addr);
  msg.add(value);
  oscP5.send(msg, touchAddress);
}

// Send a single int value to the TouchOSC device using the given pattern to identify the receiving component
void touchSend(String addr, int value) {
  OscMessage msg = new OscMessage(addr);
  msg.add(value);
  oscP5.send(msg, touchAddress);
}

// Send two float values to the TouchOSC device using the given pattern to identify the receiving component
void touchSend(String addr, float value1, float value2) {
  OscMessage msg = new OscMessage(addr);
  msg.add(value1);
  msg.add(value2);
  oscP5.send(msg, touchAddress);
}

void oscEvent(OscMessage msg) {
  // Retrieve the pattern that identifies the sender of the message
  String addr = msg.addrPattern();
  if (addr.indexOf("scribblePad") != -1) {
    touchX = msg.get(1).floatValue() * width;
    touchY = msg.get(0).floatValue() * height;
//    if ((dist(ptouchX, ptouchY, touchX, touchY) > DIST_THRESHOLD) ||
//      (millis() - oscEventTimestamp > TIME_THRESHOLD)) {
//      ptouchX = touchX;
//      ptouchY = touchY;
//    }
    //    println(touchX + ", " + touchY);    
    checkHexs = true;
  } else if (addr.indexOf("hueActiveFader") != -1) {
//    if (millis() - oscEventTimestamp > TIME_THRESHOLD) {
      float newHue = msg.get(0).floatValue();
      if (newHue != hueActive) {      
        hueActive = newHue;
        touchSend("/1/hueActiveValueLabel", int(hueActive));
        hueInactive = (hueActive + 255/2) % 255; // get the complementary color
        touchSend("/1/hueInactiveFader", hueInactive);
        touchSend("/1/hueInactiveValueLabel", int(hueInactive));
        redrawHexs = true;
//      }
    }
  } else if (addr.indexOf("hueInactiveFader") != -1) {
//    if (millis() - oscEventTimestamp > TIME_THRESHOLD) {
      float newHue = msg.get(0).floatValue();
      if (newHue != hueInactive) {      
        hueInactive = newHue;
        touchSend("/1/hueInactiveValueLabel", int(hueInactive));
        hueActive = (hueInactive + 255/2) % 255; // get the complementary color
        touchSend("/1/hueActiveFader", hueActive);
        touchSend("/1/hueActiveValueLabel", int(hueActive));        
        redrawHexs = true;
//      }
    }
  } else if (addr.indexOf("drawButton") != -1) {
    drawPressed = (msg.get(0).floatValue() > 0);
//    if (millis() - oscEventTimestamp > TIME_THRESHOLD) {
      if (drawPressed == true && currentHex > -1) {
        toggleCurrentHex = true;
      }      
//    }    
  }
  oscEventTimestamp = millis();
}

