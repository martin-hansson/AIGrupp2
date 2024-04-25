class MinimaxSearch {
    int LIMIT = 3;

    Grid grid;
    color player;
    color opponent;
    int depth;

    MinimaxSearch(Grid grid, color player, color opponent) {
        this.grid = new Grid(grid);
        this.player = player;
        this.opponent = opponent;
        this.depth = 0;
    }

    Action search(Node start) {
        Move move = maxValue(start, depth);
        return move.action;
    }

    Move maxValue(Node current, int depth) {
        if (depth == LIMIT) {
            return new Move(grid.utility(player), null);
        }

        Move move = new Move(Integer.MIN_VALUE, null);
        for (Action action : current.getActions()) {
            println("MAX: " + depth + ":" + action);
            Move nextMove = minValue(grid.result(current, action, player), depth + 1);
            if (nextMove.value > move.value) {
                move.value = nextMove.value;
                move.action = action;
            }
        }

        return move;
    }

    Move minValue(Node current, int depth) {
        if (depth == LIMIT) {
            return new Move(grid.utility(opponent), null);
        }

        Move move = new Move(Integer.MAX_VALUE, null);
        for (Action action : current.getActions()) {
            println("MIN: " + depth + ":" + action);
            Move nextMove = maxValue(grid.result(current, action, opponent), depth + 1);
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
