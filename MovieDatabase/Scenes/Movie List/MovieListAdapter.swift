import Domain
import RxSwift
import RxCocoa

final class MovieListAdapter: ListBaseAdapter<MovieListItemViewModel> {
    fileprivate let itemSelected = PublishSubject<MovieListItemViewModel>()
    private let bag = DisposeBag()

    override func attach(listView: ListViewType?) {
        super.attach(listView: listView)

        MovieListItemCell.registerIntoList(listView,
                                           state: ["imageUrl": nil,
                                                   "title": "",
                                                   "releaseDate": ""],
                                           reuseIdentifier: "MovieListItemCell")
    }

    override func listView(_ listView: ListViewType, cellForItemAt indexPath: IndexPath) -> ListViewItemType {
        let node = listView.dequeueReusableCellNode(withIdentifier: "MovieListItemCell", for: indexPath)
        //swiftlint:disable:next force_cast
        let cell = node.view as! MovieListItemCell

        let movie = items[indexPath.row]
        cell.setupHeroConstraints(for: movie.id)
        node.setState(["imageUrl": movie.backdropPath as Any,
                       "title": movie.title,
                       "releaseDate": movie.releaseDate])

        return cell
    }

    override func listView(_ listView: ListViewType, didSelectItemAt indexPath: IndexPath) {
        let movie = items[indexPath.row]
        itemSelected.on(.next(movie))
    }
}

extension Reactive where Base: MovieListAdapter {
    var updateItems: Binder<[MovieListItemViewModel]> {
        return Binder(self.base) { (target: MovieListAdapter, value: [MovieListItemViewModel]) in
            target.update(items: value)
        }
    }

    var itemSelected: Observable<MovieListItemViewModel> {
        return self.base.itemSelected
    }
}
