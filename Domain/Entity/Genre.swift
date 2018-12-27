//sourcery: AutoInit
public struct Genre: Identifiable, AutoEquatable {
    public let id: Identity
    public let name: String

// sourcery:inline:auto:Genre.AutoInit
// swiftlint:disable superfluous_disable_command
// swiftlint:disable:next line_length
    public init(id: Identity, name: String) {
        self.id = id
        self.name = name
    }
// swiftlint:enable superfluous_disable_command
// sourcery:end
}
