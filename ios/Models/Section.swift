struct Section {
  let identifier: String
  let imageLink: String
  let height: String
  let index: Int

  init(index: Int, json: JSON) {
    guard let identifier = json["id"] as? String,
      let imageLink = json["imageLink"] as? String,
      let height = json["height"] as? String
      else { fatalError("Invalid section type") }
    self.identifier = identifier
    self.imageLink = imageLink
    self.index = index
    self.height = height
  }
}
