class Game {
    Grid grid;
    Team playerTeam;
    Team opponentTeam;
    Team currentTeam;

    Game(Grid grid) {
        this.grid = grid;
    }

    Node result(Node current, Action action) {
        current.fill = currentTeam.team_color;
        if (currentTeam == playerTeam) {
            currentTeam = opponentTeam;
            return this.grid.getNearestNode(currentTeam.tanks[2].position);
        } else {
            currentTeam = playerTeam;
            return this.grid.getNearestNode(currentTeam.tanks[0].position);
        }
    }

    int utility() {
        int myScore = 0;
        int opponentScore = 0;
        for (Node[] rows : this.grid.nodes) {
            for (Node node : rows) {
                if (node.fill == currentTeam.team_color)
                    myScore++;
                else
                    opponentScore++;
            }
        }

        return myScore - opponentScore;
    }

    List<Action> getActions(Node current) {
        List<Action> actions = new ArrayList<Action>();
        if (current.col - 1 >= 0)
            if (grid.nodes[current.col - 1][current.row].isEmpty)
                actions.add(Action.LEFT);
        if (current.col + 1 < 15)
            if (grid.nodes[current.col + 1][current.row].isEmpty)
                actions.add(Action.RIGHT);
        if (current.row - 1 >= 0)
            if (grid.nodes[current.col][current.row - 1].isEmpty)
                actions.add(Action.UP);
        if (current.row + 1 < 15)
            if (grid.nodes[current.col][current.row + 1].isEmpty)
                actions.add(Action.DOWN);
        return actions;
    }
}

enum Action {
  UP, LEFT, RIGHT, DOWN;
}