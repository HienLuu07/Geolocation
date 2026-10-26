import SwiftUI
struct CategoryDetailView: View {
    let category: ProductCategory
    @Binding var products: [Product]
    @Binding var cartItems: [CartItem]
    var onAddedToCart: (Product) -> Void
    var body: some View {
        let categoryProducts = products.filter { $0.category == category }
        ScrollView {
            if !categoryProducts.isEmpty {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(categoryProducts) { product in
                        ProductCardView(product: product, onFavorite: {
                            if let index = products.firstIndex(where: { $0.id == product.id }) {
                                products[index].isFavorite.toggle()
                            }
                        }, onAddToCart: {
                            onAddedToCart(product)
                        })
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
