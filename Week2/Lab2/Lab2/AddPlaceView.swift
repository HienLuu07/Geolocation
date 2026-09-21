import SwiftUI

struct AddPlaceView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var placeName = ""
    @State private var latitude = ""
    @State private var longitude = ""
    
    let onSave: (Place) -> Void
    
    var canSave: Bool {
        !placeName.isEmpty &&
        Double(latitude) != nil &&
        Double(longitude) != nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            Text("Add Place")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
            
            // Name
            Text("Name")
                .font(.headline)
            
            TextField("", text: $placeName)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled(true)
            
            // Latitude
            Text("Latitude")
                .font(.headline)
            
            TextField("", text: $latitude)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
            
            // Longitude
            Text("Longitude")
                .font(.headline)
            
            TextField("", text: $longitude)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
            
            // Save button
            Button {
                if let lat = Double(latitude),
                   let lon = Double(longitude) {
                    
                    let newPlace = Place(
                        name: placeName,
                        latitude: lat,
                        longitude: lon
                    )
                    
                    onSave(newPlace)
                    dismiss()
                }
            } label: {
                Text("Save Place")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canSave ? Color.blue : Color.gray)
                    .cornerRadius(12)
            }
            .disabled(!canSave)
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AddPlaceView { _ in }
}

