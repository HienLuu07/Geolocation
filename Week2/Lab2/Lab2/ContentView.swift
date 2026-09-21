import SwiftUI
struct Place: Identifiable {
    let id = UUID()
    var name: String
    var latitude: Double
    var longitude: Double
}
struct ContentView: View {
    @State private var places = [
        Place(name: "HCMIU", latitude: 10.8700, longitude: 106.8030),
        Place(name: "Home", latitude: 10.8231, longitude: 106.6297),
        Place(name: "Gym", latitude: 10.8499869, longitude: 106.7650851),
        Place(name: "Basketball Court", latitude: 10.8522112, longitude: 106.7549188)
    ]
    @State private var searchText = ""
    var filteredPlaces: [Place] {
        if searchText.isEmpty {
            return places
        }
        return places.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 55))
                        .foregroundStyle(.red)
                    Text("My Places")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Save places you love!")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                .padding(.top, 20)
                .padding(.bottom, 25)
                // Search bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("", text: $searchText)
                        .autocorrectionDisabled(true)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(filteredPlaces) { place in
                            NavigationLink {
                                MapView(place: place) { newLatitude, newLongitude in
                                    if let index = places.firstIndex(
                                        where: { $0.id == place.id }
                                    ) {
                                        places[index].latitude = newLatitude
                                        places[index].longitude = newLongitude
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(place.name)
                                        .font(.headline)
                                        .foregroundStyle(.black)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.gray)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                            }
                        }
                        NavigationLink {
                            AddPlaceView { newPlace in
                                places.append(newPlace)
                            }
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Place")
                            }
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
                HStack {
                    Text("Total places:")
                        .font(.headline)
                    Text("\(places.count)")
                        .font(.headline)
                        .fontWeight(.bold)
                }
                .padding(.bottom, 20)
            }
            .navigationBarHidden(true)
        }
    }
}
#Preview {
    ContentView()
}
