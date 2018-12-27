import RxSwift

public protocol GetMovieDetailUseCaseType: UseCase {
    init(movieRepository: MovieRepository)
    func execute(id: Identity) -> Single<Movie>
}

public struct GetMovieDetailUseCase: GetMovieDetailUseCaseType {
    private let repository: MovieRepository
    public init(movieRepository: MovieRepository) {
        self.repository = movieRepository
    }

    public func execute(id: Identity) -> Single<Movie> {
        return repository.get(by: id).asSingle()
    }
}
