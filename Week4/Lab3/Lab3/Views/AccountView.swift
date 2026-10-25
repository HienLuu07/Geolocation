import SwiftUI
struct AccountView: View {
    @Binding var recipientName: String
    @Binding var deliveryAddress: String
    @Binding var deliveryLatitude: Double
    @Binding var deliveryLongitude: Double
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(.gray)
                Text(recipientName)
                    .font(.title3.bold())
                Text(deliveryAddress)
                    .font(.body)
                    .multilineTextAlignment(.center)
                NavigationLink {
                    EditAddressView(
                        recipientName: $recipientName,
                        address: $deliveryAddress,
                        latitude: $deliveryLatitude,
                        longitude: $deliveryLongitude
                    )
                } label: {
                    Text("Edit")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 8)
                Spacer()
            }
            .padding()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
