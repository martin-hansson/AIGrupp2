// Grupp 02:
// Alexandra Jansson alja5888,
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

import java.util.List;

class GameState {
    List<Node> moveSet;
    Node opponent;
    Game game;

    GameState(List<Node> moveSet, Node opponent, Game game) {
        this.moveSet = moveSet;
        this.opponent = opponent;
        this.game = game.copy();
    }

}