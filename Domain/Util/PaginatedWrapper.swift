public struct PaginatedMovieWrapper: AutoEquatable {
    public let items: [Movie]
    public let nextPage: Int?

    public init(items: [Movie], nextPage: Int?) {
        self.items = items
        self.nextPage = nextPage
    }
}
