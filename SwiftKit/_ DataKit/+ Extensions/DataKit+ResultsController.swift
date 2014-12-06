import UIKit


public extension ResultsController {
    func setResultsDelegate(#resultsDelegate: ResultsControllerDelegate) -> Self {
        self.delegate = resultsDelegate

        return self
    }

    func performFetch() -> Self {
        self.performFetch(nil)

        return self
    }
}
