import Domain

public class UseCaseFactory: Domain.UseCaseFactory {
    private let requestMaker: NetworkRequestMakerType
    public init(baseUrl: String) {
        requestMaker = NetworkRequestMaker(baseUrl: baseUrl)
    }

    public func getUpcomingMovies() -> GetUpcomingMoviesUseCaseType {
        let repository = MovieRepository(networkMaker: requestMaker)
        return GetUpcomingMoviesUseCase(movieRepository: repository)
    }

    public func getMovieDetails() -> GetMovieDetailUseCaseType {
        let repository = MovieRepository(networkMaker: requestMaker)
        return GetMovieDetailUseCase(movieRepository: repository)
    }

    public func searchMoviesByQueryString() -> SearchMovieByQueryStringUseCaseType {
        let repository = MovieRepository(networkMaker: requestMaker)
        return SearchMovieByQueryStringUseCase(movieRepository: repository)
    }
}
