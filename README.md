# MathPrimality framework

[![Build Status](https://travis-ci.com/peredaniel/MathPrimality.svg?branch=master)](https://travis-ci.com/peredaniel/MathPrimality)
[![Coverage Status](https://coveralls.io/repos/github/peredaniel/MathPrimality/badge.svg?branch=master)](https://coveralls.io/github/peredaniel/MathPrimality?branch=master)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![License](https://img.shields.io/github/license/peredaniel/MathPrimality)](https://github.com/peredaniel/MathPrimality/blob/master/LICENSE)
[![Language: Swift 4.2](https://img.shields.io/badge/Swift-4.2-green.svg)](https://swift.org/)
[![Language: Swift 5.0](https://img.shields.io/badge/Swift-5.0-green.svg)](https://swift.org/)

MathPrimality provides several algorithms to test the primality of a given number. It includes both Fermat and Miller-Rabin primality tests. Also, it includes an implementation of the Eratosthenes Sieve to compute sequences of prime numbers.

## Purpose and disclaimer

This framework is not intended to be used in production code. This is a repository used as example in talks and tech meetings, to demonstrate usage of unit tests, performance tests, CI setup and coverage reports. Of course, the algorithms provided are accurate and you can use it in your app if needed. Also, I'll keep releases stable. Let me know if there's anything I missed by opening an issue!

## Requirements

| Version | Requirements                           |
|:--------|:---------------------------------------|
| 1.0.0.  | Xcode 10.0+<br>Swift 4.2+<br>iOS 10.0+ |

The framework is written using **Swift 5.0**, but there is no code specific to that Swift version. Therefore, it should work with projects using Swift 4.2.

## Installation

You may install the framework either manually or using Carthage.

### Using Carthage

To use Carthage, first make sure you have installed it and updated it to the latest version by following their instructions on [their repo](https://github.com/Carthage/Carthage).

1. Add MathExpression to your `Cartfile`:

```ruby
github "peredaniel/MathPrimality" ~> 1.0.0
```

2. Install the new framework by running Carthage:

```
$ carthage update
```

### Manual installation

We encourage using Carthage to install your dependencies, but in case you can't use any of these dependency managers, you can install the framework manually as follows:

1. Clone or download this repository.
2. Drag the folder `Source` contained within the `MathPrimality` folder into your project.

## Getting started

After installing the framework by any means of the above described, you can import the module by adding the following line in the "header" of any of your swift files:
```swift
import MathPrimality
```

### Primality tests

A "primality test" is any structure conforming to the `PrimalityTest` protocol:
```swift
public protocol PrimalityTest {
    static func test(_ n: Int, iterations k: Int) -> Bool
}
```

The parameters represent the following:
* `n: Int` is the number that we are testing for primality. It is important to note that the internal implementation of the primality tests, including some default functions implemented as extensions of the protocol, do convert the `Int` instance to a `UInt64` instance to prevent the computations to overflow.
* `k: Int` is the number of iterations that the primality test must run. Most primality tests, including the two implementations provided, are probabilistic algorithms. That is, algorithms that are run a certain number of times. You may run the deterministic version of the algorithm by passing 0 as a parameter. In most cases, 10 iterations are fast enough and have a sufficiently high rate of success.

#### Fermat primality test

Fermat primality test is based on the "reverse" of [Fermat's Little Theorem](https://en.wikipedia.org/wiki/Fermat%27s_little_theorem) to test primality. Note that we quote "reverse" in purpose, since Fermat's Little Theorem does have an implication only in one direction (*if a is prime, then ...*). As a consequence, there are composite numbers which give false positives using Fermat's primality test. For instance, all of the [Carmichael Numbers](https://en.wikipedia.org/wiki/Carmichael_number) are composite numbers satisfying the thesis of Fermat's Theorem.

To use Fermat's primality test in our code, we must import the framework in our Swift file:
```swift
import MathPrimality
```

And then we can use the deterministic version of the test wherever we want by using the following code:
```swift
FermatPrimalityTest.test(number)
```
where `number` is an `Int` instance we want to test for primality.

In case we want to use the probabilistic version, we must use the following code:
```swift
FermatPrimalityTest.test(number, iterations: iterations)
```
where `iterations` is the number of times we want to run the algorithm.

#### Miller-Rabin primality test

Miller-Rabin primality uses a different property natural to prime numbers to test for primality, and overcomes the drawback posed by Carmichael Numbers in Fermat's primality test.

To use Miller-Rabin primality test in our code, we must import the framework in our Swift file:
```swift
import MathPrimality
```

And then we can use the deterministic version of the test wherever we want by using the following code:
```swift
MillerRabinPrimalityTest.test(number)
```
where `number` is an `Int` instance we want to test for primality.

In case we want to use the probabilistic version, we must use the following code:
```swift
MillerRabinPrimalityTest.test(number, iterations: iterations)
```
where `iterations` is the number of times we want to run the algorithm.

### Sieves

Sieves are algorithms that, given an upper bound, they produce a sequence of prime numbers up to that limit. There are several different implementations of sieves. The most usual (which is the one that we include in the framework) is the [Eratosthenes' Sieve](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes), but there also exist the [Sundaram's Sieve](https://en.wikipedia.org/wiki/Sieve_of_Sundaram) or the [Atkin's Sieve](https://en.wikipedia.org/wiki/Sieve_of_Atkin).

#### Eratosthenes' sieve

Eratosthenes' sieve is, in my opinion, the simplest and easiest sieve to understand and implement to generate prime numbers. The idea behind this sieve is the following:
1. Create a list of consecutive integers from 2 through n: (2, 3, 4, ..., n).
2. Initially, let `p = 2`, the smallest prime number.
3. Enumerate the multiples of `p` by counting in increments of `p` from `2 * p` to `n`, and mark them in the list (these will be `2 * p`, `3 * p`, `4 * p`, ...; the `p` itself should not be marked).
4. Find the first number greater than `p` in the list that is not marked. If there was no such number, stop. Otherwise, let `p` now equal this new number (which is the next prime), and repeat from step 3.
5. When the algorithm terminates, the numbers remaining not marked in the list are all the primes below `n`.

In fact, the algorithm can be easily speeded up (quite a lot) just by taking increments of `p` from `p * p` (instead of `2 * p`) to `n` in step 3.

In the implementation provided we use a `Sequence` as the base for our sieve, and then an object conforming to `IteratorProtocol` to generate the prime numbers. To use the sieve in our code we must import the framework in our Swift file:
```swift
import MathPrimality
```

Then we can use the Eratosthenes' sieve to compute the primer numbers up to a certain limit using the following code:
```swift
EratosthenesSieve(upTo: limit)
```
This creates a sequence of integers of all the prime numbers between 2 and `limit` (including `limit` if it's prime).

We also include an unbounded version of Eratosthenes' sieve that enables use to compute primes up to any number we want. To do so, we can use the following code:
```swift
let sieve = EratosthenesSieve()
sieve.prefix(n)
```
This creates a sequence of primes of `n` elements.

The main differences between the two implementations are the following:
* The bounded version of Eratosthenes' computes the sequence up to a certain **upper bound**, whereas the unbounded version does compute the sequence up to a certain **index**. For instance, is we want to compute the list of prime numbers between 1 and 1,000,000, the bounded version's code would read:
```swift
let sieve = EratosthenesSieve(upTo: 1000000)
```
On the other hand, the unbounded version would read:
```swift
let sieve = EratosthenesSieve()
sieve.prefix(78498)
```
since 78,498 is the index of the highest prime below 1,000,000.
* The bounded version of Eratosthenes' sieve is, by far, faster than the unbounded version. So, in case of knowing the upper limit of our sequence, it's better to use this version.
* The bounded version has no memory. This means that if we use the bounded version to first compute the prime numbers up to 1,000,000 and then we need to compute the prime numbers up to 1,001,000, all of the previous calculations will be lost and we'll need to recompute them. On the other hand, the unbounded version does use the previous calculations, and therefore in the previous example it would only compute the remaining primes.

### Example app: Optimus Prime

This repository includes an example app providing a fun interface to use the unbounded Eratosthenes' Sieve to compute primes up to index 80,000, and list of primes in a closed range contained in 1...80000.

## Contributing

This framework has been developed to be used as test and demonstration code. Therefore, it's really far from being complete in any sense. Please don't hesitate to ask for additional demonstration code, or forking this repository if you want to use it for you own tests. In any case, if you feel that you can contribute to it in any way, don't hesitate to open an issue or a pull request with your idea, and we'll be happy to read and discuss it!

### Code styling guide and formatter

We follow the [Ray Wenderlich Swift Style Guide](https://github.com/raywenderlich/swift-style-guide), except for the [Spacing](https://github.com/raywenderlich/swift-style-guide#spacing) section: we use **4 spaces** instead of 2 to indent.

To enforce the guidelines in the aforementioned code style guide, we use [SwiftFormat](https://github.com/nicklockwood/SwiftFormat). The set of rules is checked into this repository in the file `.swiftformat`. Before pushing any code, please follow the instructions in [How do I install it?](https://github.com/nicklockwood/SwiftFormat/#how-do-i-install-it) to install `SwiftFormat` and execute the following command in the root directory of the project:
```
swiftformat . --config .swiftformat --swiftversion 5.0
```

This will re-format every `*.swift` file inside the project folder to follow the guidelines.

## Acknowledgments

Part of the code in this framework comes from other frameworks in GitHub, some of those not maintained anymore.
* [Project Euler Swift](https://github.com/CAD97/ProjectEulerSwift) contains the original implementations of `Heap`, `PriorityQueue` and `Eratosthenes Sieve`.