import Foundation
struct ProductFileManager {
    static func fileURL(_ filename: String) -> URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(filename)
    }
    static func prepareFile(_ filename: String) {
        let destination = fileURL(filename)
        guard !FileManager.default.fileExists(atPath: destination.path) else { return }
        if let source = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".txt", with: ""), withExtension: "txt", subdirectory: "Texts") {
            try? FileManager.default.copyItem(at: source, to: destination)
        }
    }
    static func readCategories() -> [ProductCategory] {
        prepareFile("category.txt")
        guard let content = try? String(contentsOf: fileURL("category.txt"), encoding: .utf8) else {
            return ProductCategory.allCases
        }
        return content.components(separatedBy: .newlines).compactMap { line in
            let parts = line.split(separator: ",", maxSplits: 1)
            guard parts.count == 2 else { return nil }
            let name = parts[1].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "")
            return ProductCategory(rawValue: name)
        }
    }
    static func readProducts() -> [Product] {
        prepareFile("sell.txt")
        guard let content = try? String(contentsOf: fileURL("sell.txt"), encoding: .utf8) else {
            return ProductData.products
        }
        return content.components(separatedBy: .newlines).compactMap { line in
            let parts = line.split(separator: ",", maxSplits: 3).map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "\"", with: "")
            }
            guard parts.count == 4,
                  let categoryID = Int(parts[2]),
                  let price = Double(parts[3]),
                  let category = category(for: categoryID) else { return nil }
            return Product(name: parts[1], price: price, imageName: imageName(for: parts[1]), category: category)
        }
    }
    static func saveProducts(_ products: [Product]) {
        let lines = products.enumerated().map { index, product in
            "\(index + 1), \"\(product.name)\", \(categoryID(for: product.category)), \(Int(product.price))"
        }
        prepareFile("sell.txt")
        try? lines.joined(separator: "\n").write(to: fileURL("sell.txt"), atomically: true, encoding: .utf8)
    }
    private static func category(for id: Int) -> ProductCategory? {
        switch id {
        case 1: return .fish
        case 2: return .plants
        case 3: return .filters
        case 4: return .food
        case 5: return .medicine
        case 6: return .aquariums
        default: return nil
        }
    }
    private static func categoryID(for category: ProductCategory) -> Int {
        switch category {
        case .fish: return 1
        case .plants: return 2
        case .filters: return 3
        case .food: return 4
        case .medicine: return 5
        case .aquariums: return 6
        }
    }
    private static func imageName(for name: String) -> String {
        switch name {
        case "Cá Hồng Mi": return "CaHongMi"
        case "Cây Rong Đuôi Chó": return "RongDuoiCho"
        case "Máy lọc SOBO WP-303H": return "SoboWP3300"
        case "TetraMin Tropical Flakes": return "TetraMin"
        case "Seachem ParaGuard 500ml": return "ParaGuard"
        case "GEX Glassterior 300": return "Gex300"
        default: return ""
        }
    }
}
