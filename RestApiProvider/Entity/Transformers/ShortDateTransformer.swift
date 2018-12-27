import Foundation
import Domain

final class ShortDateTransformer: CodingContainerTransformer {
    typealias Input = String
    typealias Output = Date?

    public func transform(_ decoded: Input) throws -> Output {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.isLenient = true

        let date = formatter.date(from: decoded)
        if let date = date {
            return date
        } else {
            return nil
        }
    }

    public func transform(_ encoded: Output) throws -> Input {
        guard let encoded = encoded else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.isLenient = true

        return formatter.string(from: encoded)
    }
}
