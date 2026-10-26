import SwiftUI
struct AddProductView: View {
    @Environment(\.dismiss) private var dismiss
    let onSave: (Product) -> Void
    @State private var name = ""
    @State private var price = ""
    @State private var category: ProductCategory = .fish
    var body: some View {
        NavigationStack {
            Form {
                TextField("Fish Name", text: $name)
                TextField("Price (VND)", text: $price)
                    .keyboardType(.numberPad)
                Picker("Category", selection: $category) {
                    ForEach(ProductCategory.allCases) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                HStack {
                    Spacer()
                    Button("Save") {
                        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmedName.isEmpty,
                              let amount = Double(price), amount > 0 else { return }
                        onSave(Product(name: trimmedName, price: amount, imageName: "", category: category))
                        dismiss()
                    }
                    Spacer()
                }
            }
            .navigationTitle("Add Fish")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
