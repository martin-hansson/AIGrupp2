
//Grupp 02:
// Alexandra Jansson, alja5888
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

import java.util.Collections;

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
    // Path path;
    List<GridNode> path;
    int pathIndex;
    float r = 4.0;

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
      GridNode node;
      do {
        pos = grid.getRandomNodePosition();
        node = grid.getNearestNode(pos);
      } while (node.isVisited);
      
      moveTo(pos); // Slumpmässigt mål.
    } 


    // Metod för att agentern ska följa en sökväg.
    public void search() {
      println("Num nodes: " + this.team.graph.getNumNodes());
      println("Num edges: " + this.team.graph.getNumEdges());
      GridNode start = grid.getNearestNode(this.position);

      // Lista för att hålla sökvägen för A*.
      List<GridNode> aStarPath = this.team.graph.aStarSearch(start, startNode);

      // Lista för att hålla sökvägen för BFS.
      List<GridNode> breadthFirstPath = this.team.graph.breadthFirstSearch(start, startNode);
      
      if (aStarPath != null && breadthFirstPath != null) {

        // Kontrollerar vilken sökväg som ska följas
        if (this.aStarState) {
          Collections.reverse(aStarPath);
          this.path = aStarPath;
        } else {
          Collections.reverse(breadthFirstPath);
          this.path = breadthFirstPath;
        }
        
        this.pathIndex = 1;
        this.stop_state = false;
        this.idle_state = false;
        this.follow_state = true;
        this.search_state = false;
      }
    }

    //*******************************************************
    // Tanken meddelas om kollision med trädet.
    public void message_collision(Tree other) {
      println("*** Team"+this.team_id+".Tank["+ this.getId() + "].collision(Tree)");
      if (!this.follow_state)
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

      // Om tanken är i sök-läge, ska den fortsätta att söka.
      if (this.search_state) {
          search();
          moveTo(this.path.get(this.pathIndex).position);
      } else if (this.follow_state) {

        // Kontroll för att se om tanken är i hembasen.
        if (isAtHomebase) {
          this.follow_state = false;

          // Vänta i 3 sekunder innan tanken ska fortsätta att vandra.
          try {
            Thread.sleep(3000);
          } catch (InterruptedException e) {
            e.printStackTrace();
          }
          // Återställer alla kanter och tar bort visualiseringen av sökvägen.
          for (List<Edge> edges : teams[0].graph.graph.values()) {
            for (Edge edge : edges) {
              edge.isBreadthFirstPath = false;
              edge.isAStarPath = false;
            }
          }
          wander();

        // Om tanken inte är i hembasen, ska den fortsätta att följa sökvägen.
        } else {
          moveTo(this.path.get(this.pathIndex).position);
          if (this.pathIndex < this.path.size()-1)
            this.pathIndex++;
        }
      } else
        wander();
    }

    public void updateFollow() {
      // Update velocity
      velocity.add(acceleration);
      // Limit speed
      velocity.limit(maxspeed);
      position.add(velocity);
      // Reset accelertion to 0 each cycle
      acceleration.mult(0);
    }

    // Wraparound
    void borders(Path p) {
      if (position.x > p.getEnd().x + r) {
        position.x = p.getStart().x - r;
        position.y = p.getStart().y + (position.y-p.getEnd().y);
      }
    }

    //*******************************************************
    public void updateLogic() {
      super.updateLogic();

      if (!started) {
        started = true;
        moveTo(grid.getRandomNodePosition());
      }

      if (!this.userControlled) {
        // if (this.search_state) {
        //   search();
        // } else if (this.follow_state) {
        //   follow(this.path);
        //   updateFollow();
        //   borders(this.path);
        //   // moveTo(this.path.get(this.pathIndex).position);
        // } else {
          //moveForward_state();
          
          if (this.stop_state) {
            //rotateTo()
            wander();
          }
          
          if (this.idle_state) {
            wander();
          }
        // }
        
      }
    }
  }
}
