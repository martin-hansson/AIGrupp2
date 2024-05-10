// Grupp 02:
// Alexandra Jansson alja5888,
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

import java.time.LocalDateTime;

// Klass som genomför en Minimax-sökning
class MinimaxSearch {
    int LIMIT = 7; // Gränsen för hur djupt sökningen får gå

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

    // Söker efter bästa draget
    Action search(Node start) {
        println("Minimax start time: " + LocalDateTime.now().toString());
        Move move = maxValue(game, start, depth);
        println("Minimax end time: " + LocalDateTime.now().toString());
        return move.action;
    }

    // Anropas vid MAX-nivåer i trädet
    Move maxValue(Game game, Node current, int depth) {
        // Om gränsvärdet är nått returneras uppskattat värde av spelet
        if (depth == LIMIT) {
            return new Move(game.utility(minTeam), null);
        }

        // Skapar ett tentativt drag och spel för att testa drag
        Move move = new Move(Integer.MIN_VALUE, null);
        Game trial = game.copy();

        // För varje möjligt drag
        for (Action action : game.getActions(current)) {
            // Kör draget och och uppdaterar spelet
            GameState state = trial.result(current, action, maxTeam);
            // Anropa MIN-nivå för att hitta bästa draget för motståndaren
            Move nextMove = minValue(state.game, state.opponent, depth + 1);
            // Om det hittade draget är bättre än det tidigare bästa draget
            if (nextMove.value > move.value) {
                move.value = nextMove.value;
                move.action = action;
            }
            // Återställ test-spelet
            trial = game.copy();
        }

        return move;
    }

    // Anropas vid MIN-nivåer i trädet
    Move minValue(Game game, Node current, int depth) {
        // Om gränsvärdet är nått returneras uppskattat värde av spelet
        if (depth == LIMIT) {
            return new Move(game.utility(maxTeam), null);
        }

        // Skapar ett tentativt drag och spel för att testa drag
        Move move = new Move(Integer.MAX_VALUE, null);
        Game trial = game.copy();

        // För varje möjligt drag
        for (Action action : game.getActions(current)) {
            // Kör draget och och uppdaterar spelet
            GameState state = trial.result(current, action, minTeam);
            // Anropa MAX-nivå för att hitta bästa draget för motståndaren
            Move nextMove = maxValue(state.game, state.opponent, depth + 1);
            // Om det hittade draget är bättre än det tidigare bästa draget
            if (nextMove.value < move.value) {
                move.value = nextMove.value;
                move.action = action;
            }
            // Återställ test-spelet
            trial = game.copy();
        }
        return move;
    }
}