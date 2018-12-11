import RxSwift

public protocol MovieRepository: AutoMockable {
    func upcoming(page: Int) -> Observable<PaginatedMovieWrapper>
    func get(by id: Identity) -> Observable<Movie>
    func search(query: String, page: Int) -> Observable<PaginatedMovieWrapper>
}
