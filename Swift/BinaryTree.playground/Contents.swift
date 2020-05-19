class Node<Element> {
    var value: Element
    var left: Node?
    var right: Node?
    
    init(_ value: Element) {
        self.value = value
    }
}

class BTree {
    func preOrderWith<Element>(root: Node<Element>?) {
        guard let root = root else { return }
        print(root.value)
        preOrderWith(root: root.left)
        preOrderWith(root: root.right)
    }
    
    func inOrderWith<Element>(root: Node<Element>?) {
        guard let root = root else { return }
        inOrderWith(root: root.left)
        print(root.value)
        inOrderWith(root: root.right)
    }
    
    func postOrderWith<Element>(root: Node<Element>?) {
        guard let root = root else { return }
        postOrderWith(root: root.left)
        postOrderWith(root: root.right)
        print(root.value)
    }
    
    func levelOrderWith<Element>(root: Node<Element>) {
        var nodes: [Node<Element>] = [root]
        
        while true {
            var nodePrepare: [Node<Element>] = []
            for node in nodes {
                print(node.value)
                if let left = node.left {
                    nodePrepare.append(left)
                }
                if let right = node.right {
                    nodePrepare.append(right)
                }
            }
            
            nodes = nodePrepare
            if nodes.isEmpty {
                return
            }
        }
        
    }
}

//            1
//           / \
//          2   3
//         / \
//        4   5

let node1: Node = Node(1)
let node2: Node = Node(2)
let node3: Node = Node(3)
let node4: Node = Node(4)
let node5: Node = Node(5)

node1.left = node2
node1.right = node3
node2.left = node4
node2.right = node5

let binaryTree = BTree()
print("============>>> Pre-Order")
binaryTree.preOrderWith(root: node1)
print("============>>> In-Order")
binaryTree.inOrderWith(root: node1)
print("============>>> Post-Order")
binaryTree.postOrderWith(root: node1)
print("============>>> level-Order")
binaryTree.levelOrderWith(root: node1)
