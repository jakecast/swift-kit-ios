import Foundation

public extension NSHashTable {
    public var first: AnyObject? {
        return self.allObjects.first
    }

    public var isEmpty: Bool {
        var isEmpty: Bool?
        self.mutatingOperation {
            isEmpty = self.allObjects.isEmpty
        }
        return isEmpty ?? false
    }

    public func add(#object: AnyObject) {
        self.mutatingOperation {
            self.addObject(object)
        }
    }

    public func add(#objects: [AnyObject]) {
        objects.each { self.add(object: $0) }
    }

    public func each(block: ((AnyObject)->(Void))) {
        self.mutatingOperation {
            self.allObjects.each(block)
        }
    }
    
    public func sorted(sortBlock: ((AnyObject, AnyObject)->(Bool))) -> [AnyObject] {
        var sortedObjects: [AnyObject] = []
        self.mutatingOperation {
            sortedObjects = self.allObjects.sorted(sortBlock)
        }
        return sortedObjects
    }

    public func remove(#object: AnyObject) {
        self.mutatingOperation {
            self.removeObject(object)
        }
    }

    public func removeAll() {
        self.mutatingOperation {
            self.removeAllObjects()
        }
    }

    private func mutatingOperation(operationBlock: (Void)->(Void)) {
        self.synced(operationBlock)
    }
}
