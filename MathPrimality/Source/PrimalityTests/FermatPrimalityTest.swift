//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

public enum FermatPrimalityTest: PrimalityTest {
    /*
     Fermat Primality Test.
     An academic example of a primality testing using the inverse of Fermat's Theorem.
     This algorithm fails with the Carmichael Numbers (https://en.wikipedia.org/wiki/Carmichael_number)
     Since this is a probabilistic algorithm, it needs to be executed multiple times to increase accuracy.
     To use the deterministic version, execute the algorithm with 0 iterations.

     Inputs:
     n: UInt64 { target integer to be tested for primality }
     k: Int    { optional. number of iterations }

     Outputs:
     true      { probably prime or Carmichael number }
     false     { composite }
     */
    public static func test(_ n: Int, iterations k: Int = 0) -> Bool {
        guard n != 2 else { return true }
        guard n > 2, n % 2 == 1 else { return false }

        let convertedNumber = UInt64(n)
        let numberOfIterations: UInt64 = k != 0 ? UInt64(k) : (convertedNumber - 2)

        for a in 2...numberOfIterations {
            if gcd(a, convertedNumber) != 1 { continue }
            let x = powmod64(a, convertedNumber - 1, convertedNumber)
            if x == 1 { continue }
            else { return false }
        }
        return true
    }
}
