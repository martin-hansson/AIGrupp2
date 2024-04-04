class Edge {
    Node from;
    Node to;
    int weight;
    boolean isAStarPath;
    boolean isBreadthFirstPath;

    Edge(Node from, Node to, int weight) {
        this.from = from;
        this.to = to;
        this.weight = weight;
        this.isAStarPath = false;
        this.isBreadthFirstPath = false;
    }

}