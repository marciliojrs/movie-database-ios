protocol ViewModelController {
    associatedtype ViewModel

    var viewModel: ViewModel { get }
    init(viewModel: ViewModel)
}
