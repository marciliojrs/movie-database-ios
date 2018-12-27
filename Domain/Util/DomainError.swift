import Foundation

public enum DomainError: Swift.Error, Equatable {
    case unknown
    case objectMapping(type: Any)
    case invalidModel(key: String, type: Any)
    case underlying(Swift.Error)
    case invalidModelTransform
    case resourceNotFound
    case validation([String: Any])

    public static func == (lhs: DomainError, rhs: DomainError) -> Bool {
        switch (lhs, rhs) {
        case (.unknown, .unknown): return true
        case (.objectMapping, .objectMapping): return true
        case (.invalidModel, .invalidModel): return true
        case (.underlying, .underlying): return true
        case (.invalidModelTransform, .invalidModelTransform): return true
        case (.resourceNotFound, .resourceNotFound): return true
        case (.validation, .validation): return true
        default: return false
        }
    }
}
