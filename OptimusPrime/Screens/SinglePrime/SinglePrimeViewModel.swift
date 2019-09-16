//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import MathPrimality

class SinglePrimeViewModel {
    private let validRange = NSRange(location: 1, length: 80000)

    private var sieve = EratosthenesSieve()
    private var primeNumbers = [Int]()
    private var inputNumber: Int = 0
}

extension SinglePrimeViewModel {
    public func computeResponse() -> String {
        if validateInput(inputNumber) {
            return "The Prime at position \(inputNumber) is: \(getPrime(at: inputNumber))"
        }
        return ""
    }

    public func updateAndValidateInput(_ text: String) -> Bool {
        inputNumber = Int(text) ?? 0
        return validateInput(inputNumber)
    }
}

private extension SinglePrimeViewModel {
    func getPrime(at index: Int) -> Int {
        if index - 1 >= primeNumbers.count {
            primeNumbers += Array(sieve.prefix(index))
        }
        return primeNumbers[index - 1]
    }

    func validateInput(_ number: Int) -> Bool {
        return validRange.contains(number)
    }
}
