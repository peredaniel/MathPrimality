//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

@testable import MathPrimality
import XCTest

class EratosthenesSieveTests: XCTestCase {
    func testSieveCorrectlyGeneratesPrimesUpTo100000() {
        let primes = PrimeList(.upTo100000).primes
        let sieve = EratosthenesSieve(upTo: 100000)

        let computedPrimes = sieve.map { $0 }

        XCTAssertEqual(primes, computedPrimes)
    }

    func testUnboundedSieveCorrectlyGeneratesPrimesUpTo100000() {
        let primes = PrimeList(.upTo100000).primes
        let sieve = EratosthenesSieve()

        let computedPrimes = sieve.prefix(primes.count).map { $0 }

        XCTAssertEqual(primes, computedPrimes)
    }
}
