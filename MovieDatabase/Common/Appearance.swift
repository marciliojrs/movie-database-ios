import UIKit

class AppNavigationController: UINavigationController {}

struct Appearance {
    private init() {}

    static func install() {
        setNavigationBarAppearance()
    }

    static private func setNavigationBarAppearance() {
        let transparentNavBar
            = UINavigationBar.appearance(whenContainedInInstancesOf: [AppNavigationController.self])

        transparentNavBar.barTintColor = .black
        transparentNavBar.isTranslucent = true
        transparentNavBar.backgroundColor = .black
        transparentNavBar.setBackgroundImage(UIImage(), for: .default)
        transparentNavBar.shadowImage = UIImage()
        transparentNavBar.tintColor = .white
        transparentNavBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        transparentNavBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

enum Font {
    case title1, title1Bold, title2, title2Bold, title3, title3Bold, headline, subheadline, body, bodyBold,
    callout, footnote, caption1, caption1Bold, caption2

    private var fontSize: CGFloat {
        switch self {
        case .body, .bodyBold: return UIFont.preferredFont(forTextStyle: .body).pointSize
        case .footnote: return UIFont.preferredFont(forTextStyle: .footnote).pointSize
        case .title1, .title1Bold: return UIFont.preferredFont(forTextStyle: .title1).pointSize
        case .title2, .title2Bold: return UIFont.preferredFont(forTextStyle: .title2).pointSize
        case .title3, .title3Bold: return UIFont.preferredFont(forTextStyle: .title3).pointSize
        case .headline: return UIFont.preferredFont(forTextStyle: .headline).pointSize
        case .subheadline: return UIFont.preferredFont(forTextStyle: .subheadline).pointSize
        case .callout: return UIFont.preferredFont(forTextStyle: .callout).pointSize
        case .caption1, .caption1Bold: return UIFont.preferredFont(forTextStyle: .caption1).pointSize
        case .caption2: return UIFont.preferredFont(forTextStyle: .caption2).pointSize
        }
    }

    var font: UIFont {
        switch self {
        case .body: return UIFont.preferredFont(forTextStyle: .body)
        case .footnote: return UIFont.preferredFont(forTextStyle: .footnote)
        case .title1: return UIFont.preferredFont(forTextStyle: .title1)
        case .title2: return UIFont.preferredFont(forTextStyle: .title2)
        case .title3: return UIFont.preferredFont(forTextStyle: .title3)
        case .headline: return UIFont.preferredFont(forTextStyle: .headline)
        case .subheadline: return UIFont.preferredFont(forTextStyle: .subheadline)
        case .callout: return UIFont.preferredFont(forTextStyle: .callout)
        case .caption1: return UIFont.preferredFont(forTextStyle: .caption1)
        case .caption2: return UIFont.preferredFont(forTextStyle: .caption2)
        case .title1Bold, .title2Bold, .title3Bold, .caption1Bold, .bodyBold:
            return UIFont.systemFont(ofSize: fontSize, weight: .bold)
        }
    }

    static var layoutConstants: [String: Any] {
        return ["theme.font.body": Font.body.font,
                "theme.font.body.bold": Font.bodyBold.font,
                "theme.font.footnote": Font.footnote.font,
                "theme.font.title1": Font.title1.font,
                "theme.font.title1.bold": Font.title1Bold.font,
                "theme.font.title2": Font.title2.font,
                "theme.font.title2.bold": Font.title2Bold.font,
                "theme.font.title3": Font.title3.font,
                "theme.font.title3.bold": Font.title3Bold.font,
                "theme.font.headline": Font.headline.font,
                "theme.font.subheadline": Font.subheadline.font,
                "theme.font.callout": Font.callout.font,
                "theme.font.caption1": Font.caption1.font,
                "theme.font.caption1.bold": Font.caption1Bold.font,
                "theme.font.caption2": Font.caption2.font]
    }
}

extension UIColor {
    static var layoutConstants: [String: Any] {
        return [:]
    }
}
