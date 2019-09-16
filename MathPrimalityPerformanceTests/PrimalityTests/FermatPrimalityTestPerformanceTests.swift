//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

@testable import MathPrimality
import XCTest

class FermatPrimalityTestPerformanceTests: XCTestCase {
    lazy var carmichaelNumbers = CarmichaelNumbersList.numbers
    lazy var compositeNonCarmichaelNumbers = Array(Set(1...100000).subtracting(Set(primes)).subtracting(Set(carmichaelNumbers)))
    lazy var primes = PrimeList(.upTo100000).primes

    func testPerformanceOnDeterministicWithPrimeEntry() {
        let prime = primes.randomElement()!
        measure {
            _ = FermatPrimalityTest.test(prime)
        }
    }

    func testPerformanceOn10IterationsWithPrimeEntry() {
        let prime = primes.randomElement()!
        measure {
            _ = FermatPrimalityTest.test(prime, iterations: 10)
        }
    }

    func testPerformanceOnDeterministicWithCarmichaelNumberEntry() {
        let carmichaelNumber = carmichaelNumbers.randomElement()!
        measure {
            _ = FermatPrimalityTest.test(carmichaelNumber)
        }
    }

    func testPerformanceOnDeterministicWithCompositeEntry() {
        let composite = compositeNonCarmichaelNumbers.randomElement()!
        measure {
            _ = FermatPrimalityTest.test(composite)
        }
    }
}
