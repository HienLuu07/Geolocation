import SwiftUI
struct EditOrderView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var order: Order
    @State private var restaurantName: String
    @State private var restaurantAddress: String
    @State private var restaurantLatitude: String
    @State private var restaurantLongitude: String
    @State private var customerName: String
    @State private var customerAddress: String
    @State private var customerLatitude: String
    @State private var customerLongitude: String
    init(order: Order) {
        self.order = order
        _restaurantName = State(initialValue: order.restaurant.name)
        _restaurantAddress = State(initialValue: order.restaurant.address)
        _restaurantLatitude = State(initialValue: String(order.restaurant.latitude))
        _restaurantLongitude = State(initialValue: String(order.restaurant.longitude))
        _customerName = State(initialValue: order.customerName)
        _customerAddress = State(initialValue: order.customerAddress)
        _customerLatitude = State(initialValue: String(order.customerLatitude))
        _customerLongitude = State(initialValue: String(order.customerLongitude))
    }
    private var canSave: Bool {
        !restaurantName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !restaurantAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        !customerName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !customerAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        validCoordinates(restaurantLatitude, restaurantLongitude) &&
        validCoordinates(customerLatitude, customerLongitude)
    }
    private func validCoordinates(_ latitude: String, _ longitude: String) -> Bool {
        guard let lat = Double(latitude), let lon = Double(longitude) else {
            return false
        }
        return (-90...90).contains(lat) && (-180...180).contains(lon)
    }
    var body: some View {
        Form {
            Section("Restaurant Information") {
                TextField("Restaurant Name", text: $restaurantName)
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
            Button("Save Changes") {
                guard let rLat = Double(restaurantLatitude),
                      let rLon = Double(restaurantLongitude),
                      let cLat = Double(customerLatitude),
                      let cLon = Double(customerLongitude) else {
                    return
                }
                order.restaurant.name = restaurantName
                order.restaurant.address = restaurantAddress
                order.restaurant.latitude = rLat
                order.restaurant.longitude = rLon
                order.customerName = customerName
                order.customerAddress = customerAddress
                order.customerLatitude = cLat
                order.customerLongitude = cLon
                dismiss()
            }
            .disabled(!canSave)
        }
        .navigationTitle("Edit Order")
        .navigationBarTitleDisplayMode(.inline)
    }
}
