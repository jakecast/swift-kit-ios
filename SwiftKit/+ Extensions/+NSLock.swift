import Foundation

public extension NSLock {
    var isLocked: Bool {
        let isLocked: Bool
        self.enterSync()
        if self.tryLock() == true {
            self.unlock()
            isLocked = false
        }
        else {
            isLocked = true
        }
        self.exitSync()
        return isLocked
    }
    
    func tryUnlock() {
        if self.isLocked == true {
            self.unlock()
        }
    }
}
