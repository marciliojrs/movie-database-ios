import RxSwift
import Domain

protocol MovieRepositoryType: Domain.MovieRepository, AutoRequestable {
    var networkMaker: NetworkRequestMakerType! { get }

    //sourcery: method="get"
    //sourcery: path="3/movie/upcoming"
    //sourcery: queryString=["api_key": "1f54bd990f1cdfb230adb312546d765d", "page": "\(page)"]
    //sourcery: responseType=RestApiProvider.PaginatedMovieWrapper
    //sourcery: domainMapping
    func upcoming(page: Int) -> Observable<Domain.PaginatedMovieWrapper>

    //sourcery: method="get"
    //sourcery: path="3/movie/\(id)"
    //sourcery: queryString=["api_key": "1f54bd990f1cdfb230adb312546d765d"]
    //sourcery: responseType=RestApiProvider.Movie
    //sourcery: domainMapping
    //sourcery: keyPath="results"
    func get(by id: Identity) -> Observable<Domain.Movie>

    //sourcery: method="get"
    //sourcery: path="3/search/movie"
    //sourcery: queryString=["api_key": "1f54bd990f1cdfb230adb312546d765d", "page": "\(page)", "query": query]
    //sourcery: responseType=RestApiProvider.PaginatedMovieWrapper
    //sourcery: domainMapping
    func search(query: String, page: Int) -> Observable<Domain.PaginatedMovieWrapper>
}
