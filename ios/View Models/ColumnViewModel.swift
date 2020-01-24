import IGListKit

final class ColumnViewModel: NSObject, ListDiffable {
  let identifier: String
  let adapter: ListAdapter
  let imageLink: String
  let viewHeight: CGFloat

//  weak var loadingDelegate: GridViewSectionLoadingDelegate?

  init(viewController: UIViewController, identifier: String, imageLink: String, viewHeight: CGFloat) {
    self.identifier = identifier
    self.imageLink = imageLink
    self.viewHeight = viewHeight

    self.adapter = ListAdapter(
      updater: ListAdapterUpdater(),
      viewController: viewController,
      workingRangeSize: 20
    )

    super.init()

    // This also feels... odd...
//    adapter.dataSource = self
//    adapter.scrollViewDelegate = self
  }

  func diffIdentifier() -> NSObjectProtocol {
    return identifier as NSObject
  }

  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? ColumnViewModel else { return false }
    return imageLink == object.imageLink
  }
}

//extension ColumnViewModel: ListAdapterDataSource {
//  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//    // TODO: this feels.... wrong...
//    return [self]
//  }
//
//  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
//    return ColumnSectionController()
//  }
//
//  func emptyView(for listAdapter: ListAdapter) -> UIView? {
//    return nil
//  }
//}

//extension ColumnViewModel: UIScrollViewDelegate {
//  func scrollViewWillEndDragging(
//    _ scrollView: UIScrollView,
//    withVelocity velocity: CGPoint,
//    targetContentOffset: UnsafeMutablePointer<CGPoint>
//  ) {
//    guard let delegate = loadingDelegate else { return }
//    let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
//    if distance < 200 {
//      delegate.gridViewWillReachEndOfSection(with: identifier)
//    }
//  }
//}
