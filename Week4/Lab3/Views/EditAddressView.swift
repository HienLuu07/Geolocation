import SwiftUI
struct EditAddressView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var recipientName: String
    @Binding var address: String
    @Binding var latitude: Double
    @Binding var longitude: Double
    @State private var editedName: String
    @State private var editedAddress: String
    @State private var editedLatitude: String
    @State private var editedLongitude: String
    init(recipientName: Binding<String>, address: Binding<String>, latitude: Binding<Double>, longitude: Binding<Double>) {
        _recipientName = recipientName
        _address = address
        _latitude = latitude
        _longitude = longitude
        _editedName = State(initialValue: recipientName.wrappedValue)
        _editedAddress = State(initialValue: address.wrappedValue)
        _editedLatitude = State(initialValue: String(latitude.wrappedValue))
        _editedLongitude = State(initialValue: String(longitude.wrappedValue))
    }
    private var canSave: Bool {
        !editedName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !editedAddress.trimmingCharacters(in: .whitespaces).isEmpty &&
        validCoordinates(editedLatitude, editedLongitude)
    }
    private func validCoordinates(_ latitude: String, _ longitude: String) -> Bool {
        guard let lat = Double(latitude), let lon = Double(longitude) else { return false }
        return (-90...90).contains(lat) && (-180...180).contains(lon)
    }
    var body: some View {
        Form {
            Section("My Information") {
                TextField("My Name", text: $editedName)
                TextField("My Address", text: $editedAddress)
                TextField("Latitude", text: $editedLatitude)
                    .keyboardType(.decimalPad)
                TextField("Longitude", text: $editedLongitude)
                    .keyboardType(.decimalPad)
            }
            Button {
                guard let lat = Double(editedLatitude), let lon = Double(editedLongitude) else { return }
                recipientName = editedName
                address = editedAddress
                latitude = lat
                longitude = lon
                dismiss()
            } label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .disabled(!canSave)
        }
        .navigationTitle("Edit")
        .navigationBarTitleDisplayMode(.inline)
    }
}
