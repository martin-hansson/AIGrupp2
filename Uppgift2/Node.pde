// Grupp 02:
// Alexandra Jansson alja5888,
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

import java.util.ArrayList;
import java.util.List;

class Node {
  // A node object knows about its location in the grid 
  // as well as its size with the variables x,y,w,h
  float x,y;   // x,y location
  float w,h;   // width and height
  float angle; // angle for oscillating brightness
  
  PVector position;
  int col, row;
  
  Sprite content;
  boolean isEmpty;
  // Tentativ fyllning
  Team fill;
  // Team som har "fångat" noden
  Team claimed;
  
  //***************************************************
  // Node Constructor 
  // Denna används för temporära jämförelser mellan Node objekt.
  Node(float _posx, float _posy) {
    this.position = new PVector(_posx, _posy);
  }

  //***************************************************  
  // Används vid skapande av grid
  Node(int _id_col, int _id_row, float _posx, float _posy) {
    this.position = new PVector(_posx, _posy);
    this.col = _id_col;
    this.row = _id_row;
    
    this.content = null;
    this.isEmpty = true;
  } 

  //***************************************************  
  Node(float tempX, float tempY, float tempW, float tempH, float tempAngle) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    angle = tempAngle;
  } 

  Node copy() {
    Node copy = new Node(this.col, this.row, this.position.x, this.position.y);
    copy.fill = this.fill;
    copy.claimed = this.claimed;
    copy.content = this.content;
    copy.isEmpty = this.isEmpty;
    return copy;
  }

  //***************************************************  
  void addContent(Sprite s) {
    if (this.isEmpty) {
      this.content = s;  
    }
  }

  //***************************************************
  boolean empty() {
    return this.isEmpty;
  }
  
  //***************************************************
  Sprite content() {
    return this.content;
  }
  
}