import RxSwift

public protocol GetUpcomingMoviesUseCaseType: UseCase {
    init(movieRepository: MovieRepository)
    func execute(page: Int) -> Observable<PaginatedMovieWrapper>
}

public struct GetUpcomingMoviesUseCase: GetUpcomingMoviesUseCaseType {
    private let repository: MovieRepository

    public init(movieRepository: MovieRepository) {
        self.repository = movieRepository
    }

    public func execute(page: Int) -> Observable<PaginatedMovieWrapper> {
        guard page > 0 else { return .error(DomainError.validation(["message": "invalid page"])) }
        return repository.upcoming(page: page)
    }
}
