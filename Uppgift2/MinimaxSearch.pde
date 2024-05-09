import java.time.LocalDateTime;

class MinimaxSearch {
    int LIMIT = 20;

    Game game;
    Grid grid;
    int depth;

    Team maxTeam;
    Team minTeam;

    MinimaxSearch(Game game, Team maxTeam) {
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
        println("Minimax start time: " + LocalDateTime.now().toString());
        Move move = maxValue(start, depth);
        game.reset();
        println("Minimax end time: " + LocalDateTime.now().toString());
        return move.action;
    }

    Move maxValue(Node current, int depth) {
        if (depth > LIMIT) {
            return new Move(game.utility(maxTeam), null);
        }

        Move move = new Move(Integer.MIN_VALUE, null);
        for (Action action : game.getActions(current)) {
            GameState state = game.result(current, action, maxTeam);
            Move nextMove = minValue(state.opponent, depth + 1);
            if (nextMove.value > move.value) {
                move.value = nextMove.value;
                move.action = action;
            }
            game.reset(state.moveSet);
        }

        return move;
    }

    Move minValue(Node current, int depth) {
        if (depth > LIMIT) {
            return new Move(game.utility(minTeam), null);
        }

        Move move = new Move(Integer.MAX_VALUE, null);
        for (Action action : game.getActions(current)) {
            GameState state = game.result(current, action, minTeam);
            Move nextMove = maxValue(state.opponent, depth + 1);
            if (nextMove.value < move.value) {
                move.value = nextMove.value;
                move.action = action;
            }
            game.reset(state.moveSet);
        }
        return move;
    }
}