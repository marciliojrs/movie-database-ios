@testable import Domain
import Quick
import Nimble
import RxTest
import RxSwift

class GetMovieDetailUseCaseSpec: QuickSpec {
    override func spec() {
        describe("GetMovieDetailUseCase") {
            describe("execute") {
                context("with a valid id") {
                    let repository = MovieRepositoryMock()
                    repository.getByReturnValue = .just(movie)
                    let useCase = GetMovieDetailUseCase(movieRepository: repository)

                    it("should emit a movie") {
                        let scheduler = TestScheduler(initialClock: 0)
                        let observer = scheduler.record(useCase.execute(id: 1))
                        scheduler.start()

                        expect(observer.events) == [next(0, movie), completed(0)]
                    }
                }

                context("with an invalid id") {
                    let repository = MovieRepositoryMock()
                    let notFoundError = DomainError.resourceNotFound
                    repository.getByReturnValue = .error(notFoundError)

                    let useCase = GetMovieDetailUseCase(movieRepository: repository)

                    it("should emit an resourceNotFound error") {
                        let scheduler = TestScheduler(initialClock: 0)
                        let observer = scheduler.record(useCase.execute(id: 1))
                        scheduler.start()

                        expect(observer.events) == [error(0, notFoundError)]
                    }
                }
            }
        }
    }
}

private let movie: Movie = .random
