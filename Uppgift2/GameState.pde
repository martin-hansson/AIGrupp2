// Grupp 02:
// Alexandra Jansson alja5888,
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

import java.util.List;

// Klass som representerar ett viss tillstånd efter ett drag
class GameState {
    // En lista med rörelser som ledde till detta tillståndet
    List<Node> moveSet;
    // Motståndarens nuvarande tillstånd
    Node opponent;
    // Spelets tillstånd
    Game game;

    GameState(List<Node> moveSet, Node opponent, Game game) {
        this.moveSet = moveSet;
        this.opponent = opponent;
        this.game = game.copy();
    }

}