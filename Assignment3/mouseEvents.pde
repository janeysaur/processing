
void mouseMoved() {
  touchX = mouseX;
  touchY = mouseY;
  checkHexs = true;
//  checkHexagons(new PVector(mouseX, mouseY));
}

void mouseClicked() {
  touchX = mouseX;
  touchY = mouseY;
  checkHexs = true;
  toggleCurrentHex = true;
//  
//  checkHexagons(new PVector(mouseX, mouseY));
//  if (currentHex > -1) {
//    Hexagon h = (Hexagon) hexagons.get(currentHex);
//    h.toggleSelect();
//    // toggle neighbours
//    // 6 possible neighbours 
//    Hexagon neighbour;
//    if (h.row - 2 >= 0) {     // directly above 
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 2, h.col));
//      neighbour.toggleSelect();
//    }
//    if (h.row + 2 < nRows) { // directly below
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 2, h.col));
//      neighbour.toggleSelect();
//    }
//    // top left
//    if (h.row % 2 == 1 && h.row - 1 >= 0) { 
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 1, h.col));
//      neighbour.toggleSelect();
//    } 
//    else if (h.row % 2 == 0 && h.row - 1 >= 0 && h.col - 1 >= 0) {
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 1, h.col - 1));
//      neighbour.toggleSelect();
//    }
//    // top right 
//    if (h.row % 2 == 1 && h.row - 1 >= 0 && h.col + 1 < nCols) { 
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 1, h.col + 1));
//      neighbour.toggleSelect();
//    } 
//    else if (h.row % 2 == 0 && h.row - 1 >= 0) {
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row - 1, h.col));
//      neighbour.toggleSelect();
//    }
//    // bottom left 
//    if (h.row % 2 == 1 && h.row + 1 < nRows) { 
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 1, h.col));
//      neighbour.toggleSelect();
//    } 
//    else if (h.row % 2 == 0 && h.row + 1 < nRows && h.col - 1 >= 0) {
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 1, h.col - 1));
//      neighbour.toggleSelect();
//    }
//    // bottom right 
//    if (h.row % 2 == 1 && h.row + 1 < nRows && h.col + 1 < nCols) { 
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 1, h.col + 1));
//      neighbour.toggleSelect();
//    } 
//    else if (h.row % 2 == 0 && h.row + 1 < nRows) {
//      neighbour = (Hexagon) hexagons.get(getIndex(h.row + 1, h.col));
//      neighbour.toggleSelect();
//    }
//    
    
//  }
}

