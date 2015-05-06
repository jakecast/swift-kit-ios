import UIKit

public extension UICollectionViewLayoutAttributes {
    var minX: CGFloat {
        return self.frame.minX
    }
    
    var maxX: CGFloat {
        return self.frame.maxX
    }
    
    var minY: CGFloat {
        return self.frame.minY
    }
    
    var maxY: CGFloat {
        return self.frame.maxY
    }
    
    var height: CGFloat {
        return self.size.height
    }
    
    var width: CGFloat {
        return self.size.width
    }
}