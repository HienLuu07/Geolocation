import SwiftUI
struct OrderView: View {
    @Binding var orders: [Order]
    @State private var selectedStatus: OrderStatus = .pending
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(OrderStatus.allCases) { status in
                        Button {
                            selectedStatus = status
                        } label: {
                            Text(status.rawValue)
                            .font(.subheadline.weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 9)
                            .background(selectedStatus == status ? statusColor(status) : Color(.systemGray5), in: Capsule())
                            .foregroundStyle(selectedStatus == status ? .white : .primary)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            let statusOrders = orders.filter { $0.status == selectedStatus }
            if statusOrders.isEmpty {
                Spacer()
            } else {
                List {
                    ForEach(statusOrders) { order in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Order #\(order.id.uuidString.prefix(8))")
                                    .font(.headline)
                                Spacer()
                                Text(order.status.rawValue)
                                    .font(.caption.bold())
                                    .padding(.horizontal, 9)
                                    .padding(.vertical, 5)
                                    .background(statusColor(order.status).opacity(0.14), in: Capsule())
                                    .foregroundStyle(statusColor(order.status))
                            }
                            ForEach(order.items) { item in
                                HStack {
                                    Text("\(item.quantity) × \(item.product.name)")
                                    Spacer()
                                    Text(item.subtotal, format: .currency(code: "VND").precision(.fractionLength(0)))
                                }
                                .font(.subheadline)
                            }
                            HStack {
                                Text("Total").bold()
                                Spacer()
                                Text(order.total, format: .currency(code: "VND").precision(.fractionLength(0)))
                                    .bold()
                            }
                            .padding(.top, 2)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .listStyle(.plain)
            }
        }
        .onAppear {
            addSampleOrdersIfNeeded()
        }
    }
    private func addSampleOrdersIfNeeded() {
        let products = ProductData.products
        guard orders.isEmpty, products.count >= 6 else { return }
        orders = [
            Order(items: [
                CartItem(product: products[0], quantity: 2),
                CartItem(product: products[1], quantity: 1)
            ], status: .pending),
            Order(items: [
                CartItem(product: products[2], quantity: 1),
                CartItem(product: products[3], quantity: 2)
            ], status: .processing),
            Order(items: [
                CartItem(product: products[4], quantity: 1),
                CartItem(product: products[5], quantity: 1)
            ], status: .shipped)
        ]
    }
    private func statusColor(_ status: OrderStatus) -> Color {
        switch status {
        case .pending: return .orange
        case .processing: return .blue
        case .shipped: return .purple
        case .delivered: return .green
        case .cancelled: return .red
        }
    }
}
