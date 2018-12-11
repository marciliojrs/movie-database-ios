import Domain
import URLNavigator
import RxSwift

enum SearchState {
    case active, inactive
}

struct MovieListViewModel: RxViewModel {
    let input: MovieListViewModel.Input
    let output: MovieListViewModel.Output

    private let navigator: NavigatorType
    private let upcomingMoviesUseCase: Domain.GetUpcomingMoviesUseCaseType
    private let searchUseCase: Domain.SearchMovieByQueryStringUseCaseType
    private let bag = DisposeBag()

    //sourcery: input=Void
    private let nextPageTrigger = PublishSubject<Void>()
    //sourcery: input=Void
    private let searchNextPageTrigger = PublishSubject<Void>()
    //sourcery: input=MovieListItemViewModel
    private let selectMovie = PublishSubject<MovieListItemViewModel>()
    //sourcery: input=String?
    private let searchString = PublishSubject<String?>()
    //sourcery: input=SearchState
    private let searchState = BehaviorSubject<SearchState>(value: .inactive)
    //sourcery: output=[MovieListItemViewModel]
    private let movies = ReplaySubject<[MovieListItemViewModel]>.create(bufferSize: 1)
    //sourcery: output=Bool
    private let isLoading = RxActivityTracker()

    private let upcomingMovies = BehaviorSubject<[Movie]>(value: [])
    private let filteredMovies = BehaviorSubject<[Movie]>(value: [])

    init(navigator: NavigatorType,
         upcomingMoviesUseCase: Domain.GetUpcomingMoviesUseCaseType,
         searchUseCase: Domain.SearchMovieByQueryStringUseCaseType) {
        input = Input(nextPageTrigger: nextPageTrigger.asObserver(),
                      searchNextPageTrigger: searchNextPageTrigger.asObserver(),
                      selectMovie: selectMovie.asObserver(),
                      searchString: searchString.asObserver(),
                      searchState: searchState.asObserver())
        output = Output(movies: movies.asDriver(onErrorJustReturn: []), isLoading: isLoading.asDriver())

        self.navigator = navigator
        self.upcomingMoviesUseCase = upcomingMoviesUseCase
        self.searchUseCase = searchUseCase

        observe()
    }

    private func observe() {
        bag << [
            upcoming(from: [], page: 1, loadNextPage: nextPageTrigger)
                .bind(to: upcomingMovies),
            selectMovie.subscribe(onNext: { [navigator] in
                navigator.present("movie/\($0.id)", context: $0.movie)
            }),
            searchString
                .flatMapLatest { (queryString) -> Observable<[Movie]> in
                    guard let query = queryString, !queryString.isNilOrEmpty else { return .just([]) }
                    return self.search(from: [], query: query, page: 1, loadNextPage: self.searchNextPageTrigger)
                }.bind(to: filteredMovies)
        ]

        let combinedMoviesObservable = Observable.combineLatest(upcomingMovies, filteredMovies)
        bag << Observable.combineLatest(combinedMoviesObservable, searchState) { (pair, state) in
            return state == .active ? pair.1 : pair.0
        }.map { $0.map(MovieListItemViewModel.init) }.bind(to: movies)

        bag << searchState.filter { $0 == .active }.map { _ in [] }.bind(to: filteredMovies)
    }

    private func upcoming(from current: [Movie],
                          page: Int,
                          loadNextPage trigger: Observable<Void>) -> Observable<[Movie]> {
        return upcomingMoviesUseCase.execute(page: page).flatMap { (paginated) -> Observable<[Movie]> in
            let newList = current + paginated.items
            if let page = paginated.nextPage {
                return Observable.concat([
                    Observable.just(newList),
                    Observable.never().takeUntil(trigger),
                    self.upcoming(from: newList, page: page, loadNextPage: trigger)
                ])
            } else { return Observable.just(newList) }
        }.track(activity: isLoading)
    }

    private func search(from current: [Movie],
                        query: String,
                        page: Int,
                        loadNextPage trigger: Observable<Void>) -> Observable<[Movie]> {
        return searchUseCase.execute(query: query, page: page)
            .catchErrorJustReturn(PaginatedMovieWrapper(items: [], nextPage: nil))
            .flatMap { (paginated) -> Observable<[Movie]> in
                let newList = current + paginated.items
                if let page = paginated.nextPage {
                    return Observable.concat([
                        Observable.just(newList),
                        Observable.never().takeUntil(trigger),
                        self.search(from: newList, query: query, page: page, loadNextPage: trigger)
                    ])
                } else { return Observable.just(newList) }
            }
    }
}

struct MovieListItemViewModel {
    let id: Identity
    let title: String
    let releaseDate: String
    let backdropPath: URL?
    fileprivate let movie: Movie

    init(movie: Movie) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        id = movie.id
        title = movie.title
        releaseDate = movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : ""
        backdropPath = movie.backdropPath

        self.movie = movie
    }
}

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self == nil || self?.isEmpty == true
    }
}
