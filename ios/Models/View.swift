struct View {
  let height: String
  let index: Int
  
  init(index: Int, json: JSON) {
    guard let height = json["height"] as? String
      else { fatalError("Invalid section type") }
    self.height = height
    self.index = index
  }
}
