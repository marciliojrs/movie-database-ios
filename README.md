# MovieDatabase

This app uses api from The Movie DB to search movies and show upcoming movies.

## Getting Started

There instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

- Xcode 10.1
- Homebrew
- Bundler

### Installing

After clone the project, please run the following script in your terminal application:

`./bin/setup`

This script will install all dependencies necessary to run the app, like:

- CocoaPods
- Fastlane
- Carthage
- Swiftlint

### Running

To run the app just open the `MovieDatabase.xcworkspace` file and play.

## Running the tests

To run the tests just run the following script in your terminal application:

`./bin/test`

### Dependencies

- Fakery: Test helper to generate fake data for app entities.
- Hero: Transition library used to create transition effects when present movie details.
- Kingfisher: Download, processing and cache images.
- Layout: Declarative UI framework used to create all views.
- Quick & Nimble: Test helper to implement behavior driven tests and matcher framework.
- RxGesture: Reactive wrapper for gesture recognizers.
- RxSwift: Used to implement concepts of reactive programming. All app architecture is based in reactive programming.
- R.swift: Generate strong typed classes for app resources like images, fonts, strings.
- Sourcery: Code generator used to create some boilerplate codes like Codables, API requests, Equatables.
- SwiftyBeaver: Logger library.
- URLNavigator: Navigation through view controllers by URLs.
