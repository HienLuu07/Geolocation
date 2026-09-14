import SwiftUI
struct ContentView: View {
    @State private var n = ""
    @State private var result = ""
    var number: Double? {
        Double(n)
    }
    var body: some View {
        VStack(spacing: 25) {
            Text("Number Calculator")
                .font(.largeTitle)
                .fontWeight(.bold)
            Text("Enter n:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            TextField("Enter n", text: $n)
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            // n^2
            Button {
                if let number = number {
                    result = "Result: \(number * number)"
                }
            } label: {
                Text("Calculate n²")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            // n^3
            Button {
                if let number = number {
                    result = "Result: \(number * number * number)"
                }
            } label: {
                Text("Calculate n³")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple)
                    .cornerRadius(12)
            }
            // 2n
            Button {
                if let number = number {
                    result = "Result: \(number * 2)"
                }
            } label: {
                Text("Double n")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(12)
            }
            // Result
            Text(result)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 10)

            Spacer()
        }
        .padding()
    }
}
#Preview {
    ContentView()
}
