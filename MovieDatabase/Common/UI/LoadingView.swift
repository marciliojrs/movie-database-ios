import UIKit

final class LoadingView: UIView {
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()

    override var isHidden: Bool {
        didSet {
            superview?.bringSubviewToFront(self)

            if isHidden {
                indicator.stopAnimating()
            } else {
                indicator.startAnimating()
            }
        }
    }

    static func addTo(view: UIView, insets: UIEdgeInsets = .zero) -> LoadingView {
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isUserInteractionEnabled = true
        loadingView.isHidden = true
        view.addSubview(loadingView)

        loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: insets.right).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom).isActive = true

        return loadingView
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isUserInteractionEnabled = false
        backgroundColor = UIColor.black.withAlphaComponent(0.7)

        addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.widthAnchor.constraint(equalToConstant: 36).isActive = true
        indicator.heightAnchor.constraint(equalToConstant: 36).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}
