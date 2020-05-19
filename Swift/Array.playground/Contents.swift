struct ArrayRewrite<Element: Comparable>: CustomDebugStringConvertible {
    
    var debugDescription: String {
        return array.description
    }
    
    private var capacity: Int
    private var defaultValue: Element
    private var array: [Element]
    private (set) var count: Int = 0
    private (set) var isEmpty: Bool
    
    init(capacity: Int, type: Element) {
        assert(capacity > 0)
        self.capacity = capacity
        self.defaultValue = type
        self.array = [Element](repeating: type, count: capacity)
        self.isEmpty = false
    }
    
    mutating func itemAt(index: Int) -> Element {
        assert(index >= 0)
        assert(index < count)
        return array[index]
    }
    
    mutating func append(_ item: Element) {
        upSize()
        array[count] = item
        count += 1
    }
    
    mutating func insertItem(_ item: Element, at index: Int) {
        assert(index >= 0)
        upSize()
        for i in stride(from: count - 1, through: index, by: -1) {
            array[i + 1] = array[i]
        }
        array[index] = item
        count += 1
    }
    
    mutating func prepend(_ item: Element) {
        insertItem(item, at: 0)
    }
    
    mutating func removeAt(index: Int) {
        assert(index >= 0)
        assert(index < count)
        for i in index ..< count {
            array[i] = array[i + 1]
        }
        count -= 1
        downSize()
    }
    
    mutating func removeLast() -> Element {
        assert(count > 0)
        let result = array[count - 1]
        array[count - 1] = defaultValue
        count -= 1
        downSize()
        return result
    }
    
    mutating func find(_ item: Element) -> Int {
        for (index, subArray) in array.enumerated() {
            if subArray == item {
                return index
            }
        }
        return -1
    }
    
    mutating func remove(_ item: Element) {
        removeAt(index: find(item))
    }
    
    private mutating func upSize() {
        isEmpty = false
        print("count: \(count), capacity: \(capacity)")
        if count == capacity {
            capacity *= 2
            var arrayReplacing = [Element](repeating: defaultValue, count: capacity)
            for (index, item) in array.enumerated() {
                arrayReplacing[index] = item
            }
            array = arrayReplacing
        }
    }
    
    private mutating func downSize() {
        if count == 0 {
            isEmpty = true
        }
        print("count: \(count), capacity: \(capacity)")
        if count <= capacity / 4 {
            capacity /= 2
            var arrayReplacing = [Element](repeating: defaultValue, count: capacity)
            for index in 0 ..< arrayReplacing.count{
                arrayReplacing[index] = array[index]
            }
            array = arrayReplacing
        }
    }
    
}

var arrayString = ArrayRewrite<String>(capacity: 10, type: "")
print(arrayString)
arrayString.insertItem("xxx", at: 0)
arrayString.insertItem("yyy", at: 0)
arrayString.insertItem("zzz", at: 0)
arrayString.insertItem("aaa", at: 0)
arrayString.insertItem("bbb", at: 0)
arrayString.insertItem("ccc", at: 0)
arrayString.insertItem("ddd", at: 0)
arrayString.insertItem("eee", at: 0)
arrayString.insertItem("fff", at: 0)
arrayString.insertItem("ggg", at: 0)
print(arrayString)
arrayString.insertItem("hhh", at: 0)
print(arrayString)

arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
arrayString.removeLast()
print(arrayString)
print(arrayString.isEmpty)
arrayString.prepend("ggg")
print(arrayString)
arrayString.prepend("iii")
arrayString.append("kkk")
arrayString.append("nnn")
arrayString.append("mmm")
arrayString.append("lll")
print(arrayString)
