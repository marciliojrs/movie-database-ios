import RxSwift

func << (left: DisposeBag, right: Disposable) {
    right.disposed(by: left)
}

func << (left: DisposeBag, right: [Disposable]) {
    right.forEach { $0.disposed(by: left) }
}
