import java.time.LocalDateTime;

class AlphaBetaSearch {
    int LIMIT = 11;

    Game game;
    Grid grid;
    int depth;

    Team maxTeam;
    Team minTeam;

    AlphaBetaSearch(Game game, Team maxTeam) {
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
        println("AlphaBeta start time: " + LocalDateTime.now().toString());
        Move move = maxValue(game, start, depth, Integer.MIN_VALUE, Integer.MAX_VALUE);
        println("AlphaBeta end time: " + LocalDateTime.now().toString());

        return move.action;
    }

    Move maxValue(Game game, Node current, int depth, int alpha, int beta) {
        if (depth == LIMIT) {
            return new Move(game.utility(minTeam), null);
        }

        // println("\t".repeat(depth) + "MAX" + "(" + current.row + "," + current.col + ")");

        Move move = new Move(Integer.MIN_VALUE, null);
        Game trial = game.copy();
        for (Action action : game.getActions(current)) {
            // println("\t".repeat(depth) + action);
            GameState state = trial.result(current, action, maxTeam);
            Move nextMove = minValue(state.game, state.opponent, depth + 1, alpha, beta);
            if (nextMove.value > move.value) {
                move.value = nextMove.value;
                move.action = action;
                alpha = Math.max(alpha, move.value);
            }
            trial = game.copy();
            if (move.value >= beta) {
                return move;
            }
        }

        return move;
    }

    Move minValue(Game game, Node current, int depth, int alpha, int beta) {
        if (depth == LIMIT) {
            return new Move(game.utility(maxTeam), null);
        }

        // println("\t".repeat(depth) + "MIN" + "(" + current.row + "," + current.col + ")");

        Move move = new Move(Integer.MAX_VALUE, null);
        Game trial = game.copy();
        for (Action action : game.getActions(current)) {
            // println("\t".repeat(depth) + action);
            GameState state = trial.result(current, action, minTeam);
            Move nextMove = maxValue(state.game, state.opponent, depth + 1, alpha, beta);
            if (nextMove.value < move.value) {
                move.value = nextMove.value;
                move.action = action;
                beta = Math.min(beta, move.value);
            }
            trial = game.copy();
            if (move.value <= alpha) {
                return move;
            }
        }
        return move;
    }
}