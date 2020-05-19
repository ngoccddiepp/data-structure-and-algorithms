struct Heap<Element: Comparable> {
    let sort: (Element, Element) -> Bool
    var elements: [Element] = []
    
    init(sort: @escaping (Element, Element) -> Bool, elements: [Element]) {
        self.sort = sort
        self.elements = elements
        
        if !self.elements.isEmpty {
            for i in stride(from: self.elements.count / 2 - 1, through: 0, by: -1) {
                siftDown(from: i)
            }
        }
    }
    
    var count: Int {
        return elements.count
    }
    
    func leftChildIndex(ofParentAt index: Int) -> Int {
        return (index + 1) * 2
    }
    
    func rightChildIndex(ofParentAt index: Int) -> Int {
        return (index + 2) * 2
    }
    
    func parentIndex(ofChildAt index: Int) -> Int {
        return (index - 1) / 2
    }
    
    func index(of element: Element, startingAt i: Int) -> Int? {
        if i >= count {
            return nil
        }
        
        if sort(element, elements[i]) {
            return nil
        }
        
        if element == elements[i] {
            return i
        }
        
        if let j = index(of: element, startingAt: leftChildIndex(ofParentAt: i)) {
            return j
        }
        
        if let j = index(of: element, startingAt: rightChildIndex(ofParentAt: i)) {
            return j
        }
        
        return nil
    }
    
    mutating func siftUp(from index: Int) {
        var child = index
        var parent = parentIndex(ofChildAt: child)
        
        while child > 0 && sort(elements[child], elements[parent]) {
            elements.swapAt(child, parent)
            child = parent
            parent = parentIndex(ofChildAt: child)
        }
    }
    
    mutating func siftDown(from index: Int) {
        var parent = index
        
        while true {
            let left = leftChildIndex(ofParentAt: parent)
            let right = rightChildIndex(ofParentAt: parent)
            var candiate = parent
            
            if left < count && sort(elements[left], elements[candiate]) {
                candiate = left
            }
            if right < count && sort(elements[right], elements[candiate]) {
                candiate = left
            }
            if candiate == parent {
                return
            }
            elements.swapAt(parent, candiate)
            parent = candiate
        }
    }
    
    mutating func insert(element: Element) {
        elements.append(element)
        siftUp(from: count - 1)
    }
    
    mutating func remove() -> Element? {
        guard elements.count > 0 else { return nil }
        elements.swapAt(0, count - 1)
        defer {
            siftDown(from: 0)
        }
        return elements.removeLast()
    }
    
    mutating func remove(at index: Int) -> Element? {
        guard index < elements.count, index >= 0 else {
            return nil
        }
        
        if index == elements.count - 1 {
            return elements.removeLast()
        } else {
            elements.swapAt(index, count - 1)
            defer {
                siftDown(from: index)
                siftUp(from: index)
            }
            return elements.removeLast()
        }
    }
}

var heap = Heap(sort: >, elements: [1,12,3,4,1,6,8,7])
heap.remove()
heap.remove(at: -1)
