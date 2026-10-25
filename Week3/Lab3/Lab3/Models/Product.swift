import Foundation

struct Product: Identifiable {
    let id: UUID
    var name: String
    var price: Double
    var imageName: String
    var category: ProductCategory
    var isFavorite: Bool
    init(id: UUID = UUID(), name: String, price: Double, imageName: String, category: ProductCategory, isFavorite: Bool = false) {
        self.id = id
        self.name = name
        self.price = price
        self.imageName = imageName
        self.category = category
        self.isFavorite = isFavorite
    }
}
