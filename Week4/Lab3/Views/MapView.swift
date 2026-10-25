import SwiftUI
import MapKit
import CoreLocation
struct MapView: View {
    @Binding var recipientName: String
    @Binding var deliveryAddress: String
    @Binding var deliveryLatitude: Double
    @Binding var deliveryLongitude: Double
    @State private var route: MKRoute?
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var routeError = false
    // Shop: Saigon Centre
    private let storeLocation = CLLocationCoordinate2D(
        latitude: 10.7725,
        longitude: 106.7009
    )
    // Delivery location
    private var deliveryLocation: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: deliveryLatitude,
            longitude: deliveryLongitude
        )
    }
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Map(position: $cameraPosition) {
                    Annotation("Con Cá", coordinate: storeLocation) {
                        Image(systemName: "storefront.fill")
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.orange)
                            .clipShape(Circle())
                    }
                    Annotation("", coordinate: deliveryLocation) {
                        Image(systemName: "house.fill")
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.blue)
                            .clipShape(Circle())
                    }
                    if let route {
                        MapPolyline(route.polyline)
                            .stroke(.blue, lineWidth: 5)
                    }
                }
                .frame(height: 400)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .mapControls {
                    MapCompass()
                    MapScaleView()
                }
                Label("From: Con Cá", systemImage: "storefront.fill")
                    .foregroundStyle(.orange)
                Text("65 Lê Lợi, HCMC")
                Label("To: \(recipientName)", systemImage: "house.fill")
                    .foregroundStyle(.blue)
                Text(deliveryAddress)
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
                    Text("Unable to calculate route.")
                        .foregroundStyle(.red)
                } else {
                    ProgressView("Calculating route...")
                }
            }
            .padding()
        }
        .navigationTitle("Shipping")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await calculateRoute()
        }
        .onChange(of: deliveryLatitude) {
            recalculateRoute()
        }
        .onChange(of: deliveryLongitude) {
            recalculateRoute()
        }
    }
    private func recalculateRoute() {
        route = nil
        routeError = false
        Task {
            await calculateRoute()
        }
    }
    @MainActor
    private func calculateRoute() async {
        let request = MKDirections.Request()
        request.source = MKMapItem(
            location: CLLocation(
                latitude: storeLocation.latitude,
                longitude: storeLocation.longitude
            ),
            address: nil
        )
        request.destination = MKMapItem(
            location: CLLocation(
                latitude: deliveryLocation.latitude,
                longitude: deliveryLocation.longitude
            ),
            address: nil
        )
        request.transportType = .automobile
        do {
            let response = try await MKDirections(request: request).calculate()
            guard let firstRoute = response.routes.first else {
                routeError = true
                return
            }
            route = firstRoute
            cameraPosition = .rect(firstRoute.polyline.boundingMapRect)
        } catch {
            routeError = true
        }
    }
}
