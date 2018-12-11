@testable import RestApiProvider
@testable import Domain
import Quick
import Nimble
import RxTest
import RxSwift
import RxBlocking

class MovieRepositorySpec: QuickSpec {
    override func spec() {
        describe("Movie repository") {
            self.upcomingTests()
            self.getDetailTests()
        }
    }

    private func upcomingTests() {
        describe("upcoming") {
            context("when return a valid response") {
                let requester = NetworkRequestMakerTypeMock()
                let response = try? FileReader.readData(from: "upcoming_valid_200", extension: "json")
                requester.makeRequestReturnValue = .just(response ?? Data())
                let repository = MovieRepository(networkMaker: requester)

                it("should emit an observable with the upcoming movies") {
                    let upcomingMovies = try? repository.upcoming(page: 1).toBlocking().first()!

                    expect(upcomingMovies).toNot(beNil())
                    expect(upcomingMovies?.items.count) == 20
                    expect(upcomingMovies?.items.first?.title) == "The Grinch"
                    expect(upcomingMovies?.items.last?.title) == "Green Book"
                }
            }

            context("when return an http error") {
                let requester = NetworkRequestMakerTypeMock()
                requester.makeRequestReturnValue = .error(NetworkError.httpError(404, nil))
                let repository = MovieRepository(networkMaker: requester)

                it("should emit a resourceNotFound error") {
                    let scheduler = TestScheduler(initialClock: 0)
                    let observer = scheduler.record(repository.upcoming(page: 1))
                    scheduler.start()

                    expect(observer.events) == [error(0, DomainError.resourceNotFound)]
                }
            }
        }
    }

    private func getDetailTests() {
        describe("get by id") {
            context("with a valid id") {
                let requester = NetworkRequestMakerTypeMock()
                let response = try? FileReader.readData(from: "getDetail_valid_200", extension: "json")
                requester.makeRequestReturnValue = .just(response ?? Data())
                let repository = MovieRepository(networkMaker: requester)

                it("should emit an observable with the upcoming movies") {
                    let movie = try? repository.get(by: 1).toBlocking().first()!

                    let expectedGenres = [Domain.Genre(id: 18, name: "Drama"),
                                          Domain.Genre(id: 80, name: "Crime")]
                    var expectedDateComponents = DateComponents()
                    expectedDateComponents.year = 1988
                    expectedDateComponents.month = 10
                    expectedDateComponents.day = 21

                    expect(movie?.id) == 2
                    expect(movie?.title) == "Ariel"
                    expect(movie?.posterPath?.absoluteString).to(
                        equal("https://image.tmdb.org/t/p/w500/gZCJZOn4l0Zj5hAxsMbxoS6CL0u.jpg")
                    )
                    expect(movie?.backdropPath?.absoluteString).to(
                        equal("https://image.tmdb.org/t/p/w500/z2QUexmccqrvw1kDMw3R8TxAh5E.jpg")
                    )
                    //swiftlint:disable line_length
                    expect(movie?.overview) == "Taisto Kasurinen is a Finnish coal miner whose father has just committed suicide and who is framed for a crime he did not commit. In jail, he starts to dream about leaving the country and starting a new life. He escapes from prison but things don't go as planned..."
                    expect(movie?.releaseDate) == Calendar.current.date(from: expectedDateComponents)
                    expect(movie?.genres) == expectedGenres
                }
            }

            context("with an invalid id") {
                let requester = NetworkRequestMakerTypeMock()
                requester.makeRequestReturnValue = .error(NetworkError.httpError(404, nil))
                let repository = MovieRepository(networkMaker: requester)

                it("should emit a resourceNotFound error") {
                    let scheduler = TestScheduler(initialClock: 0)
                    let observer = scheduler.record(repository.get(by: 1))
                    scheduler.start()

                    expect(observer.events) == [error(0, DomainError.resourceNotFound)]
                }
            }
        }
    }
}
