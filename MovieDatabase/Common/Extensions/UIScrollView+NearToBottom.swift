import UIKit

extension UIScrollView {
    func isNearTheBottomEdge(contentOffset: CGPoint) -> Bool {
        return contentOffset.y + frame.size.height + 20 > contentSize.height
    }
}
