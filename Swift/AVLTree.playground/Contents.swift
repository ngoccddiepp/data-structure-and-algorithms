class Node<T: Comparable> {
    var value: T
    var parent: Node?
    var left: Node?
    var right: Node?
    var height: Int = 1
    
    init(_ value: T, height: Int, parent: Node?, left: Node?, right: Node?) {
        self.value = value
        self.height = height
        self.left = left
        self.right = right
        self.parent = parent
        
        self.left?.parent = self
        self.right?.parent = self
    }
    
    convenience init(_ value: T) {
        self.init(value, height: 1, parent: nil, left: nil, right: nil)
    }
    
    var isLeaf: Bool {
        return self.left == nil && self.right == nil
    }
    
    var isLeftChild: Bool {
        return parent?.left === self
    }
    
    var isRightChild: Bool {
        return parent?.right === self
    }
    
    func minimum() -> Node {
        return left?.minimum() ?? self
    }
    
    func maximum() -> Node {
        return right?.maximum() ?? self
    }
}

extension Node: CustomStringConvertible {
    var description: String {
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

/// AVL Tree

class AVLTree<T: Comparable> {
    private(set) var root: Node<T>?
    
    init() { }
    
    private func updateHeightUpwards(node: Node<T>?) {
        if let node = node {
            let lHeight = node.left?.height ?? 0
            let rHeight = node.right?.height ?? 0
            node.height = max(lHeight, rHeight) + 1
            updateHeightUpwards(node: node.parent)
        }
    }
    
    private func heightFactor(node: Node<T>?) -> Int {
        let lHeight = node?.left?.height ?? 0
        let rHeight = node?.right?.height ?? 0
        return lHeight - rHeight
    }
    
    /*
     Search function
     */
    func search(_ value: T) -> Node<T>? {
        return search(value, with: root)
    }
    
    private func search(_ value: T, with node: Node<T>?) -> Node<T>? {
        guard let node = node else { return nil }
        if value == node.value {
            return node
        } else if value < node.value {
            return search(value, with: node.left)
        } else {
            return search(value, with: node.right)
        }
    }
    
    /*
     Insert function
     */
    func insert(_ value: T) {
        guard let root = root else {
            self.root = Node(value)
            return
        }
        insert(value, with: root)
    }
    
    private func insert(_ value: T, with node: Node<T>) {
        if value == node.value {
            return
        } else if value < node.value {
            guard let left = node.left else {
                let subNode = Node(value)
                node.left = subNode
                subNode.parent = node
                updateHeightUpwards(node: subNode)
                balance(node.parent)
                return
            }
            insert(value, with: left)
        } else {
            guard let right = node.right else {
                let subNode = Node(value)
                node.right = subNode
                subNode.parent = node
                updateHeightUpwards(node: subNode)
                balance(node.parent)
                return
            }
            insert(value, with: right)
        }
        return
    }
    
    /*
     Delete function
     */
    func delete(_ value: T) -> Node<T>? {
        guard let node = search(value) else { return nil }
        delete(node: node)
        return node
    }
    
    private func delete(node: Node<T>) {
        if node.isLeaf {
            guard let parent = node.parent else {
                root = nil
                return
            }
            
            if node.isLeftChild {
                parent.left = nil
            } else if node.isRightChild {
                parent.right = nil
            }
            updateHeightUpwards(node: parent)
//            balance(parent)
        } else {
            if let replacement = node.left?.maximum() {
                node.value = replacement.value
                delete(node: replacement)
            } else if let replacement = node.right?.minimum() {
                node.value = replacement.value
                delete(node: replacement)
            }
        }
    }
}

private extension AVLTree {
    func leftRotate(_ node: Node<T>) -> Node<T> {
        let parent = node.parent
        let pivot = node.right!
        pivot.parent = parent
        if node.isLeftChild {
            parent?.left = pivot
        } else if node.isRightChild {
            parent?.right = pivot
        } else {
            root = pivot
        }
        
        node.right = pivot.left
        pivot.left?.parent = node
        pivot.left = node
        node.parent = pivot
        
        updateHeightUpwards(node: node)
        return pivot
    }
    
    func rightRotate(_ node: Node<T>) -> Node<T> {
        let parent = node.parent
        let pivot = node.left!
        pivot.parent = parent
        if node.isLeftChild {
            parent?.left = pivot
        } else if node.isRightChild {
            parent?.right = pivot
        } else {
            root = pivot
        }
        
        node.left = pivot.right
        pivot.right?.parent = node
        pivot.right = node
        node.parent = pivot
        
        updateHeightUpwards(node: node)
        return pivot
    }
    
    func rightLeftRotate(_ node: Node<T>) -> Node<T> {
        guard let right = node.right else { return node }
        node.right = rightRotate(right)
        return leftRotate(node)
    }
    
    func leftRightRotate(_ node: Node<T>) -> Node<T> {
        guard let left = node.left else { return node }
        node.left = leftRotate(left)
        return rightRotate(node)
    }
    
    func balance(_ node: Node<T>?) {
        guard let node = node else { return }
        switch heightFactor(node: node) {
        case 2:
            if let leftChild = node.left, heightFactor(node: leftChild) == -1 {
                leftRightRotate(node)
            } else {
                rightRotate(node)
            }
        case -2:
            if let rightChild = node.right, heightFactor(node: rightChild) == 1 {
                rightLeftRotate(node)
            } else {
                leftRotate(node)
            }
        default:
            balance(node.parent)
        }
    }
}

/// Example:

let tree = AVLTree<Int>()

tree.insert(5)
print(tree.root?.description)

tree.insert(10)
print(tree.root?.description)

tree.insert(14)
print(tree.root?.description)

tree.insert(2)
print(tree.root?.description)

tree.insert(3)
print(tree.root?.description)

tree.insert(4)
print(tree.root?.description)

let node = tree.search(4)?.parent
print(node?.value)

print("============================== \n")

tree.delete(5)
print(tree.root?.description)
tree.delete(2)
print(tree.root?.description)
tree.delete(1)
print(tree.root?.description)
tree.delete(4)
print(tree.root?.description)
tree.delete(3)
print(tree.root?.description)
tree.delete(10)
print(tree.root?.description)
