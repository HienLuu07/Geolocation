import Foundation
struct Order: Identifiable {
    let id: UUID
    let date: Date
    var items: [CartItem]
    var status: OrderStatus
    init(
        id: UUID = UUID(),
        date: Date = Date(),
        items: [CartItem],
        status: OrderStatus = .pending
    ) {
        self.id = id
        self.date = date
        self.items = items
        self.status = status
    }
    var total: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
}
