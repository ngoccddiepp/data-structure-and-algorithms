class Node<T: Comparable> {
    var parent: Node?
    var left: Node?
    var right: Node?
    
    var value: T
    
    init(value: T) {
        self.value = value
    }
    
    var isLeftChild: Bool {
      return parent?.left === self
    }

    var isRightChild: Bool {
      return parent?.right === self
    }
    
    func insert(_ value: T) {
        if value < self.value {
            if let left = left {
                left.insert(value)
            } else {
                left = Node(value: value)
                left?.parent = self
            }
        } else if value > self.value {
            if let right = right {
                right.insert(value)
            } else {
                right = Node(value: value)
                right?.parent = self
            }
        }
    }
    
    func search(value: T) -> Node? {
        if value < self.value {
            return left?.search(value: value)
        } else if value > self.value {
            return right?.search(value: value)
        } else {
            return self
        }
    }
    
    func reconnectParentTo(node: Node?) {
        if let parent = parent {
            if isLeftChild {
                parent.left = node
            } else {
                parent.right = node
            }
        }
        node?.parent = parent
    }
    
    func minimum() -> Node {
        var node = self
        while let next = node.left {
            node = next
        }
        return node
    }
    
    func maximum() -> Node {
        var node = self
        while let next = node.right {
            node = next
        }
        return node
    }
    
    func remove() -> Node? {
        let replacement: Node?

        if let right = right {
            replacement = right.minimum()
        } else if let left = left {
            replacement = left.maximum()
        } else {
            replacement = nil
        }
        
        replacement?.remove()
        
        replacement?.right = right
        replacement?.left = left
        right?.parent = replacement
        left?.parent = replacement
        reconnectParentTo(node: replacement)
        
        parent = nil
        left = nil
        right = nil
        
        return replacement
    }
}

extension Node: CustomStringConvertible {
    public var description: String {
        var s = ""
        if let left = left {
            s += "(\(left.description)) <- "
        }
        s += "\(value)"
        if let right = right {
            s += " -> (\(right.description))"
        }
        return s
    }
}

/// Example:

let tree = Node<Int>(value: 7)
tree.insert(2)
tree.insert(5)
tree.insert(10)
tree.insert(9)
tree.insert(1)

print(tree)

tree.search(value: 9)
tree.search(value: 10)?.remove()

print(tree)
