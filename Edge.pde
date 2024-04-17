// Grupp 02:
// Alexandra Jansson alja5888,
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

class Edge {
    GridNode from;
    GridNode to;
    int weight;
    boolean isAStarPath;
    boolean isBreadthFirstPath;

    Edge(GridNode from, GridNode to, int weight) {
        this.from = from;
        this.to = to;
        this.weight = weight;
        this.isAStarPath = false;
        this.isBreadthFirstPath = false;
    }

    @Override
    public String toString() {
        return "Edge{" +
                "from=" + from +
                ", to=" + to +
                "}";
    }

}