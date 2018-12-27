import URLNavigator
import Domain
import RxSwift
import RxCocoa

struct MovieDetailViewModel: RxViewModel {
    let input: MovieDetailViewModel.Input
    let output: MovieDetailViewModel.Output
    let movieId: Int

    private let getDetailUseCase: Domain.GetMovieDetailUseCaseType
    private let bag = DisposeBag()

    //sourcery: input=Void
    private let close = PublishSubject<Void>()
    //sourcery: output="MovieInfoViewModel"
    private let movieSubject = ReplaySubject<MovieInfoViewModel>.create(bufferSize: 1)

    init(navigator: NavigatorType,
         getDetailUseCase: Domain.GetMovieDetailUseCaseType,
         movieId: Identity,
         movie: Movie?) {
        input = Input(close: close.asObserver())
        output = Output(movieSubject: movieSubject.asDriver(onErrorDriveWith: .empty()))

        self.getDetailUseCase = getDetailUseCase
        self.movieId = movieId

        if let movie = movie {
            movieSubject.on(.next(MovieInfoViewModel(movie: movie)))
        }

        bag << getDetailUseCase.execute(id: movieId)
            .map(MovieInfoViewModel.init).asObservable()
            .bind(to: movieSubject)
        bag << close.subscribe(onNext: {
            navigator.dismissPresenting()
        })
    }
}

struct MovieInfoViewModel {
    let id: Identity
    let title: String
    let releaseDate: String
    let backdropPath: URL?
    let genres: String
    let overview: String

    init(movie: Movie) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        id = movie.id
        title = movie.title
        releaseDate = movie.releaseDate != nil ? dateFormatter.string(from: movie.releaseDate!) : ""
        backdropPath = movie.backdropPath
        genres = movie.genres?.map { $0.name }.joined(separator: ", ") ?? ""
        overview = movie.overview
    }
}
