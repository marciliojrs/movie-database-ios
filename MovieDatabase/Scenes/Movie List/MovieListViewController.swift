import UIKit
import RxSwift
import RxCocoa

final class MovieListViewController: BaseViewController<MovieListViewModel> {
    override var layout: LayoutFile? { return R.file.movieListViewXml }
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    @objc private weak var collectionView: UICollectionView!
    private let adapter = MovieListAdapter()
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search for a movie"
        return searchController
    }()

    override var initialViewState: ViewState {
        return ["isLoading": true]
    }

    override func layoutLoad() {
        setupNavigationBarAndSearch()

        adapter.attach(listView: collectionView)
        bag << [
            viewModel.output.movies.drive(adapter.rx.updateItems),
            viewModel.output.isLoading.map { ["isLoading": $0] }.drive(rx.state)
        ]
    }

    override func bindOutlets() {
        bag << adapter.rx.itemSelected.bind(to: viewModel.input.selectMovie)

        let reachedCollectionBottom = collectionView.rx.contentOffset.map { [collectionView] (offset) in
            collectionView?.isNearTheBottomEdge(contentOffset: offset) ?? false
        }.flatMap { isNear -> Observable<Void> in
            isNear ? Observable.just(()) : Observable.empty()
        }

        bag << [
            reachedCollectionBottom
                .filter { [searchController] in !searchController.isActive }
                .bind(to: viewModel.input.nextPageTrigger),
            reachedCollectionBottom
                .filter { [searchController] in searchController.isActive }
                .bind(to: viewModel.input.searchNextPageTrigger),
            searchController.searchBar.rx.text.orEmpty.skip(1)
                .filter { $0.count >= 3 }
                .debounce(0.2, scheduler: MainScheduler.instance)
                .bind(to: viewModel.input.searchString),
            searchController.rx.willPresent
                .do(onNext: { [navigationItem] in
                    navigationItem.title = "Search"
                }).map { SearchState.active }.bind(to: viewModel.input.searchState),
            searchController.searchBar.rx.cancelButtonClicked
                .do(onNext: { [collectionView, adapter, navigationItem] in
                    navigationItem.title = "Upcoming Movies"
                    if adapter.items.count > 0 {
                        collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                    }
                }).map { SearchState.inactive }.bind(to: viewModel.input.searchState)
        ]
    }

    private func setupNavigationBarAndSearch() {
        definesPresentationContext = true
        navigationItem.title = "Upcoming Movies"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.barStyle = .black
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        navigationItem.searchController = searchController
    }
}
