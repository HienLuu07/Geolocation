import SwiftUI
struct ContentView: View {
    // Single number
    @State private var n = ""
    @State private var n2Result = ""
    @State private var n3Result = ""
    @State private var factorialResult = ""
    @State private var primeResult = ""
    // Two number
    @State private var a = ""
    @State private var b = ""
    @State private var gcdResult = ""
    @State private var lcmResult = ""
    var number: Double? {
        Double(n)
    }
    var numberA: Int? {
        Int(a)
    }
    var numberB: Int? {
        Int(b)
    }
    // GCD
    func gcd(_ a: Int, _ b: Int) -> Int {
        var x = abs(a)
        var y = abs(b)
        while y != 0 {
            let remainder = x % y
            x = y
            y = remainder
        }
        return x
    }
    // LCM
    func lcm(_ a: Int, _ b: Int) -> Int {
        if a == 0 || b == 0 {
            return 0
        }
        return abs(a * b) / gcd(a, b)
    }
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // MARK: - Single Number
                Text("Number Tools")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Single Number (n)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                Text("Enter a number:")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                TextField("", text: $n)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                HStack(spacing: 5) {
                    VStack {
                        Button {
                            if let number = number {
                                n2Result = "\(number * number)"
                            } else {
                                n2Result = "Please enter a number"
                            }
                        } label: {
                            Text("n²")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        Text(n2Result)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Button {
                            if let number = number {
                                n3Result = "\(number * number * number)"
                            } else {
                                n3Result = "Please enter a number"
                            }
                        } label: {
                            Text("n³")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(12)
                        }
                        Text(n3Result)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Button {
                            if let number = number,
                               number >= 0,
                               number == floor(number) {
                                var factorial = 1.0
                                if number > 0 {
                                    for i in 1...Int(number) {
                                        factorial *= Double(i)
                                    }
                                }
                                factorialResult = "\(factorial)"
                            } else {
                                factorialResult = "Please enter a number"
                            }
                        } label: {
                            Text("n!")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.pink)
                                .cornerRadius(12)
                        }
                        Text(factorialResult)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Button {
                            if let number = number,
                               number >= 2,
                               number == floor(number) {

                                let n = Int(number)
                                var isPrime = true

                                if n > 3 {
                                    for i in 2...Int(sqrt(Double(n))) {
                                        if n % i == 0 {
                                            isPrime = false
                                            break
                                        }
                                    }
                                }
                                primeResult = isPrime ? "Prime" : "Not Prime"
                            } else {
                                primeResult = "Please enter a number"
                            }
                        } label: {
                            Text("Prime")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        Text(primeResult)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 5)
                // MARK: - Two Number
                Text("Two Numbers (a, b)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                HStack(spacing: 15) {
                    Text("Enter a:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Enter b:")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal)
                HStack(spacing: 15) {
                    TextField("", text: $a)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                    TextField("", text: $b)
                        .keyboardType(.numberPad)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(.horizontal)
                HStack(spacing: 10) {
                    VStack {
                        Button {
                            if let a = numberA, let b = numberB {
                                gcdResult = "\(gcd(a, b))"
                            } else {
                                gcdResult = "Please enter a valid number"
                            }
                        } label: {
                            Text("UCLN (GCD)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(12)
                        }
                        Text(gcdResult)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Button {
                            if let a = numberA, let b = numberB {
                                lcmResult = "\(lcm(a, b))"
                            } else {
                                lcmResult = "Please enter a valid number"
                            }
                        } label: {
                            Text("BCNN (LCM)")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                        Text(lcmResult)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 5)
                // MARK: - Bottom Buttons
                HStack(spacing: 10) {
                    Button {
                        n = ""
                        n2Result = ""
                        n3Result = ""
                        factorialResult = ""
                        primeResult = ""
                        a = ""
                        b = ""
                        gcdResult = ""
                        lcmResult = ""
                    } label: {
                        Label("Clear All", systemImage: "trash")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(12)
                    }
                    Button {
                    } label: {
                        Label("Help", systemImage: "questionmark.circle")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 5)
                Spacer()
            }
            .padding()
        }
    }
}
#Preview {
    ContentView()
}
