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
  color RED = color(255, 0, 0);
  color BLUE = color(0, 0, 255);
  color fill;
  
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

  int getNumNeighbors() {
    int num = 0;
    if (this.col - 1 > 0)
      num++;
    
    if (this.col + 1 < 15)
      num++;
    
    if (this.row - 1 > 0)
      num++;

    if (this.row + 1 < 15)
      num++;

    return num;
  }

  List<Action> getActions() {
    List<Action> actions = new ArrayList<Action>();
    if (this.col - 1 > 0)
      actions.add(Action.LEFT);
    if (this.col + 1 < 15)
      actions.add(Action.RIGHT);
    if (this.row - 1 > 0)
      actions.add(Action.UP);
    if (this.row + 1 < 15)
      actions.add(Action.DOWN);
    return actions;
  }
  
}

enum Action {
  UP, LEFT, RIGHT, DOWN;
}