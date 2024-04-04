import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.LinkedList;
import java.util.PriorityQueue;
import java.util.Set;
import java.util.HashSet;

class Graph {

    Map<Node, List<Edge>> graph = new HashMap<>();

    void add(Node node) {
        graph.put(node, new LinkedList<>());
        Node adjacent;
        if (node.col > 0) {
            adjacent = get(node.col - 1, node.row);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 2);
        }
        
        if (node.col < 15) {
            adjacent = get(node.col + 1, node.row);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 2);
        }

        if (node.row > 0) {
            adjacent = get(node.col, node.row - 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 2);
        }

        if (node.row < 15) {
            adjacent = get(node.col, node.row + 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 2);
        }

        if (node.col > 0 && node.row > 0) {
            adjacent = get(node.col - 1, node.row - 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
        }

        if (node.col < 15 && node.row < 15) {
            adjacent = get(node.col + 1, node.row + 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
        }

        if (node.col > 0 && node.row < 15) {
            adjacent = get(node.col - 1, node.row + 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
        }

        if (node.col < 15 && node.row > 0) {
            adjacent = get(node.col + 1, node.row - 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
        }

        println("Node added: " + node.col + ", " + node.row);
    }

    List<Edge> getEdges(Node node) {
        return graph.get(node);
    }

    Node get(int col, int row) {
        return graph.keySet().stream().filter(node -> node.col == col && node.row == row).findFirst().orElse(null);
    }

    void connect(Node from, Node to, int weight) {
        if (from != null && to != null) 
            graph.get(from).add(new Edge(from, to, weight));
        else 
            return;
    }

    boolean isConnected(Node from, Node to) {
        return graph.get(from).stream().anyMatch(edge -> edge.to == to);
    }

    List<Node> breadthFirstSearch(Node start, Node goal) {
        LinkedList<SearchNode> frontier = new LinkedList<>();
        Set<Node> visited = new HashSet<>();
        frontier.addLast(new SearchNode(new Edge(null, start, 0), null));
        int frontierCounter = 0;

        while (!frontier.isEmpty()) {
            SearchNode current = frontier.removeFirst();
            frontierCounter++;

            Node node = current.edge.to;
            if (node == goal) {
                println("BF Actions: " + frontierCounter);
                return reconstructPath(current);
            }
                

            visited.add(node);
            List<Edge> adjacent = getEdges(node);
            for (Edge edge : adjacent) {
                Node next = edge.to;
                if (next != null && !visited.contains(next)) {
                    frontier.addLast(new SearchNode(edge, current));
                }
            }
        }

        return null;
    }

    List<Node> aStarSearch(Node start, Node goal) {
        PriorityQueue<AStarNode> frontier = new PriorityQueue<>();
        Set<Node> visited = new HashSet<>();
        AStarNode current = new AStarNode(0, 0, new Edge(null, start, 0), null);
        frontier.add(current);
        int frontierCounter = 0;

        while (!frontier.isEmpty()) {
            current = frontier.poll();
            frontierCounter++;
            Node node = current.edge.to;
            if (node == goal) {
                println("A* Actions: " + frontierCounter);
                return reconstructPath(current);
            }
                
            visited.add(node);
            List<Edge> adjacent = getEdges(node);
            for (Edge edge : adjacent) {
                Node next = edge.to;
                if (next != null && !visited.contains(next)) {
                    int g = edge.weight;
                    int h = heuristic(next, goal);
                    int f = g + h;
                    AStarNode successor = new AStarNode(f, current.costSoFar, edge, current);
                    frontier.add(successor);
                }
            }
        }

        return null;
    }

    int heuristic(Node node, Node goal) {
        PVector distance = PVector.add(node.position, goal.position);
        return (int) distance.mag();
    }

    List<Node> reconstructPath(SearchNode node) {
        List<Node> path = new LinkedList<>();
        while (node != null) {
            if (node instanceof AStarNode)
                node.edge.isAStarPath = true;
            else 
                node.edge.isBreadthFirstPath = true;
            
            path.add(node.edge.to);
            node = node.path;
        }
        return path;
    }

    class SearchNode {
        Edge edge;
        SearchNode path;

        SearchNode(Edge edge, SearchNode path) {
            this.edge = edge;
            this.path = path;
        }
    }

    class AStarNode extends SearchNode implements Comparable<AStarNode> {
        int priorityCost;
        int costSoFar;

        AStarNode(int priorityCost, int costSoFar, Edge edge, SearchNode path) {
            super(edge, path);
            this.priorityCost = priorityCost;
            this.costSoFar = costSoFar;
        }

        @Override
        public int compareTo(AStarNode other) {
            return Integer.compare(priorityCost, other.priorityCost);
        }

    }

}