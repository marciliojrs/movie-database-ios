import RxSwift
import RxCocoa
import SwiftyBeaver

public struct Request: CustomStringConvertible {
    enum Method: String { case get = "GET", post = "POST", delete = "DELETE", patch = "PATCH", put = "PUT" }

    let type: Request.Method
    let path: String
    let components: [String: String?]
    let body: [String: Any]?
    let cacheable: Bool
    let headers: [String: String]?

    public var description: String {
        var desc = "path: \(path);"

        desc += " method: \(type.rawValue);"
        if let body = body { desc += " body: \(body);" }
        if let headers = headers { desc += " headers: \(headers);" }

        return desc
    }
}

public enum NetworkError: Swift.Error, Equatable {
    case invalidUrl
    case httpError(Int, String?)
    case error(Error)
    case unknownError

    static public func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidUrl, .invalidUrl): return true
        case (let .httpError(code1), let .httpError(code2)): return code1 == code2
        case (.error, error): return true
        case (.unknownError, .unknownError): return true
        default: return false
        }
    }
}

public protocol NetworkRequestMakerType: AutoMockable {
    func make(request: Request) -> Observable<Data>
}

public struct NetworkRequestMaker: NetworkRequestMakerType {
    private let baseUrl: String
    private let scheduler: ConcurrentDispatchQueueScheduler
    private let session: URLSession

    init(baseUrl: String) {
        self.baseUrl = baseUrl
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: .background, relativePriority: 1))
        self.session = URLSession.shared

        let console = ConsoleDestination()
        logger.addDestination(console)
    }

    public func make(request: Request) -> Observable<Data> {
        return data(request: request)
    }

    private func data(request: Request) -> Observable<Data> {
        var urlRequest: URLRequest
        do {
            urlRequest = try makeUrlRequest(for: request)
        } catch {
            return .error(error)
        }

        let cacheData = URLCache.shared.cachedResponse(for: urlRequest)?.data
        let networkResponse = session.rx.response(request: urlRequest)
            .flatMap { (response, data) -> Observable<Data> in
                if 200...299 ~= response.statusCode {
                    logger.info(["response": response.statusCode,
                                 "data": String(data: data, encoding: .utf8) ?? "",
                                 "request": request])
                    return .just(data)
                } else {
                    logger.error(["response": response.statusCode,
                                  "data": String(data: data, encoding: .utf8) ?? "",
                                  "request": request])
                    if let cache = cacheData, request.cacheable {
                        return .just(cache)
                    } else {
                        var message: String?
                        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
                            let json = jsonObject as? [String: Any] {
                            message = json["status_message"] as? String
                        }
                        return .error(NetworkError.httpError(response.statusCode, message))
                    }
                }
            }.subscribeOn(scheduler)

        if request.cacheable {
            let cacheResponse: Observable<Data> = cacheData != nil ? .just(cacheData!) : .empty()
            return cacheResponse.concat(networkResponse)
        } else {
            return networkResponse
        }
    }

    private func makeUrlRequest(for request: Request) throws -> URLRequest {
        guard var components = URLComponents(string: baseUrl) else {
            throw NetworkError.invalidUrl
        }

        components.queryItems = request.components.count > 0
            ? request.components.map { ($0.key, $0.value) }.map(URLQueryItem.init)
            : nil

        guard let path = components.url?.appendingPathComponent(request.path).absoluteString,
            let url = URL(string: path) else {
                throw NetworkError.invalidUrl
        }

        var urlRequest = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 120)
        urlRequest.httpMethod = request.type.rawValue
        if request.type == .post || request.type == .patch {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: request.body ?? [:])
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        for (key, value) in request.headers ?? [:] {
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }

        return urlRequest
    }
}
