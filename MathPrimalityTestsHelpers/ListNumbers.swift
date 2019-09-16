//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import Foundation

class PrimeList {
    enum Limit: Int {
        case upTo100000 = 0

        var filename: String {
            switch self {
            case .upTo100000: return "Primes_0_100000"
            }
        }
    }

    let primes: [Int]

    init(_ limit: Limit) {
        var primes = [Int]()
        if limit.rawValue <= Limit.upTo100000.rawValue,
            let url = Bundle(for: PrimeList.self).url(forResource: Limit.upTo100000.filename, withExtension: "json"),
            let data = try? Data(contentsOf: url) {
            primes += (try? JSONDecoder().decode([Int].self, from: data)) ?? []
        }
        self.primes = primes
    }
}

enum CarmichaelNumbersList {
    static let numbers = [
        561, 1105, 1729, 2465, 2821, 6601, 8911, 10585, 15841, 29341, 41041, 46657, 52633, 62745, 63973, 75361
    ]
}
