import Foundation
//sourcery: AutoInit
public struct Movie: Identifiable, AutoEquatable {
    public let id: Identity
    public let title: String
    public let posterPath: URL?
    public let backdropPath: URL?
    public let overview: String
    public let releaseDate: Date?
    public let genres: [Genre]?

// sourcery:inline:auto:Movie.AutoInit
// swiftlint:disable superfluous_disable_command
// swiftlint:disable:next line_length
    public init(id: Identity, title: String, posterPath: URL?, backdropPath: URL?, overview: String, releaseDate: Date?, genres: [Genre]?) {
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
