// Grupp 02:
// Alexandra Jansson alja5888,
// Tyr Hullmann tyhu6316,
// Martin Hansson maha6445

// Klass som representerar en kant i en graf
class Edge {
    // Referenser till noderna som kanten går mellan
    GridNode from;
    GridNode to;

    // Vikten på kanten
    int weight;

    // Huruvida kanten är en del av en A* eller BFS-sökväg
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