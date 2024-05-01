class MinimaxSearch {
    int LIMIT = 3;

    Game game;
    Grid grid;
    int depth;

    MinimaxSearch(Game game) {
        this.game = game;
        this.grid = new Grid(game.grid);
        this.depth = 0;
    }

    Action search(Node start) {
        Move move = maxValue(start, depth);
        return move.action;
    }

    Move maxValue(Node current, int depth) {
        if (depth == LIMIT) {
            return new Move(game.utility(), null);
        }

        Move move = new Move(Integer.MIN_VALUE, null);
        for (Action action : game.getActions(current)) {
            Node nextNode = game.result(current, action);
            println("MAX: " + depth + ":" + action + ":(" + nextNode.row + "," + nextNode.col + ")");
            Move nextMove = minValue(nextNode, depth + 1);
            if (nextMove.value > move.value) {
                move.value = nextMove.value;
                move.action = action;
            }
        }

        return move;
    }

    Move minValue(Node current, int depth) {
        if (depth == LIMIT) {
            return new Move(game.utility(), null);
        }

        Move move = new Move(Integer.MAX_VALUE, null);
        for (Action action : game.getActions(current)) {
            Node nextNode = game.result(current, action);
            println("MIN: " + depth + ":" + action + ":(" + nextNode.row + "," + nextNode.col + ")");
            Move nextMove = maxValue(nextNode, depth + 1);
            if (nextMove.value < move.value) {
                move.value = nextMove.value;
                move.action = action;
            }
        }
        return move;
    }
}

class Move {
    int value;
    Action action;

    Move(int value, Action action) {
        this.value = value;
        this.action = action;
    }
}
