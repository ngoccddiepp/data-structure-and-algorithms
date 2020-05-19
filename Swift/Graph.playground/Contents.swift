public enum EgdeType {
    case undirected
    case directed
}

public struct Vertex<T> {
    public let index: Int
    public let data: T
}

extension Vertex: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.index)
    }
    
    public static func ==(lsh: Vertex, rsh: Vertex) -> Bool {
        return lsh.index == rsh.index
    }
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(index): \(data)"
    }
}

public struct Edge<T> {
    public let source: Vertex<T>
    public let destination: Vertex<T>
    public let weight: Double?
}

public protocol Graph {
    associatedtype Element
    
    func createVertex(data: Element) -> Vertex<Element>
    func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func addUndirectedEdge(between source: Vertex<Element>, and destination: Vertex<Element>, weight: Double?)
    func add(_ edge: EgdeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func edges(from source: Vertex<Element>) -> [Edge<Element>]
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double?
}

public class AdjacencyList<T>: Graph {
    public var adjacencies: [Vertex<T>: [Edge<T>]] = [:]
    public init() {}
    
    public func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(index: adjacencies.count, data: data)
        adjacencies[vertex] = []
        return vertex
    }
    
    public func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencies[source]?.append(edge)
    }
    
    public func addUndirectedEdge(between source: Vertex<T>, and destination: Vertex<T>, weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
    public func add(_ edge: EgdeType, from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }
    
    public func edges(from source: Vertex<T>) -> [Edge<T>] {
        return adjacencies[source] ?? []
    }
    
    public func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Double? {
        return edges(from: source).first { $0.destination == destination }?.weight
    }
}

extension AdjacencyList: CustomStringConvertible {
    public var description: String {
        var result = ""
        for (vertex, edges) in adjacencies {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n")
        }
        return result
    }
}


public class AdjacencyMatrix<T>: Graph {
    public var vertices: [Vertex<T>] = []
    public var weights: [[Double?]] = []
    
    public init() {}
    
    public func createVertex(data: T) -> Vertex<T> {
        let vertex = Vertex(index: vertices.count, data: data)
        vertices.append(vertex)
        for i in 0 ..< weights.count {
            weights[i].append(nil)
        }
        let row = [Double?](repeating: nil, count: vertices.count)
        weights.append(row)
        return vertex
    }
    
    public func addDirectedEdge(from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        weights[source.index][destination.index] = weight
    }
    
    public func addUndirectedEdge(between source: Vertex<T>, and destination: Vertex<T>, weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
    
    public func add(_ edge: EgdeType, from source: Vertex<T>, to destination: Vertex<T>, weight: Double?) {
        switch edge {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(between: source, and: destination, weight: weight)
        }
    }
    
    public func edges(from source: Vertex<T>) -> [Edge<T>] {
        var edges: [Edge<T>] = []
        for column in 0 ..< weights.count {
            if let weight = weights[source.index][column] {
                edges.append(Edge(source: source, destination: vertices[column], weight: weight))
            }
        }
        return edges
    }
    
    public func weight(from source: Vertex<T>, to destination: Vertex<T>) -> Double? {
        return weights[source.index][destination.index]
    }
}

extension AdjacencyMatrix: CustomStringConvertible {
    public var description: String {
        let verticesDescription = vertices.map { "\($0)" }.joined(separator: "\n")
        var grid: [String] = []
        for i in 0 ..< weights.count {
            var row = ""
            for j in 0 ..< weights.count {
                if let value = weights[i][j] {
                    row += "\(value)\t"
                } else {
                    row += "$\t\t"
                }
            }
            grid.append(row)
        }
        let edgesDescription = grid.joined(separator: "\n")
        
        return "\(verticesDescription) \n\n\(edgesDescription)"
    }
}


let graph = AdjacencyMatrix<String>()

let singapore = graph.createVertex(data: "Singapore")
let tokyo = graph.createVertex(data: "Tokyo")
let hongkong = graph.createVertex(data: "Hong Kong")
let sanFrancisco = graph.createVertex(data: "SanFrancisco")
let washingtonDC = graph.createVertex(data: "Washington DC")

graph.add(.undirected, from: singapore, to: hongkong, weight: 300)
graph.add(.undirected, from: singapore, to: tokyo, weight: 500)
graph.add(.undirected, from: hongkong, to: tokyo, weight: 250)
graph.add(.undirected, from: tokyo, to: washingtonDC, weight: 300)
graph.add(.undirected, from: sanFrancisco, to: washingtonDC, weight: 337)
graph.add(.undirected, from: hongkong, to: sanFrancisco, weight: 600)

print(graph.description)


