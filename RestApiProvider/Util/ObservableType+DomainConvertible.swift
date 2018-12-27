import Foundation
import RxSwift

extension ObservableType where E: DomainConvertibleType {
    func mapToDomain() -> Observable<E.DomainType> {
        return self.map { $0.asDomain() }
    }
}

extension Observable where Element: Sequence, Element.Iterator.Element: DomainConvertibleType {
    typealias DomainType = Element.Iterator.Element.DomainType

    func mapToDomain() -> Observable<[DomainType]> {
        return map { sequence -> [DomainType] in
            return sequence.mapToDomain()
        }
    }
}

extension Sequence where Iterator.Element: DomainConvertibleType {
    typealias Element = Iterator.Element

    func mapToDomain() -> [Element.DomainType] {
        return map { return $0.asDomain() }
    }
}
