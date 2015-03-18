import Foundation

public extension NSFileCoordinator {
    func coordinateWriting(
        #URL: NSURL,
        options: NSFileCoordinatorWritingOptions=NSFileCoordinatorWritingOptions.allZeros,
        writeHandler: ((NSURL!) -> (Void))
    ) {
        self.debugOperation {(error) -> (Void) in
            self.coordinateWritingItemAtURL(URL, options: options, error: error, byAccessor: writeHandler)
        }
    }
}