//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

@testable import MathPrimality
import XCTest

class FermatPrimalityTestTests: XCTestCase {
    lazy var carmichaelNumbers = CarmichaelNumbersList.numbers
    lazy var compositeNonCarmichaelNumbers = Array(Set(1...100000).subtracting(Set(primes)).subtracting(Set(carmichaelNumbers)))
    lazy var primes = PrimeList(.upTo100000).primes

    func testSucceedsWith10IterationsOnPrimesUpTo100000() {
        for number in primes {
            XCTAssertTrue(FermatPrimalityTest.test(number, iterations: 10))
        }
    }

    func testFailsOnCarmichaelNumbersUpTo100000() {
        for number in carmichaelNumbers {
            XCTAssertTrue(FermatPrimalityTest.test(number, iterations: 10))
        }
    }

    func testSucceedsOnCompositeNonCarmichaelNumbersUpTo100000() {
        for number in compositeNonCarmichaelNumbers {
            XCTAssertFalse(FermatPrimalityTest.test(number))
        }
    }
}
