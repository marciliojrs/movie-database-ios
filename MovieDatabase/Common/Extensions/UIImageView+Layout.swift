import Layout
import UIKit
import Kingfisher
import ObjectiveC

extension RuntimeType {
    @objc static let uiImageRenderingMode = RuntimeType([
        "alwaysOriginal": .alwaysOriginal,
        "alwaysTemplate": .alwaysTemplate,
        "automatic": .automatic
    ] as [String: UIImage.RenderingMode])
}

extension UIImageView {
    open override class var expressionTypes: [String: RuntimeType] {
        var types = super.expressionTypes
        types["imageUrl"] = .url
        types["renderingMode"] = .uiImageRenderingMode
        return types
    }

    open override func setValue(_ value: Any, forExpression name: String) throws {
        switch name {
        case "imageUrl":
            let imageUrl = value as? URL
            self.kf.indicatorType = .activity
            self.kf.setImage(with: imageUrl, placeholder: R.image.placeholder(), options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage,
                .backgroundDecode
            ])
        case "renderingMode":
            let renderingMode = value as? UIImage.RenderingMode ?? .automatic
            self.image = image?.withRenderingMode(renderingMode)
        default:
            try super.setValue(value, forExpression: name)
        }
    }
}
