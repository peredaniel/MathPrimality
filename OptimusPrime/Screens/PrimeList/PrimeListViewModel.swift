//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import MathPrimality

class PrimeListViewModel {
    private let validRange = NSRange(location: 1, length: 80000)

    private var sieve = EratosthenesSieve()
    private var primeNumbers = [Int]()
    private var inputLowerBound: Int = 0
    private var inputUpperBound: Int = 0
}

extension PrimeListViewModel {
    public func computeResponse() -> String {
        if validateInput(inputLowerBound, inputUpperBound) {
            let subPrimesArray = getPrimes(between: inputLowerBound, and: inputUpperBound).map { String($0) }
            return "The Primes between \(inputLowerBound) and \(inputUpperBound) are: \(subPrimesArray.joined(separator: ", "))"
        }
        return ""
    }

    public func updateAndValidateInputs(lower: String? = nil, upper: String? = nil) -> Bool {
        inputLowerBound = Int(lower ?? "\(inputLowerBound)") ?? 0
        inputUpperBound = Int(upper ?? "\(inputUpperBound)") ?? 0
        return validateInput(inputLowerBound, inputUpperBound)
    }
}

private extension PrimeListViewModel {
    func getPrimes(between lower: Int, and upper: Int) -> [Int] {
        if upper - 1 >= primeNumbers.count {
            primeNumbers += sieve.prefix(upper)
        }
        return Array(primeNumbers[lower - 1...upper - 1])
    }

    func validateInput(_ lowerBound: Int, _ upperBound: Int) -> Bool {
        return validRange.contains(lowerBound) && validRange.contains(upperBound) && lowerBound <= upperBound
    }
}
