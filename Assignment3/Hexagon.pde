/*
  Modified from Grant Muller's 'Drawing a hexagon in Processing/Java'
 http://grantmuller.com/drawing-a-hexagon-in-processing-java/
 */

class Hexagon {

  protected PApplet parent;
  protected PGraphics buffer;
  protected float a;
  protected float b;
  protected float c;
  private int startX;
  private int startY;
  public int col;
  public int row;
  boolean highlight;
  boolean selected;
  public int index;


  public Hexagon(Object p, int newStartX, int newStartY, int sideLength, int row, int col, int index) {
    if (p instanceof PGraphics)
      buffer = (PGraphics) p;

    if (p instanceof PApplet)
      parent = (PApplet) p;

    setStartX(newStartX);
    setStartY(newStartY);
    c = sideLength;
    a = c/2;    
    b = parent.sin(parent.radians(60))*c;
    this.col = col;
    this.row = row;
    this.index = index;
    highlight = false;
    selected = (int(random(1, 99)) % 2) == 0;
  }

  public void toggleSelect() {
    selected = !selected;
    drawTranslatedHex();
  }

  public void drawTranslatedHex() {
    int bright = highlight == true ? 255 : 180; // play with these values so that there is enough 'contrast'
    float hexHue = selected == true ? hueActive : hueInactive;
    colorMode(HSB);
    fill(color(hexHue, 255, bright));

    noStroke();
//    println("drawing hex (" + row + ", " + col + ")" );
    parent.pushMatrix();
    parent.translate(startX, startY);
    //draw hex shape
    drawHex();
    parent.popMatrix();
  }

  public void drawHex() {
    //draw hex shape
    parent.beginShape();
    parent.vertex(0,b);
    parent.vertex(a,0);
    parent.vertex(a+c,0);
    parent.vertex(2*c,b);
    parent.vertex(a+c,2*b);
    parent.vertex(a+c,2*b);  
    parent.vertex(a,2*b);
    parent.vertex(0,b);
    parent.endShape();
  }

  public void setStartX(int startX) {
    this.startX = startX;
  }

  public int getStartX() {
    return startX;
  }

  public void setStartY(int startY) {
    this.startY = startY;
  }

  public int getStartY() {
    return startY;
  }

  public boolean contains(PVector p) {
    // translate the point so that it is relative to the points 
    // of the untranslated hexagon 
//    printlog("original p = (" + p.x + ", " + p.y + ")");

    p.x -= startX;
    p.y -= startY;

//    printlog("translated p = (" + p.x + ", " + p.y + ")");

    // split hexagon into 5 sections 
    /* 
       ________
      /|      |\
     /_|      |_\
     \ |      | /
      \|______|/    
     */


//    printlog("a = " + a);
//    printlog("b = " + b);
//    printlog("c = " + c);
    // if the point is inside the rectangular body of the hexagon
    if (a <= p.x && p.x <= a + c && 0 <= p.y && p.y <= 2*b) { 
      return true;
    }

    // if point is in top left triangle or bottom left triangle
    // bounded between hypotenuse of top left: y = -b/a * x + b
    // and bottom right: y = b/a * x + b
    if (p.x >= 0 && p.x <= a && 
      p.y >= 0 && p.y <= 2*b &&
      p.y >= (-b/a * p.x + b) &&
      p.y <= (b/a * p.x + b)) {
      return true;
    }

    // if point is in top right triangle or bottom right triangle
    // bounded by hypotenuse of top right: y = 2b/c * x - 3b
    // and bottom right: y = -2b/c * x + 5b
    if (p.x >= (a + c) && p.x <= 2*c && 
      p.y >= 0 && p.y <= 2*b &&
      p.y >= (2*b/c * p.x - 3*b) &&
      p.y <= (-2*b/c * p.x + 5*b)) {
        return true;
    }
    return false;
  }
}


void setupHexagons(int sideLength) {
  // width across of a hexagon = 2 * sideLength
  int widthOffset = int(3 * sideLength);
  int heightOffset = int(sin(radians(60))*sideLength);
  nRows = int(ceil(height/heightOffset)) + 2;
  nCols = int(ceil(width/widthOffset)) + 2;

  boolean offset = false;
  for (int y = -heightOffset, i = 0; i < nRows; i++) {
    int x = offset ? 0 : int( -widthOffset / 2);
    for (int j = 0; j < nCols; j++) {
      Hexagon h = new Hexagon(this, x, y, sideLength, i, j, i * nCols + j);
      h.drawTranslatedHex();
      hexagons.add(h);
      x += widthOffset;
    }
    offset = !offset;
    y += heightOffset;
  }
  currentSize = sideLength;
}

void redrawHexagons() {
  for(int i = 0; i < hexagons.size(); i++) {
    Hexagon h = (Hexagon) hexagons.get(i);
    h.drawTranslatedHex();
  }
}

void checkHexagons(PVector p) {
  //  printlog("checking hexagons");
  int minCol = int(max(0, (p.x - 2 * currentSize) / (3 * currentSize) ));
  int heightOffset = int(sin(radians(60))*currentSize);
  int minRow = int(max(0, p.y / heightOffset));
  for (int r = minRow; r < minRow + 2; r++) {
    for (int c = minCol; c < minCol + 3; c++) {
      int i = r * nCols + c;
      Hexagon h = (Hexagon) hexagons.get(i);
      //      printlog("checking (" + h.row + ", " + h.col + ")");
      if (h.contains(p.get()) == true) {
        println("i am inside (" + h.row +  ", " + h.col + ")");
        if (h.index != currentHex) {
          if (currentHex > -1) {
            Hexagon previousHex = (Hexagon) hexagons.get(currentHex);
            previousHex.highlight = false;
            previousHex.drawTranslatedHex();
          }
          h.highlight = true;
          currentHex = h.index;
          h.drawTranslatedHex();
        } 
        else {
          printlog("already highlighted");
        }
        return;
      }
    }
  }
  printlog("dead end for point(" + p.x + ", " + p.y + ")");
}

int getIndex(int row, int col) {
  return row * nCols + col;
}

void toggleCurrentHexagon() {
  if (currentHex > -1) {
    Hexagon h = (Hexagon) hexagons.get(currentHex);
    h.toggleSelect();
    // toggle neighbours
    // 6 possible neighbours 
    Hexagon neighbour;
    if (h.row - 2 >= 0) {     // directly above 
      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 2, h.col));
      neighbour.toggleSelect();
    }
    if (h.row + 2 < nRows) { // directly below
      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 2, h.col));
      neighbour.toggleSelect();
    }
    // top left
    if (h.row % 2 == 1 && h.row - 1 >= 0) { 
      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 1, h.col));
      neighbour.toggleSelect();
    } 
    else if (h.row % 2 == 0 && h.row - 1 >= 0 && h.col - 1 >= 0) {
      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 1, h.col - 1));
      neighbour.toggleSelect();
    }
    // top right 
    if (h.row % 2 == 1 && h.row - 1 >= 0 && h.col + 1 < nCols) { 
      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 1, h.col + 1));
      neighbour.toggleSelect();
    } 
    else if (h.row % 2 == 0 && h.row - 1 >= 0) {
      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 1, h.col));
      neighbour.toggleSelect();
    }
    // bottom left 
    if (h.row % 2 == 1 && h.row + 1 < nRows) { 
      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 1, h.col));
      neighbour.toggleSelect();
    } 
    else if (h.row % 2 == 0 && h.row + 1 < nRows && h.col - 1 >= 0) {
      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 1, h.col - 1));
      neighbour.toggleSelect();
    }
    // bottom right 
    if (h.row % 2 == 1 && h.row + 1 < nRows && h.col + 1 < nCols) { 
      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 1, h.col + 1));
      neighbour.toggleSelect();
    } 
    else if (h.row % 2 == 0 && h.row + 1 < nRows) {
      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 1, h.col));
      neighbour.toggleSelect();
    }
  }
}


