import java.util.Map;
import java.util.HashMap;
import java.util.List;
import java.util.LinkedList;
import java.util.PriorityQueue;
import java.util.Set;
import java.util.HashSet;

class GridGraph {

    Map<GridNode, List<Edge>> graph = new HashMap<>();

    void add(GridNode node) {
        graph.put(node, new LinkedList<>());
        GridNode adjacent;
        if (node.col > 0) {
            adjacent = get(node.col - 1, node.row);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
            if (!isConnected(adjacent, node))
                connect(adjacent, node, 1);
        }
        
        if (node.col < 15) {
            adjacent = get(node.col + 1, node.row);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
            if (!isConnected(adjacent, node))
                connect(adjacent, node, 1);
        }

        if (node.row > 0) {
            adjacent = get(node.col, node.row - 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
            if (!isConnected(adjacent, node))
                connect(adjacent, node, 1);
        }

        if (node.row < 15) {
            adjacent = get(node.col, node.row + 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
            if (!isConnected(adjacent, node))
                connect(adjacent, node, 1);
        }

        if (node.col > 0 && node.row > 0) {
            adjacent = get(node.col - 1, node.row - 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
            if (!isConnected(adjacent, node))
                connect(adjacent, node, 1);
        }

        if (node.col < 15 && node.row < 15) {
            adjacent = get(node.col + 1, node.row + 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
            if (!isConnected(adjacent, node))
                connect(adjacent, node, 1);
        }

        if (node.col > 0 && node.row < 15) {
            adjacent = get(node.col - 1, node.row + 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
            if (!isConnected(adjacent, node))
                connect(adjacent, node, 1);
        }

        if (node.col < 15 && node.row > 0) {
            adjacent = get(node.col + 1, node.row - 1);
            if (!isConnected(node, adjacent))
                connect(node, adjacent, 1);
            if (!isConnected(adjacent, node))
                connect(adjacent, node, 1);
        }

        println("Node added: " + node.col + ", " + node.row);
    }

    List<Edge> getEdges(GridNode node) {
        return graph.get(node);
    }

    int getNumNodes() {
        return graph.size();
    }

    int getNumEdges() {
        return graph.values().stream().mapToInt(List::size).sum();
    }

    GridNode get(int col, int row) {
        return graph.keySet().stream().filter(node -> node.col == col && node.row == row).findFirst().orElse(null);
    }

    void connect(GridNode from, GridNode to, int weight) {
        if (from != null && to != null) 
            graph.get(from).add(new Edge(from, to, weight));
    }

    boolean isConnected(GridNode from, GridNode to) {
        if (from == null || to == null)
            return false;

        return graph.get(from).stream().anyMatch(edge -> edge.to == to && edge.from == from);
    }

    List<GridNode> breadthFirstSearch(GridNode start, GridNode goal) {
        LinkedList<SearchNode> frontier = new LinkedList<>();
        Set<GridNode> visited = new HashSet<>();
        frontier.addLast(new SearchNode(new Edge(null, start, 0), null));
        int frontierCounter = 0;

        while (!frontier.isEmpty()) {
            SearchNode current = frontier.removeFirst();

            GridNode node = current.edge.to;
            if (node == goal) {
                println("BFS Actions: " + frontierCounter);
                return reconstructPath(current);
            }
            frontierCounter++;
                
            
            List<Edge> adjacent = getEdges(node);
            if (adjacent != null) {
                for (Edge edge : adjacent) {
                    GridNode next = edge.to;
                    if (!visited.contains(next)) {
                        frontier.addLast(new SearchNode(edge, current));
                        visited.add(next);
                    }
                }
            }
        }

        return null;
    }

    List<GridNode> aStarSearch(GridNode start, GridNode goal) {
        PriorityQueue<AStarNode> frontier = new PriorityQueue<>();
        Set<GridNode> visited = new HashSet<>();
        AStarNode current = new AStarNode(0, 0, new Edge(null, start, 0), null);
        frontier.add(current);
        int frontierCounter = 0;

        while (!frontier.isEmpty()) {
            current = frontier.poll();

            GridNode node = current.edge.to;
            if (node == goal) {
                println("A* Actions: " + frontierCounter);
                return reconstructPath(current);
            }
            frontierCounter++;
                
            List<Edge> adjacent = getEdges(node);
            if (adjacent != null) {
                for (Edge edge : adjacent) {
                    GridNode next = edge.to;
                    if (!visited.contains(next)) {
                        double g = edge.weight;
                        double h = heuristic(next, goal);
                        double f = g + h;
                        AStarNode successor = new AStarNode(f, current.costSoFar, edge, current);
                        frontier.add(successor);
                        visited.add(next);
                    }
                }
            }
        }

        return null;
    }

    double heuristic(GridNode node, GridNode goal) {
        return Math.sqrt(Math.pow(node.col - goal.col, 2) + Math.pow(node.row - goal.row, 2));
    }

    List<GridNode> reconstructPath(SearchNode node) {
        List<GridNode> path = new LinkedList<>();
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
        double priorityCost;
        double costSoFar;

        AStarNode(double priorityCost, double costSoFar, Edge edge, SearchNode path) {
            super(edge, path);
            this.priorityCost = priorityCost;
            this.costSoFar = costSoFar;
        }

        @Override
        public int compareTo(AStarNode other) {
            return Double.compare(priorityCost, other.priorityCost);
        }

    }

}