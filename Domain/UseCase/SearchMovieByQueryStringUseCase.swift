import RxSwift

public protocol SearchMovieByQueryStringUseCaseType: UseCase {
    init(movieRepository: MovieRepository)
    func execute(query: String, page: Int) -> Observable<PaginatedMovieWrapper>
}

public struct SearchMovieByQueryStringUseCase: SearchMovieByQueryStringUseCaseType {
    private let repository: MovieRepository
    public init(movieRepository: MovieRepository) {
        self.repository = movieRepository
    }

    public func execute(query: String, page: Int) -> Observable<PaginatedMovieWrapper> {
        return repository.search(query: query, page: page)
    }
}
