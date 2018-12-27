import Domain

struct PaginatedMovieWrapper: AutoCodable {
    let results: [Movie]
    let page: Int
    let totalPages: Int
    let totalResults: Int
}

extension Domain.PaginatedMovieWrapper: DomainEncodable {
    typealias Encoder = PaginatedMovieWrapper
    var encoded: Encoder { return PaginatedMovieWrapper(with: self) }
}

extension PaginatedMovieWrapper: DomainConvertibleType {
    typealias DomainType = Domain.PaginatedMovieWrapper

    init(with domain: DomainType) {
        self.results = domain.items.map { $0.encoded }
        self.page = 0
        self.totalPages = 0
        self.totalResults = 0
    }

    func asDomain() -> PaginatedMovieWrapper.DomainType {
        return Domain.PaginatedMovieWrapper(
            items: results.mapToDomain(),
            nextPage: page < totalPages ? page + 1 : nil
        )
    }
}
