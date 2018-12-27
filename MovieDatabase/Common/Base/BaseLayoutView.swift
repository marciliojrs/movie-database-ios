import UIKit
import Layout

class LayoutView: UIView, LayoutLoading {
    open var layout: LayoutFile { fatalError("Define a layout file") }
    open var constants: [String: Any] { return [:] }
    open var initialState: [String: Any?] { return [:] }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadLayout(layout, state: initialState, constants: constants)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadLayout(layout, state: initialState, constants: constants)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutNode?.view.frame = self.bounds
    }

    func layoutDidLoad(_ node: LayoutNode) {
        rebuildView()
    }

    open func rebuildView() {}

    func setState(_ state: ViewState, animated: Bool = false) {
        layoutNode?.setState(state, animated: animated)
    }
}
