//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

@testable import MathPrimality
import XCTest

class EratosthenesSievePerformanceTests: XCTestCase {
    func testPerformanceSieveComputingSumOfPrimesUpTo1_000_000() {
        let limit = 1000000
        measure {
            _ = EratosthenesSieve(upTo: limit).reduce(0, +)
        }
    }

    func testPerformanceUnboundSieveComputingSumOfPrimesUpTo1000000() {
        // Since the unbound sieve computes prime number by index (in the unbound array of prime numbers), we must
        // set the number of primes between 1 and 1,000,000 as the limit, which is 78,498.
        let numberOfPrimes = 78498
        measure {
            _ = EratosthenesSieve().prefix(numberOfPrimes).reduce(0, +)
        }
    }

    func testPerformanceSieveComputingPrimeNumber1_000_001() {
        // The bounded version of Eratosthenes Sieve does not allow us to compute any primer number greater than the limit.
        // Therefore, the computation has "no memory" and any previous computations are lost.
        let limit = 1000001
        measure {
            _ = EratosthenesSieve(upTo: limit).max()
        }
    }

    func testPerformanceUnboundSieveComputingPrimeNumber1_000_001After1_000_000() {
        let numberOfPrimes = 78498
        let sieve = EratosthenesSieve().prefix(numberOfPrimes)
        _ = sieve.max()
        measure {
            _ = sieve.prefix(1).max()
        }
    }
}
