import SwiftUI
import MapKit
import CoreLocation
struct OrderDetailView: View {
    @ObservedObject var order: Order
    let onUpdateStatus: (String) -> Void
    @State private var route: MKRoute?
    @State private var position: MapCameraPosition = .automatic
    @State private var routeError = false
    init(order: Order, onUpdateStatus: @escaping (String) -> Void) {
        self.order = order
        self.onUpdateStatus = onUpdateStatus
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Map(position: $position) {
                    Annotation(
                        order.restaurant.name,
                        coordinate: order.restaurant.coordinate
                    ) {
                        Image(systemName: Restaurant.icon(for: order.restaurant.type))
                            .font(.title2)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.orange)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    Annotation(
                        order.customerName,
                        coordinate: order.customerCoordinate
                    ) {
                        Image(systemName: "house.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.blue)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    if let route {
                        MapPolyline(route.polyline)
                            .stroke(.blue, lineWidth: 5)
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                Label("From: \(order.restaurant.name)", systemImage: "storefront.fill")
                    .foregroundStyle(.orange)
                Text(order.restaurant.address)
                    .foregroundStyle(.secondary)
                Label("To: \(order.customerName)", systemImage: "house.fill")
                    .foregroundStyle(.blue)
                Text(order.customerAddress)
                    .foregroundStyle(.secondary)
                Group {
                    if let route {
                        Text(
                            String(
                                format: "Distance: %.2f km (%.0f min)",
                                route.distance / 1000,
                                route.expectedTravelTime / 60
                            )
                        )
                        .fontWeight(.semibold)
                    } else if routeError {
                        Text("Distance: Unable to calculate route")
                            .foregroundStyle(.red)
                    } else {
                        ProgressView("Calculating distance...")
                    }
                }
                Picker("Status", selection: $order.status) {
                    Text("Pending").tag("Pending")
                    Text("In Transit").tag("In Transit")
                    Text("Delivered").tag("Delivered")
                }
                .pickerStyle(.segmented)
                .pickerStyle(.segmented)
                .onChange(of: order.status) { _, newValue in
                    onUpdateStatus(newValue)
                }
            }
            .padding()
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    EditOrderView(order: order)
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        .task {
            await calculateRoute()
        }
    }
    @MainActor
    private func calculateRoute() async {
        let request = MKDirections.Request()
        request.source = MKMapItem(
            location: CLLocation(
                latitude: order.restaurant.latitude,
                longitude: order.restaurant.longitude
            ),
            address: nil
        )
        request.destination = MKMapItem(
            location: CLLocation(
                latitude: order.customerLatitude,
                longitude: order.customerLongitude
            ),
            address: nil
        )
        request.transportType = .automobile
        do {
            let response = try await MKDirections(
                request: request
            ).calculate()
            guard let firstRoute = response.routes.first else {
                routeError = true
                return
            }
            route = firstRoute
            position = .rect(firstRoute.polyline.boundingMapRect)
        } catch {
            routeError = true
        }
    }
}
