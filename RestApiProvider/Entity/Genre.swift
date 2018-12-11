import Domain

//sourcery: AutoInit
public struct Genre: AutoCodable, AutoEquatable {
    public let id: Int
    public let name: String

    // sourcery:inline:auto:Genre.AutoInit
// swiftlint:disable superfluous_disable_command
// swiftlint:disable:next line_length
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
// swiftlint:enable superfluous_disable_command
    // sourcery:end
}

extension Domain.Genre: DomainEncodable {
    typealias Encoder = Genre
    var encoded: Encoder { return Genre(with: self) }
}

extension Genre: DomainConvertibleType {
    typealias DomainType = Domain.Genre

    init(with domain: DomainType) {
        self.id = domain.id
        self.name = domain.name
    }

    func asDomain() -> Genre.DomainType {
        return Domain.Genre(
            id: id,
            name: name
        )
    }
}
