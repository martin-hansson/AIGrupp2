//Grupp 02:
// Alexandra Jansson, alja5888
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

class Team {

  Tank[] tanks = new Tank[3];
  int id; // team red 0, team blue 1.
  int tank_size;
  PVector tank0_startpos = new PVector();
  PVector tank1_startpos = new PVector();
  PVector tank2_startpos = new PVector();

  GridGraph graph = new GridGraph();

  float homebase_x;
  float homebase_y;
  float homebase_width = 150;
  float homebase_height = 350;

  color team_color;

  int numberOfHits; // sammalagda antalet bekräftade träffar på andra lagets tanks. 


  Team (int team_id, int tank_size, color c, 
    PVector tank0_startpos, int tank0_id, /*CannonBall ball0,*/ 
    PVector tank1_startpos, int tank1_id, /*CannonBall ball1, */
    PVector tank2_startpos, int tank2_id/*, CannonBall ball2*/) 
  {
    this.id = team_id;
    this.tank_size = tank_size;
    this.team_color = c;
    this.tank0_startpos.set(tank0_startpos);
    this.tank1_startpos.set(tank1_startpos);
    this.tank2_startpos.set(tank2_startpos);

    this.numberOfHits = 0; 

    tanks[0] = new Tank(tank0_id, this, this.tank0_startpos, this.tank_size/*, ball0*/);
    tanks[1] = new Tank(tank1_id, this, this.tank1_startpos, this.tank_size/* , ball1 */);
    tanks[2] = new Tank(tank2_id, this, this.tank2_startpos, this.tank_size/* , ball2 */);
    
    
    if (this.id==0) {this.homebase_x = 0; this.homebase_y = 0;}
    else if (this.id==1) {this.homebase_x = width - 151; this.homebase_y = height - 351;}
    
  }

  int getId() {
    return this.id;
  }

  color getColor() {
    return this.team_color;
  }

  void messageSuccessfulHit() {
    this.numberOfHits += 1;
  }

  void updateLogic() {
    
  }

  void checkVisited(GridNode current){
      if (current != null) {
        if (!current.isVisited) {
          current.isVisited = true;
          addNode(current);
          
        }
      }
    }
    
    void addNode(GridNode current){
      if (current != null) {
        graph.add(current);
      }
    }


  // Används inte.
  // Hemma i homebase
  boolean isInHomebase(PVector pos) {
    return pos.x > this.homebase_x && 
      pos.x < this.homebase_x + this.homebase_width &&
      pos.y > this.homebase_y &&
      pos.y < this.homebase_y + this.homebase_height;
  }
  
  void displayHomeBaseTeam() {
    strokeWeight(1);
    //fill(204, 50, 50, 15);
    fill(this.team_color, 15);
    //rect(0, 0, 150, 350);
    rect(this.homebase_x, this.homebase_y, this.homebase_width, this.homebase_height);
  }
  

  void displayHomeBase(){
    displayHomeBaseTeam();
  }
  
}
