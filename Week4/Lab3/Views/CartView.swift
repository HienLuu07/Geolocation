import SwiftUI
struct CartView: View {
    @Binding var items: [CartItem]
    var onCheckout: ([CartItem]) -> Void
    private var total: Double {
        items.reduce(0) { $0 + $1.subtotal }
    }
    var body: some View {
        Group {
            if items.isEmpty {
                Color.clear
            } else {
                List {
                    ForEach(items.indices, id: \.self) { index in
                        HStack(spacing: 12) {
                            Image(items[index].product.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(items[index].product.name)
                                    .font(.headline)
                                Text(items[index].product.price, format: .currency(code: "VND").precision(.fractionLength(0)))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Stepper(
                                "\(items[index].quantity)",
                                value: $items[index].quantity,
                                in: 1...99
                            )
                            .labelsHidden()
                            .fixedSize()

                            Text("\(items[index].quantity)")
                                .font(.subheadline.monospacedDigit())
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { offsets in
                        items.remove(atOffsets: offsets)
                    }
                    Section {
                        HStack {
                            Text("Total").font(.headline)
                            Spacer()
                            Text(total, format: .currency(code: "VND").precision(.fractionLength(0)))
                                .font(.headline)
                        }
                        Button {
                            onCheckout(items)
                        } label: {
                            Text("Place Order")
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
}
