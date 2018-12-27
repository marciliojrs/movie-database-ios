import UIKit

let isRunningTests = NSClassFromString("XCTestCase") != nil
/// the application's delegate class
let delegateClass: AnyClass = isRunningTests ? TestsAppDelegate.self : AppDelegate.self

let argv = UnsafeMutableRawPointer(CommandLine.unsafeArgv)
    .bindMemory(to: UnsafeMutablePointer<Int8>?.self, capacity: Int(CommandLine.argc))

//start application with the proper AppDelegate
_ = UIApplicationMain(CommandLine.argc, argv, nil, NSStringFromClass(delegateClass))
