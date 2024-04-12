// Följande kan användas som bas inför uppgiften.
// Syftet är att sammanställa alla varabelvärden i scenariet.
// Variabelnamn har satts för att försöka överensstämma med exempelkoden.
// Klassen Tank är minimal och skickas mer med som koncept(anrop/states/vektorer).

boolean left, right, up, down;
boolean mouse_pressed;

PImage tree_img;
PVector tree1_pos, tree2_pos, tree3_pos;

Tree[] allTrees   = new Tree[3];
Tank[] allTanks   = new Tank[6];
Team[] teams = new Team[2];

Grid grid;
int cols = 15;
int rows = 15;
int grid_size = 50;

// Team0
color team0Color;
PVector team0_tank0_startpos;
PVector team0_tank1_startpos;
PVector team0_tank2_startpos;
Tank tank0, tank1, tank2;

// Team1
color team1Color;
PVector team1_tank0_startpos;
PVector team1_tank1_startpos;
PVector team1_tank2_startpos;
Tank tank3, tank4, tank5;

int tank_size;

boolean gameOver;
boolean pause;
boolean debugOn;

//======================================
void setup() 
{
  size(800, 800);
  up             = false;
  down           = false;
  mouse_pressed  = false;
  
  gameOver       = false;
  pause          = true;
  debugOn        = true;

  grid = new Grid(cols, rows, grid_size);
  
  // Trad
  tree_img = loadImage("tree01_v2.png");
  //tree1_pos = new PVector(230, 600);
  //tree2_pos = new PVector(280, 230);
  //tree3_pos = new PVector(530, 520);
  allTrees[0] = new Tree(230, 600);
  allTrees[1] = new Tree(280,230);//280,230(300,300)
  allTrees[2] = new Tree(530, 520);//530, 520(500,500);
  
  tank_size = 50;

  // Team0
  team0Color  = color(204, 50, 50);             // Base Team 0(red)
  team0_tank0_startpos  = new PVector(50, 50);
  team0_tank1_startpos  = new PVector(50, 150);
  team0_tank2_startpos  = new PVector(50, 250);
  
  // Team1
  team1Color  = color(0, 150, 200);             // Base Team 1(blue)
  team1_tank0_startpos  = new PVector(width-50, height-250);
  team1_tank1_startpos  = new PVector(width-50, height-150);
  team1_tank2_startpos  = new PVector(width-50, height-50);

  // nytt Team: id, color, tank0pos, id, shot
  teams[0] = new Team1(0, tank_size, team0Color, 
                      team0_tank0_startpos, 0, /* allShots[0], */
                      team0_tank1_startpos, 1, /* allShots[1], */
                      team0_tank2_startpos, 2/* , allShots[2] */);
  
  allTanks[0] = teams[0].tanks[0];
  allTanks[1] = teams[0].tanks[1];
  allTanks[2] = teams[0].tanks[2];
  
  teams[1] = new Team2(1, tank_size, team1Color, 
                      team1_tank0_startpos, 3, /* allShots[3], */
                      team1_tank1_startpos, 4, /* allShots[4], */
                      team1_tank2_startpos, 5/* , allShots[5] */);
  
  allTanks[3] = teams[1].tanks[0];
  allTanks[4] = teams[1].tanks[1];
  allTanks[5] = teams[1].tanks[2];
  
  /* //tank0_startpos = new PVector(50, 50);
  tank0 = new Tank("tank0", team0_tank0_startpos, tank_size, team0Color );
  tank1 = new Tank("tank1", team0_tank1_startpos,tank_size, team0Color );
  tank2 = new Tank("tank2", team0_tank2_startpos,tank_size, team0Color );
  
  tank3 = new Tank("tank3", team1_tank0_startpos,tank_size, team1Color );
  tank4 = new Tank("tank4", team1_tank1_startpos,tank_size, team1Color );
  tank5 = new Tank("tank5", team1_tank2_startpos,tank_size, team1Color ); */
  
  /* allTanks[0] = tank0;                         // Symbol samma som index!
  allTanks[1] = tank1;
  allTanks[2] = tank2;
  allTanks[3] = tank3;
  allTanks[4] = tank4;
  allTanks[5] = tank5; */
}

void draw()
{
  background(200);
  checkForInput(); // Kontrollera inmatning.
  
  if (!gameOver && !pause) {
    
    // UPDATE LOGIC
    updateTanksLogic();
    updateTeamsLogic();

    updateTanks();
    
    // CHECK FOR COLLISIONS
    checkForCollisions();
  
  }

  if (debugOn) {
    // Visa framerate.
    fill(30);
    //text("FPS:"+ floor(frameRate), 10, height-10);

    // Visa grid.
    fill(205);
    gridDisplay();

    // Visa musposition och den närmaste noden.
    fill(255, 92, 92);
    ellipse(mouseX, mouseY, 5, 5);
    grid.displayNearestNode(mouseX, mouseY);

    for (GridNode node : this.teams[0].graph.graph.keySet()) {
      strokeWeight(1);
      stroke(255, 92, 92);
      fill(255, 92, 92);
      grid.displayNearestNode(node.position);
      List<Edge> edges = this.teams[0].graph.getEdges(node);
      if (edges == null) 
        continue;
      
      for (Edge edge : edges) {
        strokeWeight(1);
        stroke(255, 92, 92);
        GridNode adjacent = edge.to;

        if (edge.isAStarPath) {
          strokeWeight(4);
          stroke(0);
          line(node.position.x, node.position.y, adjacent.position.x, adjacent.position.y); 
        }
        
        if (edge.isBreadthFirstPath) {
          strokeWeight(2);
          stroke(50, 205, 50);
        }

        line(node.position.x, node.position.y, adjacent.position.x, adjacent.position.y); 
      }
    }
  }
  
  // UPDATE DISPLAY 
  displayHomeBase();
  displayTrees();
  displayTanks();  
  displayGUI();
}

//======================================
void checkForInput() {
  
      /* if (up) {
        if (!pause && !gameOver) {
          tank0.state=1; // moveForward
        }
      } else 
      if (down) {
        if (!pause && !gameOver) {
          tank0.state=2; // moveBackward
        }
      }
      
      if (right) {
      } else 
      if (left) {
      }
      
      if (!up && !down) {
        tank0.state=0;
      } */
}

//======================================
// call to Tank updateLogic()
void updateTanksLogic() {
  for (Tank tank : allTanks) {
    if (tank.isReady) {
      if (teams[1].isInHomebase(tank.position))
        tank.search_state = true;
      tank.updateLogic();
    }
  }
}

// call to Tank update()
void updateTanks() {
  for (Tank tank : allTanks) {
    //if (tank.health > 0)
    tank.update();
  }
}

void updateTeamsLogic() {
  teams[0].updateLogic();
  teams[1].updateLogic();
}

void checkForCollisions() {
  // Check for collisions with Canvas Boundaries
  for (int i = 0; i < allTanks.length; i++) {
    allTanks[i].checkEnvironment();
    
    // Check for collisions with "no Smart Objects", Obstacles (trees, etc.)
    for (int j = 0; j < allTrees.length; j++) {
      allTanks[i].checkCollision(allTrees[j]);
    }
    
    // Check for collisions with "Smart Objects", other Tanks.
    for (int j = 0; j < allTanks.length; j++) {
      //if ((allTanks[i].getId() != j) && (allTanks[i].health > 0)) {
      if (allTanks[i].getId() != j) {
        allTanks[i].checkCollision(allTanks[j]);
      }
    }
  }
}

//======================================
// Följande bör ligga i klassen Team
void displayHomeBase() {
  strokeWeight(1);

  fill(team0Color, 15);    // Base Team 0(red)
  rect(0, 0, 150, 350);
  
  fill(team1Color, 15);    // Base Team 1(blue) 
  rect(width - 151, height - 351, 150, 350);
}
  
// Följande bör ligga i klassen Tree
/* void displayTrees() {
  imageMode(CENTER);
  image(tree_img, tree1_pos.x, tree1_pos.y);
  image(tree_img, tree2_pos.x, tree2_pos.y);
  image(tree_img, tree3_pos.x, tree3_pos.y);
  imageMode(CORNER);
} */

void displayTanks() {
  for (Tank tank : allTanks) {
    tank.display();
  }
}

void displayGUI() {
  if (pause) {
    textSize(36);
    fill(30);
    text("...Paused! (\'p\'-continues)\n(upp/ner-change velocity)", width/1.7-100, height/2.5);
  }
  
  if (gameOver) {
    textSize(36);
    fill(30);
    text("Game Over!", width/2-100, height/2);
  }  
}

void gridDisplay() {
  strokeWeight(0.3);

  grid.display();
}

void displayTrees() {
  for (int i = 0; i<allTrees.length; i++) {
    allTrees[i].display();
  }
}

//======================================
void keyPressed() {
  System.out.println("keyPressed!");

    if (key == CODED) {
      switch(keyCode) {
      case LEFT:
        left = true;
        break;
      case RIGHT:
        right = true;
        break;
      case UP:
        up = true;
        break;
      case DOWN:
        down = true;
        break;
      }
    }

}

void keyReleased() {
  System.out.println("keyReleased!");
    if (key == CODED) {
      switch(keyCode) {
      case LEFT:
        left = false;
        break;
      case RIGHT:
        right = false;
        break;
      case UP:
        up = false;
        //tank0.stopMoving();
        break;
      case DOWN:
        down = false;
        //tank0.stopMoving();
        break;
      }
      
    }
    
    if (key == 'p') {
      pause = !pause;
    }

    if (key == 'd') {
      debugOn = !debugOn;
    }

    if (key == 's') {
      for (Tank tank : allTanks) {
        if (tank.isReady)
          tank.search_state = true;
      }
    }

    if (key == 'r') {
      for (List<Edge> edges : teams[0].graph.graph.values()) {
        for (Edge edge : edges) {
          edge.isBreadthFirstPath = false;
          edge.isAStarPath = false;
        }
      }
    }

    if (key == 'e') {
      for (List<Edge> edges : teams[0].graph.graph.values()) {
        for (Edge edge : edges)
          System.out.println(edge);
      }
    }
}

// Mousebuttons
void mousePressed() {
  println("---------------------------------------------------------");
  println("*** mousePressed() - Musknappen har tryckts ned.");
  
  mouse_pressed = true;
  
}
