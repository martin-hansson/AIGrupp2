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

    void reset() {
        this.playerPosition = this.grid.getNearestNode(playerTeam.tanks[0].position);
        this.opponentPosition = this.grid.getNearestNode(opponentTeam.tanks[2].position);
        for (Node[] rows : this.grid.nodes) {
            for (Node node : rows) {
                if (node.claimed == null)
                    node.fill = 0;
                else if (node.claimed != null)
                    node.fill = node.claimed.team_color;
            }
        }
    }
    
    void reset(List<Node> moveSet) {
        for (Node node : moveSet) {
            if (node.claimed == null) {
                node.fill = 0;
            }
        }
    }

    GameState result(Node current, Action action, Team player) {
        List<Node> moveSet = new ArrayList<Node>();
        // moveSet.add(current);
        if (current.fill == 0)
            current.fill = player.team_color;
        
        Node next = current;
        switch (action) {
            case UP:
                while (next.row - 1 >= 0 && grid.nodes[next.col][next.row - 1].isEmpty) {
                    next.fill = player.team_color;
                    next = grid.nodes[next.col][next.row - 1];
                    moveSet.add(next);
                }
                break;
            case DOWN:
                while (next.row + 1 < 15 && grid.nodes[next.col][next.row + 1].isEmpty) {
                    next.fill = player.team_color;
                    next = grid.nodes[next.col][next.row + 1];
                    moveSet.add(next);
                }
                break;
            case LEFT:
                while (next.col - 1 >= 0 && grid.nodes[next.col - 1][next.row].isEmpty) {
                    next.fill = player.team_color;
                    next = grid.nodes[next.col - 1][next.row];
                    moveSet.add(next);
                }
                break;
            case RIGHT:
                while (next.col + 1 < 15 && grid.nodes[next.col + 1][next.row].isEmpty) {
                    next.fill = player.team_color;
                    next = grid.nodes[next.col + 1][next.row];
                    moveSet.add(next);
                }
                break;
        }

        if (player == playerTeam) {
            playerPosition = next;
            currentTeam = opponentTeam;
            return new GameState(opponentPosition, moveSet);
        } else {
            opponentPosition = next;
            currentTeam = playerTeam;
            return new GameState(playerPosition, moveSet);
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
        /*Team currentPlayer;
        if (player == playerTeam) {
            currentPlayer = playerTeam;
        } else {
            currentPlayer = opponentTeam;
        }

        int myScore = 0;
        int opponentScore = 0;
        for (Node[] rows : this.grid.nodes) {
            for (Node node : rows) {
                if (node.claimed == currentPlayer)
                    myScore--;
                else if (node.fill == currentPlayer.team_color)
                    myScore++;
                else if (node.fill != currentPlayer.team_color && node.fill != 0)
                    opponentScore++;
            }
        }
        println("My score: " + myScore + " Opponent score: " + opponentScore);
        return myScore - opponentScore;*/

        int utility = 0;
        for (Node[] rows : this.grid.nodes) {
            for (Node node : rows) {
                if (node.fill == player.team_color)
                    utility++;
            }
        }

        return utility;
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