import URLNavigator
import Domain
import SafariServices

enum Route {
    static func initialize(navigator: NavigatorType) {
        registerAppRoutes(in: navigator)
    }
}

extension Route {
    private static func registerAppRoutes(in navigator: NavigatorType) {
        navigator.register("upcoming") { (_, _, _) -> UIViewController? in
            let viewModel = MovieListViewModel(navigator: navigator,
                                               upcomingMoviesUseCase: factory.getUpcomingMovies(),
                                               searchUseCase: factory.searchMoviesByQueryString())
            let viewController = MovieListViewController(viewModel: viewModel)
            return viewController
        }

        navigator.register("movie/<int:id>") { (_, values, context) -> UIViewController? in
            guard let movieId = values["id"] as? Identity else { return nil }
            let viewModel = MovieDetailViewModel(navigator: navigator,
                                                 getDetailUseCase: factory.getMovieDetails(),
                                                 movieId: movieId,
                                                 movie: context as? Movie)
            let viewController = MovieDetailViewController(viewModel: viewModel)

            return viewController
        }
    }
}

extension NavigatorType {
    func goToPreviousScreen() {
        if let navigationController = UIViewController.topMost?.navigationController {
            navigationController.popViewController(animated: true)
        } else if let topMost = UIViewController.topMost {
            topMost.dismiss(animated: true, completion: nil)
        }
    }

    func dismissPresenting() {
        UIViewController.topMost?.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    func goToTab(_ index: Int) {
        UIViewController.topMost?.tabBarController?.selectedIndex = index
    }
}
