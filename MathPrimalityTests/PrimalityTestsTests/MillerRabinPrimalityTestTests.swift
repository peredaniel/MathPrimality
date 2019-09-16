//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

@testable import MathPrimality
import XCTest

class MillerRabinPrimalityTestTests: XCTestCase {
    lazy var compositeNumbers = Array(Set(1...100000).subtracting(Set(primes)))
    lazy var primes = PrimeList(.upTo100000).primes

    func testSucceedsWith10IterationsOnPrimesUpTo100000() {
        for number in primes {
            XCTAssertTrue(MillerRabinPrimalityTest.test(number, iterations: 10))
        }
    }

    func testSucceedsOnCarmichaelNumbersUpTo100000() {
        let carmichaelNumbers = CarmichaelNumbersList.numbers
        for number in carmichaelNumbers {
            XCTAssertFalse(MillerRabinPrimalityTest.test(number))
        }
    }

    func testSucceedsOnCompositesUpTo100000() {
        for number in compositeNumbers {
            XCTAssertFalse(MillerRabinPrimalityTest.test(number))
        }
    }
}
