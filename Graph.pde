import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.LinkedList;

class Graph {

    Map<Node, List<Edge>> graph = new HashMap<>();

    void add(Node node) {
        graph.put(node, new LinkedList<>());
        Node adjacent;
        if (node.col > 0) {
            adjacent = get(node.col - 1, node.row);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
        }
        
        if (node.col < 15) {
            adjacent = get(node.col + 1, node.row);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
        }

        if (node.row > 0) {
            adjacent = get(node.col, node.row - 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
        }

        if (node.row < 15) {
            adjacent = get(node.col, node.row + 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
        }

        println("Node added: " + node.col + ", " + node.row);
    }

    Node get(int col, int row) {
        return graph.keySet().stream().filter(node -> node.col == col && node.row == row).findFirst().orElse(null);
    }

    void connect(Node from, Node to, int weight) {
        graph.get(from).add(new Edge(from, to, weight));
    }

    boolean isConnected(Node from, Node to) {
        return graph.get(from).stream().anyMatch(edge -> edge.to == to);
    }

}