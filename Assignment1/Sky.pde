// Didn't end up using this 
// The fireworks looked better with onion skinning on a black background.
void setupNightSky() {
  colorMode(HSB);
  for (int y = 0; y < height; y++) {
    // we want to go from black to gray
    // but on more of a logarithmic scale?
    stroke (132, 108, y*(height - y)/height);
    line(0, y, width, y);
  }
}
