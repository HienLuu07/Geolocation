import SwiftUI
import MapKit

struct MapView: View {
    
    let place: Place
    let onUpdate: (Double, Double) -> Void
    
    @Environment(\.dismiss) var dismiss
    
    @State private var latitude: String
    @State private var longitude: String
    @State private var position: MapCameraPosition
    
    init(
        place: Place,
        onUpdate: @escaping (Double, Double) -> Void
    ) {
        self.place = place
        self.onUpdate = onUpdate
        
        _latitude = State(initialValue: String(place.latitude))
        _longitude = State(initialValue: String(place.longitude))
        
        let coordinate = CLLocationCoordinate2D(
            latitude: place.latitude,
            longitude: place.longitude
        )
        
        _position = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Map
            Map(position: $position) {
                if let lat = Double(latitude),
                   let lon = Double(longitude) {
                    
                    Marker(
                        place.name,
                        coordinate: CLLocationCoordinate2D(
                            latitude: lat,
                            longitude: lon
                        )
                    )
                    .tint(.red)
                }
            }
            
            // Information
            VStack(alignment: .leading, spacing: 12) {
                
                Text(place.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Latitude")
                    .font(.headline)
                
                TextField("", text: $latitude)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                
                Text("Longitude")
                    .font(.headline)
                
                TextField("", text: $longitude)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                
                Button {
                    if let lat = Double(latitude),
                       let lon = Double(longitude) {
                        
                        let coordinate = CLLocationCoordinate2D(
                            latitude: lat,
                            longitude: lon
                        )
                        
                        position = .region(
                            MKCoordinateRegion(
                                center: coordinate,
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.01,
                                    longitudeDelta: 0.01
                                )
                            )
                        )
                        
                        // Save the new coordinates
                        onUpdate(lat, lon)
                        
                        // Go back
                        dismiss()
                    }
                } label: {
                    Text("Update Location")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle(place.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
