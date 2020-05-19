struct HashTable<Key: Hashable, Value>: CustomDebugStringConvertible {
    var debugDescription: String {
        return bucket.description
    }
    
    typealias Element = (key: Key, value: Value)
    typealias Bucket = [Element?]
    
    private var bucket: Bucket
    private(set) var capacity: Int = 8
    private var capacityMin: Int = 8
    private let loadFactor: Float = 0.7
    private var count: Int = 0
    
    init() {
        bucket = Array<Element?>(repeating: nil, count: capacityMin)
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
    
    private func index(forKey key: Key, trialCount: Int) -> Int {
        return abs(key.hashValue + trialCount) % capacity
    }
    
    private mutating func upDownCapacity() {
        var temporaryBucket: Bucket = []
        
        if Float(count) / Float(capacity) > loadFactor {
            capacity *= 2
        } else if Float(count) / Float(capacity) <= loadFactor * 2 && capacity > capacityMin {
            capacity /= 2
        } else {
            return
        }
        
        temporaryBucket = Array<Element?>(repeating: nil, count: capacity)
        
        for element in bucket {
            guard let key = element?.key, let value = element?.value else { continue }
            var trialCount: Int = 0
            while true {
                let index = self.index(forKey: key, trialCount: trialCount)
                if key == temporaryBucket[index]?.key || temporaryBucket[index] == nil {
                    temporaryBucket[index] = Element(key, value)
                    break
                } else {
                    print(index)
                    trialCount += 1
                    continue
                }
            }
        }
        
        bucket = temporaryBucket
    }
    
    func getCapacity() -> Int {
        return capacity
    }
    
    func value(forKey key: Key) -> Value? {
        var trialCount = 0
        while true {
            let index = self.index(forKey: key, trialCount: trialCount)
            if key == bucket[index]?.key {
                return bucket[index]?.value
            } else if bucket[index] == nil  {
                return nil
            } else {
                trialCount += 1
                continue
            }
        }
    }
    
    mutating func updateValue(_ value: Value, forKey key: Key) -> Value? {
        var trialCount = 0
        while true {
            let index = self.index(forKey: key, trialCount: trialCount)
            if key == bucket[index]?.key {
                bucket[index] = Element(key, value)
                return bucket[index]?.value
            } else if bucket[index] == nil {
                bucket[index] = Element(key, value)
                count += 1
                upDownCapacity()
                return bucket[index]?.value
            } else {
                trialCount += 1
                continue
            }
        }
    }
    
    mutating func removeValue(forKey key: Key) -> Value? {
        var trialCount = 0
        while true {
            let index = self.index(forKey: key, trialCount: trialCount)
            if key == bucket[index]?.key {
                let oldValue = bucket[index]?.value
                bucket[index] = nil
                count -= 1
                upDownCapacity()
                return oldValue
            } else if bucket[index] == nil {
                return nil
            } else {
                trialCount += 1
                continue
            }
        }
    }
}

var hashTable = HashTable<String, String>()
print(hashTable)
hashTable["firstName"] = "Tri"
print(hashTable)
hashTable["firstName"] = "Bui"
hashTable["secondName"] = "Manh"
print(hashTable)

hashTable["lastName"] = "Tri"
print(hashTable)

hashTable["fullName"] = "Tri"

hashTable["fizName"] = "Tri"

hashTable["fatName"] = "Tri"

print("capacity: \(hashTable.capacity)")

print(hashTable)
hashTable["lastName"] = nil

print(hashTable)

hashTable["firstName"] = nil
print(hashTable)

print("capacity: \(hashTable.capacity)")
