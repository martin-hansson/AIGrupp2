import java.time.LocalDateTime;

class MinimaxSearch {
    int LIMIT = 7;

    Game game;
    Grid grid;
    int depth;

    Team maxTeam;
    Team minTeam;

    MinimaxSearch(Game game, Team maxTeam) {
        this.game = game.copy();
        this.grid = game.grid;
        this.depth = 0;

        if (maxTeam == game.playerTeam) {
            this.maxTeam = game.playerTeam;
            this.minTeam = game.opponentTeam;
        } else {
            this.maxTeam = game.opponentTeam;
            this.minTeam = game.playerTeam;
        }
    }

    Action search(Node start) {
        println("Minimax start time: " + LocalDateTime.now().toString());
        Move move = maxValue(game, start, depth);
        println("Minimax end time: " + LocalDateTime.now().toString());
        return move.action;
    }

    Move maxValue(Game game, Node current, int depth) {
        if (depth == LIMIT) {
            return new Move(game.utility(minTeam), null);
        }

        // println("\t".repeat(depth) + "MAX" + "(" + current.row + "," + current.col + ")");

        Move move = new Move(Integer.MIN_VALUE, null);
        Game trial = game.copy();
        for (Action action : game.getActions(current)) {
            // println("\t".repeat(depth) + action);
            GameState state = trial.result(current, action, maxTeam);
            Move nextMove = minValue(state.game, state.opponent, depth + 1);
            if (nextMove.value > move.value) {
                move.value = nextMove.value;
                move.action = action;
            }
            trial = game.copy();
        }

        return move;
    }

    Move minValue(Game game, Node current, int depth) {
        if (depth == LIMIT) {
            return new Move(game.utility(maxTeam), null);
        }

        // println("\t".repeat(depth) + "MIN" + "(" + current.row + "," + current.col + ")");

        Game trial = game.copy();
        Move move = new Move(Integer.MAX_VALUE, null);
        for (Action action : game.getActions(current)) {
            // println("\t".repeat(depth) + action);
            GameState state = trial.result(current, action, minTeam);
            Move nextMove = maxValue(state.game, state.opponent, depth + 1);
            if (nextMove.value < move.value) {
                move.value = nextMove.value;
                move.action = action;
            }
            trial = game.copy();
        }
        return move;
    }
}