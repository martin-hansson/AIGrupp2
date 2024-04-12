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

    public void search() {
      GridNode start = grid.getNearestNode(this.position);
      List<GridNode> aStarPath = this.team.graph.aStarSearch(start, startNode);
      List<GridNode> breadthFirstPath = this.team.graph.breadthFirstSearch(start, startNode);
      if (aStarPath != null && breadthFirstPath != null) {
        Collections.reverse(aStarPath);
        this.path = aStarPath;
        this.pathIndex = 1;
        // this.path = new Path();
        // for (Node n : aStarPath) {
        //   path.addPoint(n.position.x, n.position.y);
        // }
        this.stop_state = false;
        this.idle_state = false;
        this.follow_state = true;
        this.search_state = false;
        
        // this.pathIndex = 1;
        // this.stop_state = false;
        // this.idle_state = false;
        // this.follow_state = true;
        // this.search_state = false;
        // moveTo(this.path.get(this.pathIndex).position);
      }
    }

    public void seek(PVector target) {
      PVector desired = PVector.sub(target, this.position);
      if (desired.mag() == 0) return;

      desired.normalize();
      desired.mult(this.maxspeed);
      PVector steer = PVector.sub(desired, this.velocity);
      steer.limit(this.maxforce);
      this.applyForce(steer);
    }

    public void follow(Path path) {
      PVector predict = this.velocity.get();
      predict.normalize();
      predict.mult(50);
      PVector predictpos = PVector.add(this.position, predict);

      PVector normal = null;
      PVector target = null;
      float worldRecord = 1000000;

      for (int i = 0; i < path.points.size() - 1; i++) {
        PVector a = path.points.get(i);
        PVector b = path.points.get(i + 1);

        PVector normalPoint = getNormalPoint(predictpos, a, b);

        if (normalPoint.x < a.x || normalPoint.x > b.x) {
          // This is something of a hacky solution, but if it's not within the line segment
          // consider the normal to just be the end of the line segment (point b)
          normalPoint = b.get();
        }

        float distance = PVector.dist(predictpos, normalPoint);
        if (distance < worldRecord) {
          worldRecord = distance;
          normal = normalPoint;

          PVector dir = PVector.sub(b, a);
          dir.normalize();

          dir.mult(10);
          target = normalPoint.get();
          target.add(dir); 
        }
      }

      if (worldRecord > path.radius) {
        seek(target);
      }
    }

    PVector getNormalPoint(PVector p, PVector a, PVector b) {
      PVector ap = PVector.sub(p, a);
      PVector ab = PVector.sub(b, a);
      ab.normalize();
      ab.mult(ap.dot(ab));
      PVector normalPoint = PVector.add(a, ab);
      return normalPoint;
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
      if (this.search_state) {
          search();
          moveTo(this.path.get(this.pathIndex).position);
      } else if (this.follow_state) {
        if (isAtHomebase) {
          this.follow_state = false;
          try {
            Thread.sleep(3000);
          } catch (InterruptedException e) {
            e.printStackTrace();
          }
          for (List<Edge> edges : teams[0].graph.graph.values()) {
            for (Edge edge : edges) {
              edge.isBreadthFirstPath = false;
              edge.isAStarPath = false;
            }
          }
          wander();
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
