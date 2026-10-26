import SwiftUI
struct HomeHeaderView: View {
    var onNotificationTap: () -> Void
    var onAddFishTap: () -> Void
    var cartCount: Int
    var onCartTap: () -> Void
    var body: some View {
        HStack(spacing: 14) {
            Image("cc")
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 3) {
                Text("Con Cá")
                    .font(.title2.bold())
                Text("Đi tìm Nemo")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button(action: onAddFishTap) {
                Image(systemName: "plus")
                    .font(.title3)
            }
            .accessibilityLabel("Add Fish")
            Button(action: onNotificationTap) {
                Image(systemName: "bell")
                    .font(.title3)
                    .overlay(alignment: .topTrailing) {
                        Text("3")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                            .frame(width: 17, height: 17)
                            .background(.red, in: Circle())
                            .overlay {
                                Circle().stroke(.white, lineWidth: 1.5)
                            }
                            .offset(x: 8, y: -8)
                    }
            }
            .accessibilityLabel("Notifications, 3 unread")
            Button(action: onCartTap) {
                Image(systemName: "cart")
                    .font(.title3)
                    .overlay(alignment: .topTrailing) {
                        if cartCount > 0 {
                            Text("\(cartCount)")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundStyle(.white)
                                .frame(width: 17, height: 17)
                                .background(.red, in: Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 1.5)
                                }
                                .offset(x: 8, y: -8)
                        }
                    }
            }
            .accessibilityLabel("Shopping cart, \(cartCount) items")
        }
        .buttonStyle(.plain)
        .tint(.blue)
    }
}
