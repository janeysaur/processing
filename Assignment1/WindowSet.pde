/*
  Windowset contains all the windows for a building, calculated such that each level has 3 windows 

  Three different modes: 
   -- mode 1: turn on all the windows
   -- mode 2: turn on windows level by level starting from the bottom 
   -- mode 3: turn on windows individually in a 'random' order
*/

class WindowSet {
  ArrayList windows;
  int initialStartTime;
  int waitTime;
  int startTime = 0;
  int mode = 0;
  int currentRow = -1;
  int currentWindow = -1;
  boolean on;
  

  WindowSet(float ox, float oy, float w, float h, int m) {
    float d = w/7;
    windows = new ArrayList();
    // add the windows to the array one level at a time starting from the top left 
    // condition y+2 < oy+h gets rid of any windows that may end up only being 2 pixels high on the bottom of the screen
    for(float y = oy + d; y + 2 < oy + h; y += 3 * d) {
      for (int i = 0; i < 3; i++) {
        float x = ox + (2*i + 1) * d;
        Window win = new Window(x, y, d, 2*d);
        if (m == 1) { // if mode == 1, all the windows will turn on and off together, so we can just turn them all on now and just use the windowSet 'on' flag to control the display
          win.on = true;
        }
        windows.add(win);
      }
    }
    on = false;
    mode = m;
    if (mode == 1) { // duration time ~ 5 seconds
      initialStartTime = 5000;
    } else if (mode == 2) { // duration time ~ 6 seconds
      initialStartTime = 12000;
    } else if (mode == 3) { // duration time ~ 12 seconds
      initialStartTime = 21000;
    }
    waitTime = 30000; 
  }

  void run() {
    update();
    display();
  }

  void update() {
    if (mode == 1 && millis() - startTime > 5000) {
      on = false;
    } 
    if (mode == 2) {
      // turn on level by level 
      if (millis() - startTime > 2000) {
        if (currentRow < 0) {
          // turn all the windows off 
          turnOff();
        } else {
          // turn on windows one level at a time starting from the bottom
          for (int i = currentRow * 3; i < (currentRow + 1) * 3; i++) {
            Window w = (Window) windows.get(i);
            w.on = true;
          }
          startTime = millis();
          currentRow--;
        }
      }
    }
    if (mode == 3) { // turn on individual windows one at a time from the bottom right corner
      if (millis() - startTime > 1000) {
        if (currentWindow < 0) {
          turnOff();
        } else {
          Window w = (Window) windows.get(currentWindow);
          w.on = true;
          startTime = millis();
          currentWindow--;
        }
      }
    }
  }

  void display() {
    for (int i = windows.size() - 1; i >= 0; i--) {
      Window w = (Window) windows.get(i);
      if (w.on) {
        w.display();
      }
    }
  }
  
  void turnOn() {
    // turn on the windowset and initialise any variables required for the mode
    on = true;
    startTime = millis(); 
   if (mode == 2) {
     currentRow = windows.size() / 3 - 1;
   }   
   if (mode == 3) {
     currentWindow = windows.size() - 1;
   }
  }
  
  void turnOff() {
      // turn all the windows off 
    for (int i = windows.size() - 1; i >= 0; i--) {
      Window w = (Window) windows.get(i);
      w.on = false;
    }  
    on = false;
  }
}

