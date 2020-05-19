struct HashTable<Key: Hashable, Value> {
    private typealias Element = (key: Key, value: Value)
    private typealias Bucket = [Element]
    
    private var buckets: [Bucket]
    private(set) var count = 0
    private var capacityMin = 0
    private var capacity = 0
    private let loadFactor: Float = 0.7
    
    var isEmpty: Bool {
        return count == 0
    }
    
    init(capacity: Int) {
        buckets = Array<Bucket>(repeating: [], count: capacity)
        capacityMin = capacity
        self.capacity = capacity
    }
    
    subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        
        set {
            if let value = newValue {
                updateValue(value, forKey: key)
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
    func getCapacity() -> Int {
        return capacity
    }
    
    private func index(forKey key: Key) -> Int {
        return abs(key.hashValue) % capacity
    }
    
    private mutating func upDownCapacity() {
        var temporaryBuckets: [Bucket] = []
        
        if Float(count) / Float(capacity) > loadFactor {
            capacity *= 2
            temporaryBuckets = Array<Bucket>(repeating: [], count: capacity)
        } else if Float(count) / Float(capacity) <= loadFactor * 2 && capacity > capacityMin {
            capacity /= 2
            temporaryBuckets = Array<Bucket>(repeating: [], count: capacity)
        } else {
            return
        }
        
        for bucket in buckets {
            for element in bucket {
                let index = self.index(forKey: element.key)
                temporaryBuckets[index].append(element)
            }
        }
        buckets = temporaryBuckets
    }
    
    func value(forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        for element in buckets[index] {
            if element.key == key {
                return element.value
            }
        }
        return nil
    }
    
    mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        for (i, element) in buckets[index].enumerated() {
            if element.key == key {
                let oldValue = element.value
                buckets[index][i].value = value
                return oldValue
            }
        }
        
        let element: Element = (key, value)
        buckets[index].append(element)
        count += 1
        
        upDownCapacity()
        
        return nil
    }
    
    mutating func removeValue(forKey key: Key) -> Value? {
        let index = self.index(forKey: key)
        
        var value: Value?
        
        for (i, element) in buckets[index].enumerated() {
            if element.key == key {
                buckets[index].remove(at: i)
                count -= 1
                value = element.value
            }
        }
        
        upDownCapacity()
        
        return value
    }
}

var hashTable = HashTable<String, String>(capacity: 2)
hashTable["firstName"] = "Tri"
hashTable["firstName"] = "Bui"
hashTable["secondName"] = "Manh"

hashTable["lastName"] = "Tri"

hashTable["lastName"] = nil

hashTable["firstName"] = nil
print(hashTable.self)
