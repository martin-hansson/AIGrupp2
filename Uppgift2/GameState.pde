import java.util.List;

class GameState {
    Node opponent;
    List<Node> moveSet;

    GameState(Node opponent, List<Node> moveSet) {
        this.opponent = opponent;
        this.moveSet = moveSet;
    }

}