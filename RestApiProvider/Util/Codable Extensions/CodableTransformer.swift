import Foundation

protocol DecodingContainerTransformer {
    associatedtype Input
    associatedtype Output
    func transform(_ decoded: Input) throws -> Output
}

protocol EncodingContainerTransformer {
    associatedtype Input
    associatedtype Output
    func transform(_ encoded: Output) throws -> Input
}

typealias CodingContainerTransformer = DecodingContainerTransformer & EncodingContainerTransformer

extension KeyedDecodingContainer {
    func decode<T: DecodingContainerTransformer>(_ key: KeyedDecodingContainer.Key, transformer: T)
        throws -> T.Output where T.Input: Decodable {
        let decoded: T.Input = try self.decode(key)
        return try transformer.transform(decoded)
    }

    func decodeIfPresent<T: DecodingContainerTransformer>(_ key: KeyedDecodingContainer.Key, transformer: T)
        throws -> T.Output? where T.Input: Decodable {
        if let decoded: T.Input = try self.decodeIfPresent(key) {
            return try transformer.transform(decoded)
        }

        return nil
    }

    func decode<T>(_ key: KeyedDecodingContainer.Key) throws -> T where T: Decodable {
        return try self.decode(T.self, forKey: key)
    }

    func decodeIfPresent<T>(_ key: KeyedDecodingContainer.Key) throws -> T? where T: Decodable {
        return try self.decodeIfPresent(T.self, forKey: key)
    }
}

extension KeyedEncodingContainer {
    mutating func encode<T: EncodingContainerTransformer>(_ value: T.Output,
                                                          forKey key: KeyedEncodingContainer.Key,
                                                          transformer: T) throws where T.Input: Encodable {
        let transformed: T.Input = try transformer.transform(value)
        try self.encode(transformed, forKey: key)
    }

    mutating func encodeIfPresent<T: EncodingContainerTransformer>(_ value: T.Output?,
                                                                   forKey key: KeyedEncodingContainer.Key,
                                                                   transformer: T) throws where T.Input: Encodable {
        guard let value = value else {
            try self.encodeNil(forKey: key)
            return
        }

        let transformed: T.Input = try transformer.transform(value)
        try self.encode(transformed, forKey: key)
    }
}
