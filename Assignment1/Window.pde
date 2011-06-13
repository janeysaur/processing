// windows are just yellow rectangles on a building 

class Window {
  float x, y, wHeight, wWidth;
  boolean on;

  Window(float wx, float wy, float wh, float ww) {
    x = wx;
    y = wy; 
    wHeight = wh;
    wWidth = ww;
    on = false;
  }

  void display() {
    noStroke();
    fill(#FFFF00);
    rect(x, y, wHeight, wWidth);
  }
}
