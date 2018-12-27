public protocol UseCaseFactory: class {
    func getUpcomingMovies() -> GetUpcomingMoviesUseCaseType
    func getMovieDetails() -> GetMovieDetailUseCaseType
    func searchMoviesByQueryString() -> SearchMovieByQueryStringUseCaseType
}
