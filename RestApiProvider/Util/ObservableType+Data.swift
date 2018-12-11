import RxSwift

extension ObservableType where Self.E == Data {
    func transform<T: DomainConvertibleCoding>(to: T.Type, keypath: String? = nil) -> Observable<T> {
        return map { (data) in
            var data = data
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            if let keyPath = keypath,
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                let object = json[keyPath] {
                data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            }

            return try decoder.decode(T.self, from: data)
        }
    }

    func transform<T: Codable>(to: T.Type, keypath: String? = nil) -> Observable<T> {
        return map { (data) in
            var data = data
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            if let keyPath = keypath,
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                let object = json[keyPath] {
                data = try JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
            }

            return try decoder.decode(T.self, from: data)
        }
    }
}

extension String {
    var utf8DecodedString: String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII) {
            return message
        }
        return ""
    }

    var utf8EncodedString: String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text ?? ""
    }

    var asInt: Int? {
        return Int(self)
    }
}
