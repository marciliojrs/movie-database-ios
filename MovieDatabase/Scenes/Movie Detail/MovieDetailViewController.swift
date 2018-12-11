import Hero
import RxCocoa
import RxSwift
import RxGesture

final class MovieDetailViewController: BaseViewController<MovieDetailViewModel> {
    override var layout: LayoutFile? { return R.file.movieDetailViewXml }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    @objc private weak var cardView: UIView!
    @objc private weak var visualEffectView: UIVisualEffectView!
    @objc private weak var scrollView: UIScrollView!
    @objc private weak var titleLabel: UILabel!
    @objc private weak var releaseDateLabel: UILabel!
    @objc private weak var overviewLabel: UILabel!
    @objc private weak var genresLabel: UILabel!
    @objc private weak var closeButton: UIButton!

    override var initialViewState: ViewState {
        return ["imageUrl": nil,
                "title": "",
                "releaseDate": "",
                "overview": "",
                "genres": ""]
    }

    override func layoutLoad() {
        setupHero(for: viewModel.movieId)
        setupPanGestureToDismiss()

        bag << viewModel.output.movieSubject.map {
            ["imageUrl": $0.backdropPath as Any,
             "title": $0.title,
             "releaseDate": $0.releaseDate,
             "overview": $0.overview,
             "genres": $0.genres]
        }.drive(rx.state)
    }

    override func bindOutlets() {
        bag << closeButton.rx.tap.bind(to: viewModel.input.close)
    }

    private func setupHero(for movieId: Int) {
        hero.isEnabled = true
        hero.modalAnimationType = .none

        cardView.hero.id = "card\(movieId)"
        cardView.hero.modifiers = [.spring(stiffness: 250, damping: 25)]
        titleLabel.hero.modifiers = [.fade, .scale(0.1)]
        releaseDateLabel.hero.modifiers = [.fade, .translate(x: -100)]
        overviewLabel.hero.modifiers = [.translate(y: 1000)]
        genresLabel.hero.modifiers = [.fade, .translate(x: -100)]
        visualEffectView.hero.modifiers = [.fade]
        closeButton.superview?.hero.modifiers = [.fade]
        scrollView.hero.modifiers = [.source(heroID: "card\(movieId)"),
                                     .spring(stiffness: 250, damping: 25)]
    }

    private func setupPanGestureToDismiss() {
        let panGesture = scrollView.rx.panGesture { [scrollView] (_, delegate) in
            delegate.beginPolicy = .custom { _ in scrollView!.contentOffset.y <= 0 }
            delegate.simultaneousRecognitionPolicy = .always
        }.share(replay: 1, scope: .whileConnected)

        bag << panGesture.subscribe(onNext: { [unowned self] (gesture) in
            let translation = gesture.translation(in: self.view)
            switch gesture.state {
            case .began:
                self.dismiss(animated: true, completion: nil)
            case .changed:
                Hero.shared.update(translation.y / self.view.bounds.height)
            default:
                let velocity = gesture.velocity(in: self.view)
                if ((translation.y + velocity.y) / self.view.bounds.height) > 0.5 {
                    Hero.shared.finish()
                } else {
                    Hero.shared.cancel()
                }
            }
        })
    }

}
