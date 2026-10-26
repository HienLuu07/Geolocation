import SwiftUI
struct CategoryDetailView: View {
    let category: ProductCategory
    @Binding var products: [Product]
    @Binding var cartItems: [CartItem]
    var onAddedToCart: (Product) -> Void
    var onSaveProducts: () -> Void
    @State private var isEditing = false
    var body: some View {
        let categoryProducts = products.filter { $0.category == category }
        ScrollView {
            if !categoryProducts.isEmpty {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                    ForEach(categoryProducts) { product in
                        ZStack(alignment: .topTrailing) {
                            ProductCardView(product: product, onFavorite: {
                                if let index = products.firstIndex(where: { $0.id == product.id }) {
                                    products[index].isFavorite.toggle()
                                }
                            }, onAddToCart: {
                                onAddedToCart(product)
                            })
                            if isEditing {
                                Button(role: .destructive) {
                                    products.removeAll { $0.id == product.id }
                                    onSaveProducts()
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.subheadline.bold())
                                        .foregroundStyle(.white)
                                        .frame(width: 30, height: 30)
                                        .background(.red, in: Circle())
                                }
                                .buttonStyle(.plain)
                                .padding(8)
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .navigationTitle(category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(isEditing ? "Done" : "Edit") {
                    isEditing.toggle()
                }
            }
        }
    }
}
