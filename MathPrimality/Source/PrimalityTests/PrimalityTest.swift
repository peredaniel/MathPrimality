//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

public protocol PrimalityTest {
    static func test(_ n: Int, iterations k: Int) -> Bool
}

extension PrimalityTest {
    /// Computes the GCD between a and b
    static func gcd(_ a: UInt64, _ b: UInt64) -> UInt64 {
        let r = a % b
        return r != 0 ? gcd(b, r) : b
    }

    /*
     Computes a random base number r such that 1 < r < n-1
     */
    static func randomBase(_ n: UInt64) -> UInt64 {
        let range = UInt64.max - UInt64.max % (n - 2)
        var r: UInt64 = 0
        repeat {
            arc4random_buf(&r, MemoryLayout.size(ofValue: r))
        } while r >= range
        let a = r % (n - 2) + 2
        return gcd(a, n) == 1 ? a : randomBase(n)
    }

    /*
     Calculates (base^exp) mod m.

     Inputs:
     base: UInt64  { base }
     exp: UInt64   { exponent }
     m: UInt64     { modulus }

     Outputs:
     the result
     */
    static func powmod64(_ base: UInt64, _ exp: UInt64, _ m: UInt64) -> UInt64 {
        if m == 1 { return 0 }

        var result: UInt64 = 1
        var b = base % m
        var e = exp

        while e > 0 {
            if e % 2 == 1 { result = multiply(result, b, module: m) }
            b = multiply(b, b, module: m)
            e >>= 1
        }

        return result
    }

    /*
     Calculates (first * second) mod m, hopefully without overflow. :]

     Inputs:
     first: UInt64   { first integer }
     second: UInt64  { second integer }
     m: UInt64       { modulus }

     Outputs:
     the result
     */
    static func multiply(_ first: UInt64, _ second: UInt64, module m: UInt64) -> UInt64 {
        var result: UInt64 = 0
        var a = first
        var b = second

        while a != 0 {
            if a % 2 == 1 {
                // This may overflow if 'm' is a 64bit number && both 'result' and 'b' are very close to but smaller than 'm'.
                result = ((result % m) + (b % m)) % m
            }
            a >>= 1
            b = (b << 1) % m
        }

        return result
    }
}
