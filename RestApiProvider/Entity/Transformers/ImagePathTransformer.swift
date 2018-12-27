import Foundation
import Domain

final class ImagePathTransformer: CodingContainerTransformer {
    typealias Input = String
    typealias Output = URL

    public func transform(_ decoded: Input) throws -> Output {
        let fullPath = "https://image.tmdb.org/t/p/w500" + decoded
        return URL(string: fullPath)!
    }

    public func transform(_ encoded: Output) throws -> Input {
        return encoded.lastPathComponent
    }
}
