import Foundation
struct ProductData {
    static let products: [Product] = [
        Product(
            name: "Cá Hồng Mi",
            price: 15000,
            imageName: "CaHongMi",
            category: .fish
        ),
        Product(
            name: "Cây Rong Đuôi Chó",
            price: 20000,
            imageName: "RongDuoiCho",
            category: .plants
        ),
        Product(
            name: "Máy lọc SOBO WP-303H",
            price: 75000,
            imageName: "SoboWP3300",
            category: .filters
        ),
        Product(
            name: "TetraMin Tropical Flakes",
            price: 65000,
            imageName: "TetraMin",
            category: .food
        ),
        Product(
            name: "Seachem ParaGuard 500ml",
            price: 150000,
            imageName: "ParaGuard",
            category: .medicine
        ),
        Product(
            name: "GEX Glassterior 300",
            price: 450000,
            imageName: "Gex300",
            category: .aquariums
        )
    ]
}
