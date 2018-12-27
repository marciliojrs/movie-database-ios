import Foundation
import UIKit
import Layout

open class BaseAdapter<T>: NSObject {
    private(set) var items: [T] = []
    var isLoading: Bool = false

    func update(items: [T]) {
        self.items = items
    }
}

public protocol ListViewItemType: class {}
public protocol ListViewType: class {
    var isUserInteractionEnabled: Bool { get set }
    func reloadData()
    //swiftlint:disable function_parameter_count
    func registerLayout(named: String, bundle: Bundle, relativeTo: String, state: Any,
                        constants: [String: Any]..., forCellReuseIdentifier identifier: String)
    //swiftlint:enable function_parameter_count
    func dequeueReusableCellNode(withIdentifier identifier: String, for indexPath: IndexPath) -> LayoutNode
}

extension UITableView: ListViewType {}
extension UITableViewCell: ListViewItemType {}
extension UICollectionView: ListViewType {}
extension UICollectionViewCell: ListViewItemType {}

open class ListBaseAdapter<T>: BaseAdapter<T>, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource,
UITableViewDelegate, UITableViewDataSource {
    private var constants: LayoutConstants {
        return Font.layoutConstants
    }

    private(set) weak var listView: ListViewType?

    open var animateUpdate: Bool { return false }

    override var isLoading: Bool {
        didSet {
            listView?.isUserInteractionEnabled = !isLoading
            listView?.reloadData()
        }
    }

    override func update(items: [T]) {
        super.update(items: items)
        listView?.reloadData()
    }

    open func attach(listView: ListViewType?) {
        self.listView = listView
        (listView as? UITableView)?.dataSource = self
        (listView as? UITableView)?.delegate = self
        (listView as? UICollectionView)?.dataSource = self
        (listView as? UICollectionView)?.delegate = self
    }

    @nonobjc open func numberOfSections(inListView listView: ListViewType) -> Int {
        return 1
    }

    open func listView(_ listView: ListViewType, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    open func listView(_ listView: ListViewType, cellForItemAt indexPath: IndexPath) -> ListViewItemType {
        fatalError("listView(cellForItemAt:indexPath:) has not been implemented")
    }

    open func listView(_ listView: ListViewType, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    open func listView(_ listView: ListViewType, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }

    open func listView(_ listView: ListViewType, didSelectItemAt indexPath: IndexPath) {}

    open func listView(_ listView: ListViewType, swipeToDeleteActionAt indexPath: IndexPath) {}

    // MARK: CollectionView
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listView(collectionView, numberOfItemsInSection: section)
    }

    public func collectionView(_ collectionView: UICollectionView,
                               cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //swiftlint:disable:next force_cast
        return listView(collectionView, cellForItemAt: indexPath) as! UICollectionViewCell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        listView(collectionView, didSelectItemAt: indexPath)
    }

    // MARK: TableView
    public func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections(inListView: tableView)
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listView(tableView, numberOfItemsInSection: section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //swiftlint:disable:next force_cast
        return listView(tableView, cellForItemAt: indexPath) as! UITableViewCell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listView(tableView, didSelectItemAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return listView(tableView, viewForHeaderInSection: section)
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return listView(tableView, heightForHeaderInSection: section)
    }
}
