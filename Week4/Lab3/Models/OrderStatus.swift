import Foundation
enum OrderStatus: String, CaseIterable, Identifiable {
    case pending = "Pending"
    case processing = "Processing"
    case shipped = "Shipped"
    case delivered = "Delivered"
    case cancelled = "Cancelled"
    var id: String { rawValue }
}
