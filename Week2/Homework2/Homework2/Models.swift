import Foundation
import CoreLocation
import Combine
class Restaurant: Identifiable {
    let id = UUID()
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var type: String
    static let types = [
        "Noodles",
        "Fast Food",
        "Drink",
        "Hot Pot",
        "BBQ",
        "Sushi",
        "Vegetarian",
        "Bakery",
        "Desserts",
        "Other"
    ]
    static func icon(for type: String) -> String {
        switch type {
        case "Noodles": return "fork.knife"
        case "Fast Food": return "takeoutbag.and.cup.and.straw"
        case "Drink": return "cup.and.saucer.fill"
        case "Hot Pot": return "flame.fill"
        case "BBQ": return "flame"
        case "Sushi": return "fish.fill"
        case "Vegetarian": return "leaf.fill"
        case "Bakery": return "birthday.cake.fill"
        case "Desserts": return "birthday.cake"
        default: return "storefront.fill"
        }
    }
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
    init(
        name: String,
        address: String,
        latitude: Double,
        longitude: Double,
        type: String = "Other"
    ) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.type = type
    }
}
class Order: ObservableObject, Identifiable {
    let id = UUID()
    var restaurant: Restaurant
    @Published var customerName: String
    var customerAddress: String
    var customerLatitude: Double
    var customerLongitude: Double
    @Published var status: String
    var customerCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: customerLatitude,
            longitude: customerLongitude
        )
    }
    init(
        customerName: String,
        restaurant: Restaurant,
        customerAddress: String,
        customerLatitude: Double,
        customerLongitude: Double,
        status: String = "Pending"
    ) {
        self.customerName = customerName
        self.restaurant = restaurant
        self.customerAddress = customerAddress
        self.customerLatitude = customerLatitude
        self.customerLongitude = customerLongitude
        self.status = status
    }
}
