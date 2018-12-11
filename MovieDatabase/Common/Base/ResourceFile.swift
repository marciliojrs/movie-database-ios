import Layout
import Rswift

protocol LayoutFile {
    var name: String { get }
    var bundle: Bundle { get }
}

extension FileResource: LayoutFile {}
