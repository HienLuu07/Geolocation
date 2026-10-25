import SwiftUI
struct BannerView: View {
    @State private var currentPage = 0
    private let banners = ["Banner 1", "Banner 2", "Banner 3"]
    private let cornerRadius: CGFloat = 22
    var body: some View {
        VStack(spacing: 8) {
            TabView(selection: $currentPage) {
                ForEach(Array(banners.enumerated()), id: \.offset) { index, banner in
                    Image(banner)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 175)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 175)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            HStack(spacing: 7) {
                ForEach(0..<banners.count, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.blue : Color.gray.opacity(0.35))
                        .frame(width: currentPage == index ? 9 : 7, height: currentPage == index ? 9 : 7)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: currentPage)
        }
    }
}
