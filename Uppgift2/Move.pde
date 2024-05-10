// Grupp 02:
// Alexandra Jansson alja5888,
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

// Klass som representerar ett drag
class Move {
    // Värdet av draget
    int value;
    // Handlingen som genomförs
    Action action;

    Move(int value, Action action) {
        this.value = value;
        this.action = action;
    }
}
