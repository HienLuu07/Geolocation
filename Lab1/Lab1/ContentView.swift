import SwiftUI
struct ContentView: View {
    @State private var n = ""
    @State private var result = ""
    var number: Double? {
        Double(n)
    }
    var body: some View {
        VStack(spacing: 20) {
            Text("Number Calculator")
                .font(.largeTitle)
                .bold()
            Text("Enter n:")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            TextField("Enter a number", text: $n)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.numberPad)
                .padding(.horizontal)
            // n^2
            Button {
                if let number = number {
                    result = "Result: \(number * number)"
                } else {
                    result = "Please enter a valid number"
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
                } else {
                    result = "Please enter a valid number"
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
                } else {
                    result = "Please enter a valid number"
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
                .font(.title3)
            Spacer()
        }
        .padding()
    }
}
#Preview {
    ContentView()
}
