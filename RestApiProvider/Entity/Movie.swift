import Foundation
import Domain

//sourcery: AutoInit
struct Movie: AutoCodable, AutoEquatable {
    let id: Int
    let title: String
    //sourcery: transformer="ImagePathTransformer"
    let posterPath: URL?
    //sourcery: transformer="ImagePathTransformer"
    let backdropPath: URL?
    let overview: String
    //sourcery: transformer="ShortDateTransformer"
    //sourcery: forceDecode
    let releaseDate: Date?
    let genres: [Genre]?

// sourcery:inline:auto:Movie.AutoInit
// swiftlint:disable superfluous_disable_command
// swiftlint:disable:next line_length
    internal init(id: Int, title: String, posterPath: URL?, backdropPath: URL?, overview: String, releaseDate: Date?, genres: [Genre]?) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.genres = genres
    }
// swiftlint:enable superfluous_disable_command
// sourcery:end
}

extension Domain.Movie: DomainEncodable {
    typealias Encoder = Movie
    var encoded: Encoder { return Movie(with: self) }
}

extension Movie: DomainConvertibleType {
    typealias DomainType = Domain.Movie

    init(with domain: DomainType) {
        self.id = domain.id
        self.title = domain.title
        self.posterPath = domain.posterPath
        self.backdropPath = domain.backdropPath
        self.overview = domain.overview
        self.releaseDate = domain.releaseDate
        self.genres = domain.genres?.map { $0.encoded }
    }

    func asDomain() -> Movie.DomainType {
        return Domain.Movie(
            id: id,
            title: title,
            posterPath: posterPath,
            backdropPath: backdropPath,
            overview: overview,
            releaseDate: releaseDate,
            genres: genres?.mapToDomain()
        )
    }
}
