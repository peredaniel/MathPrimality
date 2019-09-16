//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

public enum MillerRabinPrimalityTest: PrimalityTest {
    /*
     Miller-Rabin Primality Test.
     One of the most used algorithms for primality testing.
     Since this is a probabilistic algorithm, it needs to be executed multiple times to increase accuracy.
     To use the deterministic version, execute the algorithm with 0 iterations.

     Inputs:
     n: UInt64 { target integer to be tested for primality }
     k: Int    { optional. number of iterations }

     Outputs:
     true      { probably prime }
     false     { composite }
     */
    public static func test(_ n: Int, iterations k: Int = 0) -> Bool {
        guard n != 2, n != 3 else { return true }
        guard n > 2, n % 2 == 1 else { return false }

        let convertedNumber = UInt64(n)

        var d = convertedNumber - 1
        var s = 0

        while d % 2 == 0 {
            d /= 2
            s += 1
        }

        let numberOfIterations: UInt64 = k != 0 ? UInt64(k) : (convertedNumber - 1)

        for index in 1...numberOfIterations {
            let a = k != 0 ? randomBase(convertedNumber) : index
            var x = powmod64(a, d, convertedNumber)
            if x == 1 || x == n - 1 { continue }

            if s == 1 { s = 2 }

            for _ in 1...s - 1 {
                x = powmod64(x, 2, convertedNumber)
                if x == 1 { return false }
                if x == n - 1 { break }
            }

            if x != n - 1 { return false }
        }

        return true
    }
}
