import SwiftUI
struct AddOrderView: View {
    @Environment(\.dismiss) var dismiss
    @State private var restaurantType = "Other"
    @State private var restaurantName = ""
    @State private var restaurantAddress = ""
    @State private var restaurantLatitude = ""
    @State private var restaurantLongitude = ""
    @State private var customerName = ""
    @State private var customerAddress = ""
    @State private var customerLatitude = ""
    @State private var customerLongitude = ""
    let onSave: (Order) -> Void
    var canSave: Bool {
        !restaurantName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !restaurantAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        !customerName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !customerAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        validCoordinates(restaurantLatitude, restaurantLongitude) &&
        validCoordinates(customerLatitude, customerLongitude)
    }
    func validCoordinates(_ latitude: String, _ longitude: String) -> Bool {
        guard let lat = Double(latitude),
              let lon = Double(longitude) else {
            return false
        }
        return (-90...90).contains(lat) &&
               (-180...180).contains(lon)
    }
    var body: some View {
        Form {
            Section("Restaurant Information") {
                TextField("Restaurant Name", text: $restaurantName)
                Picker("Restaurant Type", selection: $restaurantType) {
                    ForEach(Restaurant.types, id: \.self) { type in
                        Label(type, systemImage: Restaurant.icon(for: type))
                            .tag(type)
                    }
                }
                TextField("Restaurant Address", text: $restaurantAddress)
                TextField("Latitude", text: $restaurantLatitude)
                    .keyboardType(.decimalPad)
                TextField("Longitude", text: $restaurantLongitude)
                    .keyboardType(.decimalPad)
            }
            Section("Customer Information") {
                TextField("Customer Name", text: $customerName)
                TextField("Delivery Address", text: $customerAddress)
                TextField("Latitude", text: $customerLatitude)
                    .keyboardType(.decimalPad)
                TextField("Longitude", text: $customerLongitude)
                    .keyboardType(.decimalPad)
            }
            Button("Save Order") {
                guard let rLat = Double(restaurantLatitude),
                      let rLon = Double(restaurantLongitude),
                      let cLat = Double(customerLatitude),
                      let cLon = Double(customerLongitude) else {
                    return
                }
                let restaurant = Restaurant(
                    name: restaurantName,
                    address: restaurantAddress,
                    latitude: rLat,
                    longitude: rLon,
                    type: restaurantType
                )
                let order = Order(
                    customerName: customerName,
                    restaurant: restaurant,
                    customerAddress: customerAddress,
                    customerLatitude: cLat,
                    customerLongitude: cLon
                )
                onSave(order)
                dismiss()
            }
            .disabled(!canSave)
        }
        .navigationTitle("Add Order")
    }
}
