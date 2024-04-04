class Team1 extends Team {

  Team1(int team_id, int tank_size, color c, 
    PVector tank0_startpos, int tank0_id, /* CannonBall ball0,*/ 
    PVector tank1_startpos, int tank1_id, /* CannonBall ball1, */ 
    PVector tank2_startpos, int tank2_id/*, CannonBall ball2 */) {
    super(team_id, tank_size, c, tank0_startpos, tank0_id, /* ball0, */ tank1_startpos, tank1_id, /* ball1, */ tank2_startpos, tank2_id/*, ball2 */);  

    tanks[0] = new TankAgent(tank0_id, this, this.tank0_startpos, this.tank_size/*, ball0*/);
    tanks[1] = new Tank(tank1_id, this, this.tank1_startpos, this.tank_size/*, ball1*/);
    tanks[2] = new Tank(tank2_id, this, this.tank2_startpos, this.tank_size/* , ball2 */);

    //this.homebase_x = 0;
    //this.homebase_y = 0;
  }

  //==================================================
  public class TankAgent extends Tank {

    boolean started;

    //*******************************************************
    TankAgent(int id, Team team, PVector startpos, float diameter/* , CannonBall ball */) {
      super(id, team, startpos, diameter/* , ball */);

      this.started = false; 

      //this.isMoving = true;
      //moveTo(grid.getRandomNodePosition());
    }
    
    //*******************************************************
    // Reterera, fly!
    public void retreat() {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].retreat()");
      moveTo(grid.getRandomNodePosition()); // Slumpmässigt mål.
    }

    //*******************************************************
    // Reterera i motsatt riktning (ej implementerad!)
    public void retreat(Tank other) {
      //println("*** Team"+this.team_id+".Tank["+ this.getId() + "].retreat()");
      //moveTo(grid.getRandomNodePosition());
      retreat();
    }

    //*******************************************************
    // Fortsätt att vandra runt.
    public void wander() {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].wander()");
      //rotateTo(grid.getRandomNodePosition());  // Rotera mot ett slumpmässigt mål.
      PVector pos;
      Node node;
      do {
        pos = grid.getRandomNodePosition();
        node = grid.getNearestNode(pos);
      } while (node.isVisited);
      
      moveTo(pos); // Slumpmässigt mål.
    } 

    public void search() {
      Node start = grid.getNearestNode(this.position);
      List<Node> aStarPath = this.team.graph.aStarSearch(start, startNode);
      List<Node> breadthFirstPath = this.team.graph.breadthFirstSearch(start, startNode);
      /*if (path != null) {
        int step = 1;
        for (int i = path.size() - 1; i >= 0; i--) {
          println("Step: " + step + ", Column: " + path.get(i).col + ", Row: " + path.get(i).row);
          step++;
        }
      }*/
      this.pause_state = false;
    }


    //*******************************************************
    // Tanken meddelas om kollision med trädet.
    public void message_collision(Tree other) {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].collision(Tree)");
      wander();
    }

    //*******************************************************
    // Tanken meddelas om kollision med tanken.
    public void message_collision(Tank other) {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].collision(Tank)");

      //moveTo(new PVector(int(random(width)),int(random(height))));
      //println("this.getName());" + this.getName()+ ", this.team_id: "+ this.team_id);
      //println("other.getName());" + other.getName()+ ", other.team_id: "+ other.team_id);

      if ((other.getName() == "tank") && (other.team_id != this.team_id)) {
        if (this.hasShot && (!other.isDestroyed)) {
          println("["+this.team_id+":"+ this.getId() + "] SKJUTER PÅ ["+ other.team_id +":"+other.getId()+"]");
          fire();
        } else {
          retreat(other);
        }

        rotateTo(other.position);
        //wander();
      } else {
        wander();
      }
    }
    
    //*******************************************************  
    // Tanken meddelas om den har kommit hem.
    public void message_arrivedAtHomebase() {
      //println("*** Team"+this.team_id+".Tank["+ this.getId() + "].message_isAtHomebase()");
      println("! Hemma!!! Team"+this.team_id+".Tank["+ this.getId() + "]");
    }

    //*******************************************************
    // används inte.
    public void readyAfterHit() {
      super.readyAfterHit();
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].readyAfterHit()");

      //moveTo(grid.getRandomNodePosition());
      wander();
    }

    //*******************************************************
    public void arrivedRotation() {
      super.arrivedRotation();
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].arrivedRotation()");
      //moveTo(new PVector(int(random(width)),int(random(height))));
      arrived();
    }

    //*******************************************************
    public void arrived() {
      super.arrived();
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].arrived()");

      //moveTo(new PVector(int(random(width)),int(random(height))));
      //moveTo(grid.getRandomNodePosition());
      wander();
    }

    //*******************************************************
    public void updateLogic() {
      super.updateLogic();

      if (!started) {
        started = true;
        moveTo(grid.getRandomNodePosition());
      }

      if (!this.userControlled) {
        if (this.search_state) {
          search();
          this.search_state = false;
          this.pause_state = true;

        } else {
          //moveForward_state();
          if (this.stop_state && !this.pause_state) {
            //rotateTo()
            wander();
          }

          if (this.idle_state && !this.pause_state) {
            wander();
          }
        }
        
      }
    }
  }
}
