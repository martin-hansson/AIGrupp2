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