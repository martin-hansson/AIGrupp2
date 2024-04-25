class Grid {
  int cols, rows;
  int grid_size;
  Node[][] nodes;

  //***************************************************  
  Grid(int _cols, int _rows, int _grid_size) {
    cols = _cols;
    rows = _rows;
    grid_size = _grid_size;
    nodes = new Node[cols][rows];

    createGrgetId();
  }

  Grid(Grid grid) {
    cols = grid.cols;
    rows = grid.rows;
    grid_size = grid.grid_size;
    nodes = new Node[cols][rows];

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        nodes[i][j] = new Node(grid.nodes[i][j]);
      }
    }
  }

  //***************************************************  
  void createGrgetId() {

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Initialize each object
        nodes[i][j] = new Node(i, j, i*grid_size+grid_size, j*grid_size+grid_size);
      }
    }
  }

  //***************************************************  
  // ANVÄNDS INTE!
  void display1() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Initialize each object
        line(j*grid_size+grid_size, 0, j*grid_size+grid_size, height);
      }
      line(0, i*grid_size+grid_size, width, i*grid_size+grid_size);
    }
  }

  //***************************************************  
  void display() {
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        // Initialize each object
        ellipse(nodes[i][j].position.x, nodes[i][j].position.y, 5.0, 5.0);
        //println("nodes[i][j].position.x: " + nodes[i][j].position.x);
        //println(nodes[i][j]);
      }
      //line(0, i*grid_size+grid_size, width, i*grid_size+grid_size);
    }
  }

  //***************************************************  
  // ANVÄNDS INTE!
  PVector getNearestNode1(PVector pvec) {
    //PVector pvec = new PVector(x,y);
    PVector vec = new PVector(0, 0);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (nodes[i][j].position.dist(pvec) < grid_size/2) {
          vec.set(nodes[i][j].position);
        }
      }
    }
    return vec;
  }

  //***************************************************  
  Node getNearestNode(PVector pvec) {
    // En justering för extremvärden.
    float tempx = pvec.x;
    float tempy = pvec.y;
    if (pvec.x < 5) { 
      tempx=5;
    } else if (pvec.x > width-5) {
      tempx=width-5;
    }
    if (pvec.y < 5) { 
      tempy=5;
    } else if (pvec.y > height-5) {
      tempy=height-5;
    }

    pvec = new PVector(tempx, tempy);

    ArrayList<Node> nearestNodes = new ArrayList<Node>();

    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (nodes[i][j].position.dist(pvec) < grid_size) {
          nearestNodes.add(nodes[i][j]);
        }
      }
    }

    Node nearestNode = new Node(0, 0);
    for (int i = 0; i < nearestNodes.size(); i++) {
      if (nearestNodes.get(i).position.dist(pvec) < nearestNode.position.dist(pvec) ) {
        nearestNode = nearestNodes.get(i);
      }
    }

    return nearestNode;
  }

  // Node getNearestNodePosition(PVector pvec) {

  //  ArrayList<Node> nearestNodes = new ArrayList<Node>();

  //  for (int i = 0; i < cols; i++) {
  //    for (int j = 0; j < rows; j++) {
  //      if (nodes[i][j].position.dist(pvec) < grid_size) {
  //        nearestNodes.add(nodes[i][j]);      
  //      }
  //    }
  //  }

  //  Node nearestNode = new Node(0,0);
  //  for (int i = 0; i < nearestNodes.size(); i++) {
  //    if (nearestNodes.get(i).position.dist(pvec) < nearestNode.position.dist(pvec) ) {
  //      nearestNode = nearestNodes.get(i);
  //    }
  //  }

  //  return nearestNode;
  //}
  
  //***************************************************  
  PVector getNearestNodePosition(PVector pvec) {
    Node n = getNearestNode(pvec);
    
    return n.position;
  }

  //***************************************************  
  // ANVÄNDS INTE?
  void displayNearestNode(float x, float y) {
    PVector pvec = new PVector(x, y);
    displayNearestNode(pvec);
  }

  //***************************************************  
  // ANVÄNDS INTE!
  void displayNearestNode1(PVector pvec) {
    //PVector pvec = new PVector(x,y);
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        if (nodes[i][j].position.dist(pvec) < grid_size/2) {
          PVector vec = nodes[i][j].position;
          ellipse(vec.x, vec.y, 5, 5);
        }
      }
    }
  }

  //***************************************************  
  void displayNearestNode(PVector pvec) {

    PVector vec = getNearestNodePosition(pvec);
    ellipse(vec.x, vec.y, 5, 5);
  }

  //***************************************************  
  PVector getRandomNodePosition() {
    int c = int(random(cols));
    int r = int(random(rows));

    PVector rn = nodes[c][r].position;

    return rn;
  }
  
  //***************************************************
  // Används troligen tillsammans med getNearestNode().empty
  // om tom så addContent(Sprite)
  void addContent(Sprite s) {
    Node n = getNearestNode(s.position);
    n.addContent(s);
  }

  Node getNode(int col, int row) {
    return nodes[col][row];
  }

  Node result(Node current, Action action, color player) {
    Node next = null;
    switch (action) {
      case UP:
        next =  getNode(current.col, current.row - 1);
        break;
      case DOWN:
        next = getNode(current.col, current.row + 1);
        break;
      case LEFT:
        next = getNode(current.col - 1, current.row);
        break;
      case RIGHT:
        next = getNode(current.col + 1, current.row);
        break;
    }
    next.fill = player;
    return next;
  }

  int utility(color player) {
    int myScore = 0;
    int opponentScore = 0;
    for (Node[] rows : nodes) {
      for (Node node : rows) {
        if (node.fill == player)
          myScore++;
        else
          opponentScore++;
      }
    }

    return myScore - opponentScore;
  }
  
}
