// Grupp 02:
// Alexandra Jansson alja5888,
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

import java.time.LocalDateTime;

// Klass som genomför en Alpha-Beta Pruning sökning
class AlphaBetaSearch {
    int LIMIT = 11; // Gränsen för hur djupt sökningen får gå

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

    // Söker efter bästa draget
    Action search(Node start) {
        println("AlphaBeta start time: " + LocalDateTime.now().toString());
        Move move = maxValue(game, start, depth, Integer.MIN_VALUE, Integer.MAX_VALUE);
        println("AlphaBeta end time: " + LocalDateTime.now().toString());

        return move.action;
    }

    // Anropas vid MAX-nivåer i trädet
    Move maxValue(Game game, Node current, int depth, int alpha, int beta) {
        // Om gränsvärdet är nått returneras uppskattat värde av spelet
        if (depth == LIMIT) {
            Team team = LIMIT % 2 == 0 ? maxTeam : minTeam;
            return new Move(game.utility(team), null);
        }

        // Skapar ett tentativt drag och spel för att testa drag
        Move move = new Move(Integer.MIN_VALUE, null);
        Game trial = game.copy();

        // För varje möjligt drag
        for (Action action : game.getActions(current)) {
            // Kör draget och och uppdaterar spelet
            GameState state = trial.result(current, action, maxTeam);
            // Anropa MIN-nivå för att hitta bästa draget för motståndaren
            Move nextMove = minValue(state.game, state.opponent, depth + 1, alpha, beta);
            // Om det hittade draget är bättre än det tidigare bästa draget
            if (nextMove.value > move.value) {
                move.value = nextMove.value;
                move.action = action;
                alpha = Math.max(alpha, move.value);
            }
            // Återställ test-spelet
            trial = game.copy();
            // Tidigt stopp ifall det inte finns bättre möjliga drag
            if (move.value >= beta) {
                return move;
            }
        }

        return move;
    }

    // Anropas vid MIN-nivåer i trädet
    Move minValue(Game game, Node current, int depth, int alpha, int beta) {
        // Om gränsvärdet är nått returneras uppskattat värde av spelet
        if (depth == LIMIT) {
            Team team = LIMIT % 2 == 0 ? minTeam : maxTeam;
            return new Move(game.utility(team), null);
        }

        // Skapar ett tentativt drag och spel för att testa drag
        Move move = new Move(Integer.MAX_VALUE, null);
        Game trial = game.copy();

        // För varje möjligt drag
        for (Action action : game.getActions(current)) {
            // Kör draget och och uppdaterar spelet
            GameState state = trial.result(current, action, minTeam);
            // Anropa MAX-nivå för att hitta bästa draget för motståndaren
            Move nextMove = maxValue(state.game, state.opponent, depth + 1, alpha, beta);
            // Om det hittade draget är bättre än det tidigare bästa draget
            if (nextMove.value < move.value) {
                move.value = nextMove.value;
                move.action = action;
                beta = Math.min(beta, move.value);
            }
            // Återställ test-spelet
            trial = game.copy();
            // Tidigt stopp ifall det inte finns bättre möjliga drag
            if (move.value <= alpha) {
                return move;
            }
        }
        return move;
    }
}