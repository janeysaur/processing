// randomly fill the bottom half of the screen with rectangles to create a skyline
void generateSkyline() {
  int maxHeight = height/2;
  float x, y, rWidth, rHeight;
  randomSeed(0);  
  stroke(50); 
  strokeWeight(5); // each hexal ~= 5px
  fill(0);
  x = 0;
  y = height - maxHeight;
  rWidth = 0;
  for (int i = 0; i < width/10; i++) {
    // generate a random rectangle to fill skyline    
    x = random(x - 10, x + rWidth);
    y = random(height - maxHeight, height - 20);
    rWidth = random(15, 40)*2;
    rHeight = height - y;
    rect(x, y, rWidth, rHeight);    
    println("rect(" + x + ", " + y + ", " + rWidth + ", " + rHeight + ");");
  }
}

// picked some of the randomly generated buildings from the above method for the skyline
void setupSkyline() { 
  stroke(50);
  strokeWeight(5);
  fill(0);
  rect(18.855886, 150.9934, 45.45253, 49.006607);
  rect(-2.6903224, 166.51529, 42.026817, 33.48471);
  rect(39.37901, 109.36053, 59.877266, 90.63947);
  rect(83.99051, 126.65747, 42.63881, 73.34253);
  rect(94.26641, 149.04286, 79.24208, 50.957138);
  rect(171.97525, 170.3346, 31.154093, 29.665405);
  rect(200.71152, 114.07814, 43.747696, 85.92186);
  rect(207.5311, 110.31177, 48.398785, 89.68823);
  rect(206.09245, 156.41397, 31.161905, 43.58603);
  rect(196.14954, 143.73918, 30.46124, 56.26082);
  rect(225.17387, 145.03598, 35.224533, 54.96402);
  rect(238.91467, 101.19416, 68.81561, 98.80584);
  rect(305.8937, 179.25781, 64.41173, 20.742188);
  rect(332.14954, 169.41429, 67.31207, 30.585709);
  rect(397.98843, 158.65216, 58.501713, 41.34784);
  rect(467.75366, 142.13596, 66.28874, 57.864044);
  rect(443.97467, 101.02453, 71.94452, 98.97547);
  rect(526.3628, 178.77393, 36.69699, 21.226074);
  rect(541.8653, 106.64499, 39.29948, 93.35501);
  rect(580.1085, 124.54969, 66.11786, 75.45031);
}

