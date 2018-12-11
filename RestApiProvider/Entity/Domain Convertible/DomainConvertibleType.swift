import Foundation

protocol DomainConvertibleType {
    associatedtype DomainType

    init(with domain: DomainType)
    func asDomain() -> DomainType
}

typealias DomainConvertibleCoding = DomainConvertibleType & Codable

protocol DomainEncodable {
    associatedtype Encoder: DomainConvertibleCoding
    var encoded: Encoder { get }
}

extension DomainConvertibleType where Self: Encodable {
    func asJson() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        //swiftlint:disable:next force_cast
        let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        return object
    }
}
