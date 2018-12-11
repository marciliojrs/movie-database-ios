import UIKit
import Layout
import Hero

final class MovieListItemCell: UICollectionViewCell {
    @objc private weak var containerView: UIView!
    @objc private weak var cardView: UIView!
    @objc private weak var titleLabel: UILabel!
    @objc private weak var releaseDateLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    private var isTouched: Bool = false {
        didSet {
            var transform = CGAffineTransform.identity
            if isTouched { transform = transform.scaledBy(x: 0.96, y: 0.96) }
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [],
                animations: { [containerView] in
                    containerView?.transform = transform
                }, completion: nil
            )
        }
    }

    public static func registerIntoList(_ listView: ListViewType?,
                                        state: ViewState,
                                        constants: [String: Any]? = nil,
                                        reuseIdentifier: String) {
        listView?.registerLayout(named: "MovieListItemCell",
                                 bundle: Bundle.main,
                                 relativeTo: #file,
                                 state: state,
                                 constants: defaultLayoutConstants, (constants ?? [:]),
                                 forCellReuseIdentifier: reuseIdentifier)
    }

    func setupHeroConstraints(for movieId: Int) {
        cardView.hero.id = "card\(movieId)"
        cardView.hero.modifiers = [.spring(stiffness: 250, damping: 25)]
        titleLabel.hero.modifiers = [.fade]
        releaseDateLabel.hero.modifiers = [.fade]
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouched = true
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouched = false
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouched = false
    }
}
