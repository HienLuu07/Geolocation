import SwiftUI
enum ProductCategory: String, CaseIterable, Identifiable {
    case fish = "Fish"
    case plants = "Plants"
    case filters = "Filters"
    case food = "Food"
    case medicine = "Medicine"
    case aquariums = "Aquariums"
    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .fish: return "fish.fill"
        case .plants: return "leaf.fill"
        case .filters: return "line.3.horizontal.decrease.circle.fill"
        case .food: return "fork.knife"
        case .medicine: return "cross.case.fill"
        case .aquariums: return "square.stack.3d.up.fill"
        }
    }
}
