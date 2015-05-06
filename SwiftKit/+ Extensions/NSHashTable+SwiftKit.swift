import Foundation

public extension NSHashTable {
    var first: AnyObject? {
        return self.allObjects.first
    }

    var isEmpty: Bool {
        var isEmpty: Bool?
        self.mutatingOperation {
            isEmpty = self.allObjects.isEmpty
        }
        return isEmpty ?? false
    }

    func add(#object: AnyObject) {
        self.mutatingOperation {
            self.addObject(object)
        }
    }

    func add(#objects: [AnyObject]) {
        objects.each { self.add(object: $0) }
    }

    func each(block: ((AnyObject)->(Void))) {
        self.mutatingOperation {
            self.allObjects.each(block)
        }
    }
    
    func sorted(sortBlock: ((AnyObject, AnyObject)->(Bool))) -> [AnyObject] {
        var sortedObjects: [AnyObject] = []
        self.mutatingOperation {
            sortedObjects = self.allObjects.sorted(sortBlock)
        }
        return sortedObjects
    }

    func remove(#object: AnyObject) {
        self.mutatingOperation {
            self.removeObject(object)
        }
    }

    func removeAll() {
        self.mutatingOperation {
            self.removeAllObjects()
        }
    }

    private func mutatingOperation(operationBlock: (Void)->(Void)) {
        self.synced(operationBlock)
    }
}
