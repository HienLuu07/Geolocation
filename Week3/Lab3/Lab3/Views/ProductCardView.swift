import SwiftUI
struct ProductCardView: View {
    let product: Product
    var onFavorite: () -> Void
    var onAddToCart: () -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            GeometryReader { geometry in
                Image(product.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 140)
                    .clipped()
            }
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            Text(product.name)
                .font(.subheadline.bold())
                .lineLimit(2)
                .frame(height: 40, alignment: .topLeading)
            HStack(spacing: 8) {
                Text(product.price, format: .currency(code: "VND").precision(.fractionLength(0)))
                    .font(.subheadline.bold())
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
                Spacer(minLength: 0)
                Button(action: onFavorite) {
                    Image(systemName: product.isFavorite ? "heart.fill" : "heart")
                        .font(.subheadline.bold())
                        .foregroundStyle(product.isFavorite ? .pink : .primary)
                        .frame(width: 32, height: 32)
                }
                .buttonStyle(.plain)
                Button(action: onAddToCart) {
                    Image(systemName: "plus")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                        .background(.blue, in: Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity)
        .frame(height: 245)
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        }
    }
}
