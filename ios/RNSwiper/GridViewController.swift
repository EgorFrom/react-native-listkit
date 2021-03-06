import UIKit
import IGListKit

final class GridViewController: UIViewController {
  // MARK: - Initializers
  
  init(bridge: RCTBridge) {
    self.bridge = bridge
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Properties
  
  let bridge: RCTBridge
  var sections: [Section] = [] {
    didSet {
      adapter.performUpdates(animated: true, completion: nil)
    }
  }
  
  var viewHeight: CGFloat = 274.0
  
  weak var loadingDelegate: GridViewSectionLoadingDelegate?
  
  // MARK: IGListKit
  
  lazy var adapter: ListAdapter = {
    return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
  }()
  
  // MARK: Views
  
  let collectionView: UICollectionView = {
    let layout = GridViewSnappingLayout(
      stickyHeaders: false,
      scrollDirection: .horizontal,
      topContentInset: 0,
      stretchToEdge: true
    )
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .gray
    collectionView.alwaysBounceHorizontal = false
    collectionView.decelerationRate = .fast
    // collectionView.contentInset = HorizontalSectionController.Insets.containerContentInset
    return collectionView
  }()
  
  // MARK: - UIView
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(collectionView)
    if #available(iOS 11.0, *) {
      NSLayoutConstraint.activate([
        collectionView.heightAnchor.constraint(equalToConstant: viewHeight),
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    } else {
      NSLayoutConstraint.activate([
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        collectionView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor),
        collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor)
        ])
    }
    
    adapter.collectionView = collectionView
    adapter.dataSource = self
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    coordinator.animate(alongsideTransition: { _ in
      self.adapter.visibleSectionControllers().forEach { controller in
        controller.collectionContext?.invalidateLayout(for: controller)
      }
    })
  }
}

extension GridViewController: ListAdapterDataSource {
  func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
    return [
      GridViewModel(columns: sections.map { section in
        let viewModel = ColumnViewModel(
          viewController: self,
          identifier: section.identifier,
          imageLink: section.imageLink,
          viewHeight: CGFloat(truncating: NumberFormatter().number(from: section.height) ?? 274)
        )
        return viewModel
      })]
  }
  
  func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
    return GridSectionController()
  }
  
  func emptyView(for listAdapter: ListAdapter) -> UIView? {
    return nil
  }
}
