import Foundation

public extension Dictionary {
    init(withoutOptionalValues initial: Dictionary<Key, Value?>) {
        self = [Key: Value]()
        for pair in initial {
            if pair.1 != nil {
                self[pair.0] = pair.1!
            }
        }
    }
    
    init(pairs: [(Key, Value)]) {
        self = [Key: Value]()
        pairs.forEach { (k, v) -> () in
            self[k] = v
        }
    }
    
    init(initial: Dictionary<Key, Value>, toMerge: Dictionary<Key, Value>) {
        self = Dictionary<Key, Value>()
        
        for pair in initial {
            self[pair.0] = pair.1
        }
        
        for pair in toMerge {
            self[pair.0] = pair.1
        }
    }
}
