import Foundation

public extension NSHashTable {
    var first: AnyObject? {
        return self.allObjects.first
    }

    var isEmpty: Bool {
        var isEmpty: Bool?
        self.synced {
            isEmpty = self.allObjects.isEmpty
        }
        return isEmpty ?? false
    }

    func add(#object: AnyObject) {
        self.synced {
            self.addObject(object)
        }
    }

    func add(#objects: [AnyObject]) {
        objects.each { self.add(object: $0) }
    }

    func each(block: ((AnyObject)->(Void))) {
        self.synced {
            self.allObjects.each(block)
        }
    }
    
    func sorted(sortBlock: ((AnyObject, AnyObject)->(Bool))) -> [AnyObject] {
        var sortedObjects: [AnyObject] = []
        self.synced {
            sortedObjects = self.allObjects.sorted(sortBlock)
        }
        return sortedObjects
    }

    func remove(#object: AnyObject) {
        self.synced {
            self.removeObject(object)
        }
    }

    func removeAll() {
        self.synced {
            self.removeAllObjects()
        }
    }
}
