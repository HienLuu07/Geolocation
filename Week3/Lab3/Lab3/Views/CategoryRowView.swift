import SwiftUI
struct CategoryRowView: View {
    var selectedCategory: ProductCategory?
    var onSelect: (ProductCategory?) -> Void
    var isGrid = false
    @Binding var products: [Product]
    @Binding var cartItems: [CartItem]
    var onAddedToCart: (Product) -> Void
    private let columns = [GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        if isGrid {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(ProductCategory.allCases) { category in
                    categoryButton(category)
                }
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ProductCategory.allCases) { category in
                        categoryButton(category)
                            .frame(width: 105, height: 105)
                    }
                }
            }
        }
    }
    private func categoryButton(_ category: ProductCategory) -> some View {
        return NavigationLink {
            CategoryDetailView(category: category, products: $products, cartItems: $cartItems, onAddedToCart: onAddedToCart)
        } label: {
            VStack(spacing: 10) {
                Image(systemName: category.symbol)
                    .font(.system(size: 28))
                    .foregroundStyle(.black)
                Text(category.rawValue)
                    .font(.caption.weight(.medium))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(categoryColor(category))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
    private func categoryColor(_ category: ProductCategory) -> Color {
        switch category {
        case .fish: return Color.orange.opacity(0.15)
        case .plants: return Color.green.opacity(0.15)
        case .filters: return Color.blue.opacity(0.15)
        case .food: return Color(red: 1.0, green: 0.88, blue: 0.75)
        case .medicine: return Color.red.opacity(0.12)
        case .aquariums: return Color.cyan.opacity(0.15)
        }
    }
}
