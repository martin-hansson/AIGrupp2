import java.util.Collections;

class Game {
    Grid grid;
    Team playerTeam;
    Team opponentTeam;
    Team currentTeam;

    Node playerPosition;
    Node opponentPosition;

    Game(Grid grid) {
        this.grid = grid;
    }

    void reset() {
        this.playerPosition = this.grid.getNearestNode(playerTeam.tanks[0].position);
        this.opponentPosition = this.grid.getNearestNode(opponentTeam.tanks[2].position);
        for (Node[] rows : this.grid.nodes) {
            for (Node node : rows) {
                if (!node.isFilled)
                    node.fill = 0;
            }
        }
    }

    Node result(Node current, Action action, Team player) {
        println(player);
        if (current.fill == 0)
            current.fill = player.team_color;
        
        Node next = null;
        switch (action) {
            case UP:
                next = grid.nodes[current.col][current.row - 1];
                break;
            case DOWN:
                next = grid.nodes[current.col][current.row + 1];
                break;
            case LEFT:
                next = grid.nodes[current.col - 1][current.row];
                break;
            case RIGHT:
                next = grid.nodes[current.col + 1][current.row];
                break;
        }

        if (player == playerTeam) {
            playerPosition = next;
            currentTeam = opponentTeam;
            return opponentPosition;
        } else {
            opponentPosition = next;
            currentTeam = playerTeam;
            return playerPosition;
        }
    }

    int utility(Team player) {
        Team currentPlayer = player == playerTeam ? playerTeam : opponentTeam;
        int myScore = 0;
        int opponentScore = 0;
        for (Node[] rows : this.grid.nodes) {
            for (Node node : rows) {
                println("(" + node.row + "," + node.col + "):" + node.isFilled + ":" + node.fill);
                if (node.isFilled && node.fill == currentPlayer.team_color)
                    myScore--;
                else if (node.fill == currentPlayer.team_color)
                    myScore++;
                else if (node.fill != currentPlayer.team_color && node.fill != 0)
                    opponentScore++;
            }
        }
        println("My score: " + myScore + " Opponent score: " + opponentScore);
        return myScore - opponentScore;
    }

    List<Action> getActions(Node current) {
        List<Action> actions = new ArrayList<Action>();
        if (current.col - 1 >= 0)
            if (grid.nodes[current.col - 1][current.row].isEmpty)
                actions.add(Action.LEFT);
        if (current.col + 1 <= 14)
            if (grid.nodes[current.col + 1][current.row].isEmpty)
                actions.add(Action.RIGHT);
        if (current.row - 1 >= 0)
            if (grid.nodes[current.col][current.row - 1].isEmpty)
                actions.add(Action.UP);
        if (current.row + 1 <= 14)
            if (grid.nodes[current.col][current.row + 1].isEmpty)
                actions.add(Action.DOWN);
        
        Collections.shuffle(actions);
        return actions;
    }
}

enum Action {
  UP, LEFT, RIGHT, DOWN;
}