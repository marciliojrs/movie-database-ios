@testable import Domain
import Quick
import Nimble
import RxTest
import RxSwift

class GetUpcomingMoviesUseCaseSpec: QuickSpec {
    override func spec() {
        describe("Get upcoming movies use case") {
            describe("execute") {
                context("when a invalid page is given") {
                    let repository = MovieRepositoryMock()
                    let useCase = GetUpcomingMoviesUseCase(movieRepository: repository)
                    it("should fail with a 'negative' page") {
                        let scheduler = TestScheduler(initialClock: 0)
                        let observer = scheduler.record(useCase.execute(page: -1))
                        scheduler.start()

                        let expectedError: DomainError = .validation(["message": "invalid page"])
                        expect(observer.events) == [error(0, expectedError)]
                    }
                }

                context("when a valid page is given") {
                    let repository = MovieRepositoryMock()
                    repository.upcomingPageReturnValue = .just(PaginatedMovieWrapper(items: upcomingMovies,
                                                                                     nextPage: nil))
                    let useCase = GetUpcomingMoviesUseCase(movieRepository: repository)
                    it("should return repository upcoming method result") {
                        let scheduler = TestScheduler(initialClock: 0)
                        let observer = scheduler.record(useCase.execute(page: 1))
                        scheduler.start()
                        expect(observer.events) == [next(0, PaginatedMovieWrapper(items: upcomingMovies,
                                                                                  nextPage: nil)),
                                                    completed(0)]
                    }
                }

                context("when repository emits an error") {
                    let repository = MovieRepositoryMock()
                    repository.upcomingPageReturnValue = .error(DomainError.unknown)
                    let useCase = GetUpcomingMoviesUseCase(movieRepository: repository)

                    it("should emit the same error emitted by repository") {
                        let scheduler = TestScheduler(initialClock: 0)
                        let observer = scheduler.record(useCase.execute(page: 1))
                        scheduler.start()
                        expect(observer.events) == [error(0, DomainError.unknown)]
                    }
                }
            }
        }
    }
}

private let upcomingMovies: [Movie] = Movie.randomArray
