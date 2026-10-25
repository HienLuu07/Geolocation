import SwiftUI
struct ContentView: View {
    @State private var recipientName = "Lưu Đình Hiển"
    @State private var deliveryAddress = "135 Nam Kỳ Khởi Nghĩa, HCMC"
    @State private var deliveryLatitude = 10.7770
    @State private var deliveryLongitude = 106.6953
    @State private var selectedCategory: ProductCategory? = nil
    @State private var selectedTab = 0
    @State private var showCart = false
    @State private var products: [Product] = ProductData.products
    @State private var searchText = ""
    @State private var cartItems: [CartItem] = []
    @State private var pendingProduct: Product?
    @State private var showAddConfirmation = false
    @State private var orders: [Order] = []
    var body: some View {
        TabView(selection: $selectedTab) {
            homeView
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)
            categoriesView
                .tabItem { Label("Categories", systemImage: "square.grid.2x2") }
                .tag(1)
            NavigationStack {
                ScrollView {
                    let favoriteProducts = products.filter { $0.isFavorite }
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)], spacing: 12) {
                        ForEach(favoriteProducts) { product in
                            ProductCardView(product: product, onFavorite: {
                                if let index = products.firstIndex(where: { $0.id == product.id }) {
                                    products[index].isFavorite.toggle()
                                }
                            }, onAddToCart: {
                                requestAddToCart(for: product)
                            })
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .background(Color.white)
                .toolbar(.hidden, for: .navigationBar)
            }
            .tabItem { Label("Favorites", systemImage: "heart") }
            .tag(2)
            NavigationStack {
                OrderView(orders: $orders)
            }
            .tabItem { Label("Order", systemImage: "list.clipboard") }
            .tag(3)
            AccountView(
                recipientName: $recipientName,
                deliveryAddress: $deliveryAddress,
                deliveryLatitude: $deliveryLatitude,
                deliveryLongitude: $deliveryLongitude
            )
            .tabItem { Label("Account", systemImage: "person") }
            .tag(4)
        }
        .tint(.blue)
        .alert("Add to Cart?", isPresented: $showAddConfirmation) {
            Button("Yes") {
                if let product = pendingProduct {
                    addToCart(product)
                }
            }
            Button("No", role: .cancel) {
                pendingProduct = nil
            }
        } message: {
            Text("Do you want to add \(pendingProduct?.name ?? "this product") to your cart?")
        }
    }
    private func requestAddToCart(for product: Product) {
        pendingProduct = product
        showAddConfirmation = true
    }
    private func addToCart(_ product: Product) {
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(product: product, quantity: 1))
        }
        pendingProduct = nil
    }
    private var homeView: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    HomeHeaderView(
                        onNotificationTap: {},
                        cartCount: cartItems.reduce(0) { $0 + $1.quantity },
                        onCartTap: {
                            showCart = true
                        }
                    )
                    NavigationLink {
                        MapView(
                            recipientName: $recipientName,
                            deliveryAddress: $deliveryAddress,
                            deliveryLatitude: $deliveryLatitude,
                            deliveryLongitude: $deliveryLongitude
                        )
                    } label: {
                        HStack {
                            Image(systemName: "map.fill")
                                .foregroundStyle(.blue)
                            Text("To:")
                                .font(.subheadline)
                                .fontWeight(.black)
                                .foregroundStyle(.black)
                            Text(deliveryAddress)
                                .font(.subheadline)
                                .fontWeight(.regular)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 14)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                    SearchBarView(text: $searchText)
                    if searchText.isEmpty {
                        BannerView()
                            .frame(height: 180)
                        Button {
                            selectedTab = 1
                        } label: {
                            HStack {
                                Text("Categories")
                                    .font(.title3)
                                    .bold()
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(.headline)
                                    .foregroundStyle(.blue)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        CategoryRowView(
                            selectedCategory: selectedCategory,
                            onSelect: { category in
                                selectedCategory = category
                                selectedTab = 1
                            },
                            products: $products,
                            cartItems: $cartItems,
                            onAddedToCart: { product in
                                requestAddToCart(for: product)
                            }
                        )
                        Text("Featured Products")
                            .font(.title3)
                            .bold()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .top, spacing: 12) {
                                ForEach(products) { product in
                                    ProductCardView(product: product, onFavorite: {
                                        if let index = products.firstIndex(where: { $0.id == product.id }) {
                                            products[index].isFavorite.toggle()
                                        }
                                    }, onAddToCart: {
                                        requestAddToCart(for: product)
                                    })
                                    .frame(width: 170)
                                }
                            }
                            .padding(.vertical, 4)
                        }
                    } else {
                        Text("Search Results")
                            .font(.title3)
                            .bold()
                        let filteredProducts = products.filter {
                            $0.name.localizedCaseInsensitiveContains(searchText)
                        }
                        if filteredProducts.isEmpty {
                            ContentUnavailableView(
                                "No Products Found",
                                systemImage: "magnifyingglass",
                                description: Text("Try another product name.")
                            )
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                                ForEach(filteredProducts) { product in
                                    ProductCardView(product: product, onFavorite: {
                                        if let index = products.firstIndex(where: { $0.id == product.id }) {
                                            products[index].isFavorite.toggle()
                                        }
                                    }, onAddToCart: {
                                        requestAddToCart(for: product)
                                    })
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $showCart) {
                CartView(items: $cartItems, onCheckout: { items in
                    orders.append(Order(items: items))
                    cartItems.removeAll()
                    showCart = false
                    selectedTab = 3
                })
            }
        }
    }
    private var categoriesView: some View {
        NavigationStack {
            CategoryRowView(
                selectedCategory: selectedCategory,
                onSelect: { selectedCategory = $0 },
                isGrid: true,
                products: $products,
                cartItems: $cartItems,
                onAddedToCart: { product in
                    requestAddToCart(for: product)
                }
            )
            .padding()
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}
#Preview {
    ContentView()
}
