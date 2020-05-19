
// MARK: Singly Linked List

public class Node<Value> {
    public var value: Value
    public var next: Node?
    
    public init(value: Value, next: Node? = nil) {
        self.value = value
        self.next = next
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        guard let next = next else { return "\(value)"}
        return "\(value) -> " + String(describing: next) + " "
    }
}

public struct LinkedList<Value> {
    public var head: Node<Value>?
    public var tail: Node<Value>?
    
    public init() {}
    
    public var isEmpty: Bool {
        return head == nil
    }
    
    public func node(at index: Int) -> Node<Value>? {
        if index < 0 { return nil }
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil && currentIndex < index {
            currentNode = currentNode?.next
            currentIndex += 1
        }
        
        return currentNode
    }
    
    mutating public func push(_ value: Value) {
        copyNode()
        head = Node(value: value, next: head)
        if tail == nil {
            tail = head
        }
    }
    
    mutating public func append(_ value: Value) {
        copyNode()
        if isEmpty {
            push(value)
            return
        }
        
        tail!.next = Node(value: value)
        tail = tail!.next
    }
    
    @discardableResult
    mutating public func insert(_ value: Value, after node: Node<Value>) -> Node<Value> {
        copyNode()
        guard tail !== node else {
            append(value)
            return tail!
        }
        
        node.next = Node(value: value, next: node.next)
        return node.next!
    }
    
    @discardableResult
    mutating public func pop() -> Value? {
        copyNode()
        defer {
            head = head?.next
            if isEmpty {
                tail = nil
            }
        }
        return head?.value
    }
    
    @discardableResult
    mutating public func removeLast() -> Value? {
        copyNode()
        guard let head = head else { return nil }
        guard head.next != nil else { return pop() }
        
        var prev = head
        var current = head
        
        while let next = current.next {
            prev = current
            current = next
        }
        
        prev.next = nil
        tail = prev
        return current.value
    }
    
    @discardableResult
    mutating public func remove(after node: Node<Value>) -> Value? {
        copyNode()
        defer {
            if node.next === tail {
                tail = node
            }
            node.next = node.next?.next
        }
        return node.next?.value
    }
    
    mutating private func copyNode() {
        guard !isKnownUniquelyReferenced(&head) else { return }
        guard var oldNode = head else { return }
        head = Node(value: oldNode.value)
        var newNode = head
        
        while let nextOldNode = oldNode.next {
            newNode?.next = Node(value: nextOldNode.value)
            newNode = newNode?.next
            oldNode = nextOldNode
        }
        
        tail = newNode
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        guard let head = head else { return "Empty list" }
        return String(describing: head)
    }
}


extension LinkedList: Collection {
    public struct Index: Comparable {
        public var node: Node<Value>?
        static public func ==(lhs: Index, rhs: Index) -> Bool {
            switch (lhs.node, rhs.node) {
            case let (left?, right?):
                return left.next === right.next
            case (nil, nil):
                return true
            default:
                return false
            }
        }
        static public func <(lhs: Index, rhs: Index) -> Bool {
            guard lhs != rhs else {
                return false
            }
            let nodes = sequence(first: lhs.node) { $0?.next }
            return nodes.contains { $0 === rhs.node }
        }
    }
    
    // 1
    public var startIndex: Index {
        return Index(node: head)
    }
    // 2
    public var endIndex: Index {
        return Index(node: tail?.next)
    }
    // 3
    public func index(after i: Index) -> Index {
        return Index(node: i.node?.next)
    }
    // 4
    public subscript(position: Index) -> Value {
        return position.node!.value
    }
}

var list = LinkedList<Int>()
for i in 0...9 {
    list.append(i)
}
//print("List: \(list)")
//print("First element: \(list[list.startIndex])")
//print("Array containing first 3 elements: \(Array(list.prefix(3)))")
//print("Array containing last 3 elements: \(Array(list.suffix(3)))")
//let sum = list.reduce(0, +)
//print("Sum of all values: \(sum)")

print("List1 uniquely referenced: \(isKnownUniquelyReferenced(&list.head))")
var list2 = list
print("List1 uniquely referenced: \(isKnownUniquelyReferenced(&list.head))")


/// Doubly Linked List - has previous and next Node
