//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

@testable import MathPrimality
import XCTest

class MillerRabinPrimalityTestPerformanceTests: XCTestCase {
    lazy var compositeNumbers = Array(Set(1...100000).subtracting(Set(primes)))
    lazy var primes = PrimeList(.upTo100000).primes

    func testPerformanceOnDeterministicWithPrimeEntry() {
        let prime = primes.randomElement()!
        measure {
            _ = MillerRabinPrimalityTest.test(prime)
        }
    }

    func testPerformanceOn10IterationsWithPrimeEntry() {
        let prime = primes.randomElement()!
        measure {
            _ = MillerRabinPrimalityTest.test(prime, iterations: 10)
        }
    }

    func testPerformanceOnDeterministicWithCompositeEntry() {
        let composite = compositeNumbers.randomElement()!
        measure {
            _ = MillerRabinPrimalityTest.test(composite)
        }
    }
}
