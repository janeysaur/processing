
void setupIntro() {
  intro = new IntroText();
}

class IntroText {
  String words = "Presenting...                               A Flâneur's Trace   ";
  PFont font;
  int x, y;
  float wordsWidth;
  int fontsize = 80;
  int speed = 4;
  int waitTime = 60 * 3; // wait 3 seconds before fading
  int fadeAmount = 4;
  int fadeCount = 0;
  boolean done = false;

  IntroText() {
    wordsWidth = textWidth(words);
    println(wordsWidth);
    font = loadFont("BrushScriptMT-120.vlw");
    textFont(font, fontsize);
    textAlign(LEFT);
    x = width;
    y = height/2 + 10;
  }

  void draw() {
    // if we're scrolling the text
    if (x + textWidth(words) > width) {
      background(0);
      fill(255);
      text(words, x, y);
      x -= speed;
    } 
    else {    
      if (waitTime > 0) {
        waitTime--;
      } 
      else {
        // start fading
        fill(0, fadeAmount);
        rect(0, 0, width, height);
        fadeCount++;
        if (fadeCount > 3 * 60) { // we've been fading for 3 seconds
          done = true;
        }
      }
    }
  }
}

