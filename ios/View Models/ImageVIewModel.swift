import UIKit
import IGListKit

final class ImageViewModel {
  let url: String
  let bridge: RCTBridge
  
  init(bridge: RCTBridge, url: String) {
    self.bridge = bridge
    self.url = url
  }
}

extension ImageViewModel: Equatable {
  static func == (lhs: ImageViewModel, rhs: ImageViewModel) -> Bool {
    return lhs.url == rhs.url
  }
}

extension ImageViewModel: ListDiffable {
  func diffIdentifier() -> NSObjectProtocol {
    return url as NSObject
  }
  
  func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
    guard let object = object as? ImageViewModel else { return false }
    return self == object
  }
}
