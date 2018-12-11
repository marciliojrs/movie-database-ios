@testable import Domain
import Fakery

let faker = Faker()

private let imageBasePath = "https://image.tmdb.org/t/p/w500"

extension Movie: Randomizable {
    static var random: Movie {
        return Movie(id: faker.number.randomInt(),
                     title: faker.lorem.words(),
                     posterPath: URL(string: imageBasePath + "/" + faker.lorem.characters(amount: 15)),
                     backdropPath: URL(string: imageBasePath + "/" + faker.lorem.characters(amount: 15)),
                     overview: faker.lorem.paragraphs(),
                     releaseDate: faker.business.creditCardExpiryDate()!,
                     genres: Genre.randomArray)
    }
}

extension Genre: Randomizable {
    static var random: Genre {
        return Genre(id: faker.number.randomInt(), name: faker.lorem.word())
    }
}

protocol Randomizable {
    static var random: Self { get }
    static var randomArray: [Self] { get }
}

extension Randomizable {
    static var randomArray: [Self] {
        let randomSize = Int.random(in: 1...20)
        return (1 ..< randomSize).map { _ in .random }
    }
}
