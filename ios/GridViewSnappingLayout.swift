import UIKit
import IGListKit

class GridViewSnappingLayout: ListCollectionViewLayout {
  enum ItemEdge {
    case left
    case right
  }

  private var currentOffsetX: CGFloat = 0.0

  private func alignmentEdge(for contentOffset: CGPoint) -> ItemEdge {
    guard let collectionView = collectionView else { return .left }
    let viewportRect = CGRect(origin: contentOffset, size: collectionView.bounds.size)
    return viewportRect.maxX >= collectionView.contentSize.width ? .right : .left
  }

  private func targetOffset(for proposedOffset: CGPoint, velocity: CGPoint? = nil) -> CGPoint {
    guard let collectionView = collectionView else { return proposedOffset }

    // This handles when a user does a short, but quick swipe. Without adjusting the proposed offset,
    // the UICollectionView does not animate to the targetOffset, resulting in a jarring snapping to the
    // new offset. By pushing the proposed offset further in the direction of the velocity, the result
    // is that UIKit properly animates to our new targetOffset.
    let interpolatedOffset: CGPoint
    let flickVelocity: CGFloat = 0.334
    let pageSize = layoutAttributesForItem(at: IndexPath(item: 0, section: 0))?.bounds.width ?? 0
    switch velocity {
    case .some(let velocity) where velocity.x < -flickVelocity:
      let xOffset = max(proposedOffset.x, collectionView.contentOffset.x - pageSize)
//      print("egor xOffset_1", xOffset)
      interpolatedOffset = CGPoint(x: xOffset, y: 0)
    case .some(let velocity) where velocity.x > flickVelocity:
      let xOffset = min(proposedOffset.x, collectionView.contentOffset.x + pageSize)
//      print("egor xOffset_2", xOffset)
      interpolatedOffset = CGPoint(x: xOffset, y: 0)
    default:
      interpolatedOffset = proposedOffset
    }

    let viewportRect = CGRect(origin: interpolatedOffset, size: collectionView.bounds.size)
    let itemAlignmentEdge = alignmentEdge(for: interpolatedOffset)
    let distance: (UICollectionViewLayoutAttributes) -> CGFloat
    switch itemAlignmentEdge {
    case .left:
      distance = { attributes in
        abs(attributes.frame.minX - viewportRect.minX)
      }
    case .right:
      distance = { attributes in
        abs(attributes.frame.maxX - viewportRect.maxX)
      }
    }

    guard let attributesForSnapItem = layoutAttributesForElements(in: viewportRect)?
      .lazy
      .filter({ $0.representedElementCategory == .cell })
      .sorted(by: { distance($0) < distance($1) })
      .first
      else {
//        print("egor else interpolatedOffset", interpolatedOffset)
        return interpolatedOffset
      }
//    print("egor attributesForSnapItem", attributesForSnapItem)
    switch itemAlignmentEdge {
    case .left:
      print("it is exit")
      currentOffsetX = attributesForSnapItem.frame.minX - collectionView.contentInset.left
      return CGPoint(
        x: attributesForSnapItem.frame.minX - collectionView.contentInset.left,
        y: interpolatedOffset.y
      )
    case .right:
      currentOffsetX = attributesForSnapItem.frame.maxX - viewportRect.width + collectionView.contentInset.right
      return CGPoint(
        x: attributesForSnapItem.frame.maxX - viewportRect.width + collectionView.contentInset.right,
        y: interpolatedOffset.y
      )
    }
  }
  
  private func gainConstant(proposedPoint: CGPoint) -> CGPoint {
    if (currentOffsetX - proposedPoint.x < 0) {
      return CGPoint(x: (proposedPoint.x + UIScreen.main.bounds.width / 2), y: proposedPoint.y)
    } else {
      return CGPoint(x: (proposedPoint.x - UIScreen.main.bounds.width / 2), y: proposedPoint.y)
    }
  }

  override func targetContentOffset(
    forProposedContentOffset proposedContentOffset: CGPoint
  ) -> CGPoint {
    let proposedPoint = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
//    print("egor currentOffsetX", currentOffsetX)
//    print("egor proposedPoint", proposedPoint)
//    print("egor targetOffset", targetOffset(for: proposedPoint))
    return targetOffset(for: gainConstant(proposedPoint: proposedPoint))
  }

  override func targetContentOffset(
    forProposedContentOffset proposedContentOffset: CGPoint,
    withScrollingVelocity velocity: CGPoint
  ) -> CGPoint {
    let proposedPoint = super.targetContentOffset(
      forProposedContentOffset: proposedContentOffset,
      withScrollingVelocity: velocity
    )
//    print("egor currentOffsetX", currentOffsetX)
//    print("egor velocity", velocity, "proposedPoint", proposedPoint)
//    print("egor targetOffset", targetOffset(for: proposedPoint, velocity: velocity))
    return targetOffset(for: gainConstant(proposedPoint: proposedPoint), velocity: CGPoint(x: CGFloat(Double(velocity.x) * 1.5), y: velocity.y))
  }
}
