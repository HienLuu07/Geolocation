import SwiftUI
import MapKit
import CoreLocation
struct ContentView: View {
    @State private var orders: [Order] = [
        Order(
            customerName: "Tran Van B",
            restaurant: Restaurant(
                name: "Pho Hoa",
                address: "260C Pasteur, Vo Thi Sau Ward, HCMC",
                latitude: 10.7831,
                longitude: 106.6904,
                type: "Noodles"
            ),
            customerAddress: "1 Phan Chu Trinh, Ben Thanh Ward, HCMC",
            customerLatitude: 10.7725,
            customerLongitude: 106.6980
        ),
        Order(
            customerName: "Nguyen Van A",
            restaurant: Restaurant(
                name: "Pizza 4P's",
                address: "8 Thu Khoa Huan, Ben Thanh Ward, HCMC",
                latitude: 10.7758,
                longitude: 106.6953,
                type: "Fast Food"
            ),
            customerAddress: "135 Nam Ky Khoi Nghia, Ben Thanh Ward, HCMC",
            customerLatitude: 10.7770,
            customerLongitude: 106.6953
        )
    ]
    @State private var sortByNearest = false
    @State private var searchText = ""
    @State private var selectedStatus = "All"
    @State private var showingAddOrder = false
    private var filteredOrders: [Order] {
        let results = orders.filter { order in
            let matchesSearch = searchText.isEmpty ||
                order.restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                order.restaurant.address.localizedCaseInsensitiveContains(searchText) ||
                order.customerName.localizedCaseInsensitiveContains(searchText) ||
                order.customerAddress.localizedCaseInsensitiveContains(searchText) ||
                order.status.localizedCaseInsensitiveContains(searchText)
            let matchesStatus = selectedStatus == "All" ||
                order.status == selectedStatus
            return matchesSearch && matchesStatus
        }
        return results.sorted {
            let distance1 = CLLocation(
                latitude: $0.restaurant.latitude,
                longitude: $0.restaurant.longitude
            ).distance(from: CLLocation(
                latitude: $0.customerLatitude,
                longitude: $0.customerLongitude
            ))
            let distance2 = CLLocation(
                latitude: $1.restaurant.latitude,
                longitude: $1.restaurant.longitude
            ).distance(from: CLLocation(
                latitude: $1.customerLatitude,
                longitude: $1.customerLongitude
            ))
            return distance1 < distance2
        }
    }
    private func distanceToCustomer(_ order: Order) -> CLLocationDistance {
        let restaurant = CLLocation(
            latitude: order.restaurant.latitude,
            longitude: order.restaurant.longitude
        )
        let customer = CLLocation(
            latitude: order.customerLatitude,
            longitude: order.customerLongitude
        )
        return restaurant.distance(from: customer)
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                VStack(spacing: 6) {
                    Image(systemName: "bicycle")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.orange)
                    Text("Delivery Orders")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("Search orders", text: $searchText)
                        .autocorrectionDisabled()
                }
                .padding(10)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal)
                Picker("Filter by status", selection: $selectedStatus) {
                    Text("All").tag("All")
                    Text("Pending").tag("Pending")
                    Text("In Transit").tag("In Transit")
                    Text("Delivered").tag("Delivered")
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                List {
                    ForEach(filteredOrders) { order in
                        NavigationLink {
                            OrderDetailView(order: order) { newStatus in
                                if let index = orders.firstIndex(
                                    where: { $0.id == order.id }
                                ) {
                                    orders[index].status = newStatus
                                    orders = orders
                                }
                            }
                        } label: {
                            OrderRowView(order: order)
                        }
                    }
                    .onDelete(perform: deleteOrders)
                }
                .listStyle(.plain)
                HStack {
                    Text("Total orders: \(orders.count)")
                        .font(.headline)
                    Spacer()
                    NavigationLink {
                        AllOrdersMapView(orders: orders)
                    } label: {
                        Image(systemName: "map.fill")
                            .font(.headline)
                    }
                    .buttonStyle(.bordered)
                    Button {
                        showingAddOrder = true
                    } label: {
                        Label("Add Order", systemImage: "plus")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .toolbar(.hidden, for: .navigationBar)
            .sheet(isPresented: $showingAddOrder) {
                NavigationStack {
                    AddOrderView { newOrder in
                        orders.append(newOrder)
                        showingAddOrder = false
                    }
                }
            }
        }
    }
    private func deleteOrders(at offsets: IndexSet) {
        let idsToDelete = offsets.map { filteredOrders[$0].id }
        orders.removeAll { idsToDelete.contains($0.id) }
    }
}
struct OrderRowView: View {
    @ObservedObject var order: Order
    @State private var distance: Double?
    @State private var routeFailed = false
    private var restaurantIcon: String {
        Restaurant.icon(for: order.restaurant.type)
    }
    private var statusColor: Color {
        switch order.status {
        case "Pending": return .blue
        case "In Transit": return .orange
        case "Delivered": return .green
        default: return .gray
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: restaurantIcon)
                    .foregroundStyle(.orange)
                Text(order.restaurant.name)
                    .font(.headline)
                    .lineLimit(1)
                Spacer(minLength: 8)
                if let distance {
                    Text(String(format: "%.1f km", distance / 1000))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                } else if routeFailed {
                    Text("-- km")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView()
                        .controlSize(.small)
                }
            }
            Text(order.restaurant.address)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("To: \(order.customerName)")
                .font(.subheadline)
            Text(order.customerAddress)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack {
                Text(order.status)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(statusColor.opacity(0.15))
                    .foregroundStyle(statusColor)
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 5)
        .task {
            await calculateDistance()
        }
    }
    @MainActor
    private func calculateDistance() async {
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
            let response = try await MKDirections(request: request).calculate()
            if let route = response.routes.first {
                distance = route.distance
            } else {
                routeFailed = true
            }
        } catch {
            routeFailed = true
        }
    }
}
