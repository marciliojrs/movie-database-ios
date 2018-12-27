import Foundation

enum Environment: String, Codable {
    case dev, staging, production
}

struct Platform {
    static var environment: Environment {
        return appPlist.environment
    }

    static var isRunningTests: Bool = {
        return NSClassFromString("XCTestCase") != nil
    }()

    static var isRunningOnSimulator: Bool = {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }()

    static var isDebugging: Bool {
        return _isDebugAssertConfiguration()
    }
}
