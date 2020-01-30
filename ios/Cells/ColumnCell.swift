import UIKit
import IGListKit
import SDWebImage

final class ColumnCell: UICollectionViewCell, CellReusable {
  let collectionView: UICollectionView
  let imageView = UIImageView(frame: .zero)
  private let activityIndicator = UIActivityIndicatorView()

  override func prepareForReuse() {
    super.prepareForReuse()
    activityIndicator.startAnimating()
    collectionView.contentOffset = .zero
    collectionView.dataSource = nil
    collectionView.delegate = nil
    imageView.image = nil
  }

  // MARK: - Initializers

  override init(frame: CGRect) {
    collectionView = UICollectionView(frame: frame, collectionViewLayout: UICollectionViewFlowLayout())

    super.init(frame: frame)

    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.alwaysBounceVertical = false
    contentView.addSubview(collectionView)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    activityIndicator.startAnimating()
    contentView.addSubview(activityIndicator)
    activityIndicator.color = .red

    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageTapped)))

    imageView.contentMode = .scaleToFill
    contentView.addSubview(imageView)

    backgroundColor = .white

    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
      collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    ])
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  @objc private func imageTapped(_ recognizer: UITapGestureRecognizer) {
    EventEmitter.sharedInstance.dispatch(name: "OpenImage", body: 1)
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

    imageView.sd_setImage(
      with: URL(string: viewModel.imageLink),
      placeholderImage: nil,
      options: SDWebImageOptions(rawValue: 0),
      completed: { (image, error, cacheType, imageURL) in
        
        guard let image = image else { return }
        self.imageView.image = image.resized(toWidth: UIScreen.main.bounds.width, toHeight: viewModel.viewHeight)
    }
    )

//    let newImage: UIImage = image.image?.resized(toWidth: UIScreen.main.bounds.width, toHeight: viewModel.viewHeight) ?? UIImage(named: "first")!

//    let transformer = SDImageResizingTransformer(size: newImage.size, scaleMode: .fill)
//    image.sd_setImage(with: URL(string: viewModel.imageLink), placeholderImage: nil, context: [.imageTransformer: transformer])

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
