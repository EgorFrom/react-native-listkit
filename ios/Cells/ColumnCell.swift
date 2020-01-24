import UIKit
import IGListKit
import SDWebImage

final class ColumnCell: UICollectionViewCell, CellReusable {
  let collectionView: UICollectionView
  let image = UIImageView(frame: .zero)
  private let activityIndicator = UIActivityIndicatorView()

  override func prepareForReuse() {
    super.prepareForReuse()
    collectionView.contentOffset = .zero
    collectionView.dataSource = nil
    collectionView.delegate = nil
    image.image = nil
  }

  // MARK: - Initializers

  override init(frame: CGRect) {
    collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())

    super.init(frame: frame)

    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.alwaysBounceVertical = false
    contentView.addSubview(collectionView)

    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleToFill
    contentView.addSubview(image)

    backgroundColor = .white

    NSLayoutConstraint.activate([
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UICollectionViewCell

//  override func preferredLayoutAttributesFitting(
//    _ layoutAttributes: UICollectionViewLayoutAttributes
//  ) -> UICollectionViewLayoutAttributes {
//    setNeedsLayout()
//    layoutIfNeeded()
//    let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
//    var newFrame = layoutAttributes.frame
////    newFrame.size.height = ceil(size.height)
//    layoutAttributes.frame = newFrame
//    print("layoutAttributes", layoutAttributes)
//    return layoutAttributes
//  }
}

extension ColumnCell: ListBindable {
  func bindViewModel(_ viewModel: Any) {
    guard let viewModel = viewModel as? ColumnViewModel else { fatalError() }
    print("imageLink", viewModel.imageLink)

    image.sd_setImage(with: URL(string: viewModel.imageLink), placeholderImage: UIImage(named: "first"))

    let newImage: UIImage = image.image?.resized(toWidth: UIScreen.main.bounds.width, toHeight: viewModel.viewHeight) ?? UIImage(named: "first")!
    print("what it is", newImage.size)

    let transformer = SDImageResizingTransformer(size: newImage.size, scaleMode: .fill)
    image.sd_setImage(with: URL(string: viewModel.imageLink), placeholderImage: nil, context: [.imageTransformer: transformer])

    print("viewModelviewModel", viewModel)
    print("collectionViewcollectionView1", collectionView.numberOfItems(inSection: 0))
    print("collectionViewcollectionView2", collectionView.numberOfSections)
    viewModel.adapter.collectionView = collectionView
  }
}

extension UIImage {
  func resized(toWidth width: CGFloat, toHeight height: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
