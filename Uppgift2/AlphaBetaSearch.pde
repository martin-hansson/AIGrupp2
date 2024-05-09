import java.time.LocalDateTime;

class AlphaBetaSearch {
    int LIMIT = 20;

    Game game;
    Grid grid;
    int depth;

    Team maxTeam;
    Team minTeam;

    AlphaBetaSearch(Game game, Team maxTeam) {
        this.game = game;
        this.grid = new Grid(game.grid);
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
        Move move = maxValue(start, depth, Integer.MIN_VALUE, Integer.MAX_VALUE);
        game.reset();
        println("AlphaBeta end time: " + LocalDateTime.now().toString());

        return move.action;
    }

    Move maxValue(Node current, int depth, int alpha, int beta) {
        if (depth > LIMIT) {
            return new Move(game.utility(maxTeam), null);
        }

        Move move = new Move(Integer.MIN_VALUE, null);
        for (Action action : game.getActions(current)) {
            GameState state = game.result(current, action, maxTeam);
            Move nextMove = minValue(state.opponent, depth + 1, alpha, beta);
            if (nextMove.value > move.value) {
                move.value = nextMove.value;
                move.action = action;
                alpha = Math.max(alpha, move.value);
            }
            game.reset(state.moveSet);
            if (move.value >= beta) {
                return move;
            }
        }

        return move;
    }

    Move minValue(Node current, int depth, int alpha, int beta) {
        if (depth > LIMIT) {
            return new Move(game.utility(minTeam), null);
        }

        Move move = new Move(Integer.MAX_VALUE, null);
        for (Action action : game.getActions(current)) {
            GameState state = game.result(current, action, minTeam);
            Move nextMove = maxValue(state.opponent, depth + 1, alpha, beta);
            if (nextMove.value < move.value) {
                move.value = nextMove.value;
                move.action = action;
                beta = Math.min(beta, move.value);
            }
            game.reset(state.moveSet);
            if (move.value <= alpha) {
                return move;
            }
        }
        return move;
    }
}