import Layout

let defaultLayoutConstants = Font.layoutConstants
    .reduce(into: UIColor.layoutConstants) { (result, element) in result[element.0] = element.1 }
    .reduce(into: ["UIScreen.scale": UIScreen.main.scale]) { (result, element) in result[element.0] = element.1 }

extension LayoutLoading {
    var defaultConstants: LayoutConstants {
        return defaultLayoutConstants
    }

    func loadLayout(_ file: LayoutFile, state: ViewState, constants: LayoutConstants = [:]) {
        loadLayout(named: file.name, bundle: file.bundle, state: state, constants: defaultConstants, constants)
    }
}
