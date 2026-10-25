import SwiftUI
import MapKit
import CoreLocation
struct AllOrdersMapView: View {
    let orders: [Order]
    @State private var cameraPosition: MapCameraPosition = .automatic
    var body: some View {
        Map(position: $cameraPosition) {
            ForEach(orders) { order in
                Annotation(
                    order.restaurant.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: order.restaurant.latitude,
                        longitude: order.restaurant.longitude
                    ),
                    anchor: .bottom
                ) {
                    Image(systemName: Restaurant.icon(for: order.restaurant.type))
                        .font(.title2)
                        .foregroundStyle(.orange)
                        .padding(8)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
                Annotation(
                    order.customerName,
                    coordinate: CLLocationCoordinate2D(
                        latitude: order.customerLatitude,
                        longitude: order.customerLongitude
                    ),
                    anchor: .bottom
                ) {
                    Image(systemName: "house.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                        .padding(8)
                        .background(.white)
                        .clipShape(Circle())
                        .shadow(radius: 3)
                }
            }
        }
        .mapControls {
            MapCompass()
            MapScaleView()
            MapUserLocationButton()
        }
        .navigationTitle("All Orders Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}
