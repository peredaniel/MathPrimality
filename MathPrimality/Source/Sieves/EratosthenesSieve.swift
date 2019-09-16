//
//  Original implementation: https://github.com/CAD97/ProjectEulerSwift/blob/master/ProjectEuler/PrimeSequence.swift
//  Added comments from: https://codereview.stackexchange.com/questions/136019/unbounded-sieve-of-eratosthenes-in-swift
//  Adapted to Swift 5.0.
//

public struct EratosthenesSieve: Sequence {
    public let iterator: AnyIterator<Int>

    /// Creates a sequence of primes up to (and including) `limit`.
    public init(upTo limit: Int) {
        iterator = AnyIterator(EratosthenesIterator(upTo: limit))
    }

    /// Creates an "infinite" sequence of prime numbers.
    public init() {
        iterator = AnyIterator(UnboundedSieve())
    }

    public func makeIterator() -> AnyIterator<Int> {
        return iterator
    }
}

///
/// Lazy, Unbounded, Sieve of Erathosthenes.
///
/// See https://www.cs.hmc.edu/~oneill/papers/Sieve-JFP.pdf
///
private struct UnboundedSieve: IteratorProtocol {
    private var sieve: PriorityQueue<PrimeCounter>
    private var counter = 2

    init() {
        sieve = PriorityQueue { $0.composite < $1.composite }
    }

    private struct PrimeCounter {
        let prime: Int
        var composite: Int
        func next() -> PrimeCounter {
            return PrimeCounter(prime: prime, composite: composite + 2 * prime)
        }
    }

    mutating func next() -> Int? {
        if counter == 2 {
            counter = 3
            return 2
        }

        while let catcher = sieve.peek(), catcher.composite == counter {
            while let catcher = sieve.peek(), catcher.composite == counter {
                sieve.replaceTop(with: catcher.next())
            }
            counter += 2
        }
        defer {
            sieve.enqueue(PrimeCounter(prime: counter, composite: counter * counter))
            counter += 2
        }
        return counter
    }
}

private struct EratosthenesIterator: IteratorProtocol {
    let limit: Int
    var composite: [Bool]
    var current = 2

    init(upTo n: Int) {
        limit = n
        composite = [Bool](repeating: false, count: n + 1)
    }

    mutating func next() -> Int? {
        while current <= limit {
            if !composite[current] {
                let prime = current
                for multiple in stride(from: current * current, through: limit, by: current) {
                    composite[multiple] = true
                }
                current += 1
                return prime
            }
            current += 1
        }
        return nil
    }
}
