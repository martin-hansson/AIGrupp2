// Grupp 02:
// Alexandra Jansson alja5888,
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

import java.util.Collections;
import java.util.List;
import java.util.ArrayList;

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

    Game copy() {
        Game copy = new Game(grid.copy());
        copy.playerTeam = this.playerTeam;
        copy.opponentTeam = this.opponentTeam;
        copy.currentTeam = this.currentTeam;
        copy.playerPosition = this.playerPosition;
        copy.opponentPosition = this.opponentPosition;
        return copy;
    }

    void reset() {
        this.playerPosition = this.grid.getNearestNode(playerTeam.tanks[0].position);
        this.opponentPosition = this.grid.getNearestNode(opponentTeam.tanks[2].position);
        for (Node[] rows : this.grid.nodes) {
            for (Node node : rows) {
                if (node.claimed == null)
                    node.fill = null;
                else if (node.claimed != null)
                    node.fill = node.claimed;
            }
        }
    }
    
    void reset(List<Node> moveSet) {
        for (Node node : moveSet) {
            if (node.claimed == null) {
                node.fill = null;
            }
        }
    }

    GameState result(Node current, Action action, Team player) {
        List<Node> moveSet = new ArrayList<Node>();
        // moveSet.add(current);
        if (current.fill == null)
            current.fill = player;
        
        Node next = current;
        switch (action) {
            case UP:
                while (next.row - 1 >= 0 && grid.nodes[next.col][next.row - 1].isEmpty) {
                    next.fill = player;
                    next = grid.nodes[next.col][next.row - 1];
                    moveSet.add(next);
                }
                break;
            case DOWN:
                while (next.row + 1 < 15 && grid.nodes[next.col][next.row + 1].isEmpty) {
                    next.fill = player;
                    next = grid.nodes[next.col][next.row + 1];
                    moveSet.add(next);
                }
                break;
            case LEFT:
                while (next.col - 1 >= 0 && grid.nodes[next.col - 1][next.row].isEmpty) {
                    next.fill = player;
                    next = grid.nodes[next.col - 1][next.row];
                    moveSet.add(next);
                }
                break;
            case RIGHT:
                while (next.col + 1 < 15 && grid.nodes[next.col + 1][next.row].isEmpty) {
                    next.fill = player;
                    next = grid.nodes[next.col + 1][next.row];
                    moveSet.add(next);
                }
                break;
        }
        next.fill = player;

        if (player == playerTeam) {
            playerPosition = next;
            currentTeam = opponentTeam;
            return new GameState(moveSet, opponentPosition, this);
        } else {
            opponentPosition = next;
            currentTeam = playerTeam;
            return new GameState(moveSet, playerPosition, this);
        }
    }

    int score(Team player) {
        int score = 0;
        for (Node[] rows : this.grid.nodes) {
            for (Node node : rows) {
                if (node.claimed == player)
                    score++;
            }
        }

        return score;
    }

    int utility(Team player) {
        // this.grid.print();
        int playerScore = 0;
        int opponentScore = 0;

        for (Node[] rows : this.grid.nodes) {
            for (Node node : rows) {
                if (node.fill == player)
                    playerScore++;
                if (node.fill != player && node.fill != null)
                    opponentScore++;
            }
        }

        return playerScore - opponentScore;
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
        
        //Collections.shuffle(actions);
        return actions;
    }
}

enum Action {
  UP, LEFT, RIGHT, DOWN;
}