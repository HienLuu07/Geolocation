import Foundation
struct CartItem: Identifiable {
    var id: UUID { product.id }
    var product: Product
    var quantity: Int
    var subtotal: Double {
        product.price * Double(quantity)
    }
}
