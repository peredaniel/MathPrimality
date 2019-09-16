//
//  Various algorithms modified from https://github.com/raywenderlich/swift-algorithm-club
//  Adapted to Swift 5.0 from https://github.com/CAD97/ProjectEulerSwift/blob/master/ProjectEuler/DataStructures.swift
//
/*
 Copyright (c) 2016 Matthijs Hollemans and contributors

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */

/// A heap is a binary tree that lives inside an array, so it doesn't use parent/child pointers.
/// The tree is partially sorted according to something called the "heap property" that determines the order of the nodes in the tree.
///
/// Common uses for heap:
///
/// - For building priority queues.
/// - The heap is the data structure supporting heap sort.
/// - Heaps are fast for when you often need to compute the minimum (or maximum) element of a collection.
/// - Impressing your non-programmer friends.
///
struct Heap<T> {
    /// The array that stores the heap's nodes.
    var elements = [T]()

    /// Determines whether this is a max-heap (>) or min-heap (<).
    private var isOrderedBefore: (T, T) -> Bool

    /// Creates an empty heap.
    /// The sort function determines whether this is a min-heap or max-heap.
    /// For integers, > makes a max-heap, < makes a min-heap.
    ///
    init(sort: @escaping (T, T) -> Bool) {
        isOrderedBefore = sort
    }

    /// Creates a heap from an array. The order of the array does not matter;
    /// the elements are inserted into the heap in the order determined by the
    /// sort function.
    ///
    init(array: [T], sort: @escaping (T, T) -> Bool) {
        isOrderedBefore = sort
        buildHeap(array)
    }

    /**
     * Converts an array to a max-heap or min-heap in a bottom-up manner.
     * Performance: This runs pretty much in O(n).
     */
    private mutating func buildHeap(_ array: [T]) {
        elements = array
        for i in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
            shiftDown(index: i, heapSize: elements.count)
        }
    }

    var isEmpty: Bool {
        return elements.isEmpty
    }

    var count: Int {
        return elements.count
    }

    /// Returns the index of the parent of the element at index i.
    /// The element at index 0 is the root of the tree and has no parent.
    ///
    @inline(__always) private func indexOfParent(_ i: Int) -> Int {
        return (i - 1) / 2
    }

    /// Returns the index of the left child of the element at index i.
    /// Note that this index can be greater than the heap size, in which case
    /// there is no left child.
    ///
    @inline(__always) private func indexOfLeftChild(_ i: Int) -> Int {
        return 2 * i + 1
    }

    /// Returns the index of the right child of the element at index i.
    /// Note that this index can be greater than the heap size, in which case
    /// there is no right child.
    ///
    @inline(__always) private func indexOfRightChild(_ i: Int) -> Int {
        return 2 * i + 2
    }

    /// Returns the maximum value in the heap (for a max-heap) or the minimum
    /// value (for a min-heap).
    ///
    func peek() -> T? {
        return elements.first
    }

    /// Adds a new value to the heap. This reorders the heap so that the max-heap
    /// or min-heap property still holds. Performance: O(log n).
    ///
    mutating func insert(_ value: T) {
        elements.append(value)
        shiftUp(index: elements.count - 1)
    }

    mutating func insert<S: Sequence>(contentsOf sequence: S) where S.Iterator.Element == T {
        for value in sequence {
            insert(value)
        }
    }

    /// Allows you to change an element. In a max-heap, the new element should be
    /// larger than the old one; in a min-heap it should be smaller.
    ///
    mutating func replace(index i: Int, value: T) {
        guard i < elements.count else { return }

        assert(isOrderedBefore(value, elements[i]))
        elements[i] = value
        shiftUp(index: i)
    }

    /// Removes the root node from the heap. For a max-heap, this is the maximum
    /// value; for a min-heap it is the minimum value. Performance: O(log n).
    ///
    mutating func remove() -> T? {
        if elements.isEmpty {
            return nil
        } else if elements.count == 1 {
            return elements.removeLast()
        } else {
            // Use the last node to replace the first one, then fix the heap by
            // shifting this new first node into its proper position.
            let value = elements[0]
            elements[0] = elements.removeLast()
            shiftDown()
            return value
        }
    }

    /// Removes an arbitrary node from the heap. Performance: O(log n). You need
    /// to know the node's index, which may actually take O(n) steps to find.
    ///
    mutating func remove(atIndex i: Int) -> T? {
        guard i < elements.count else { return nil }

        let size = elements.count - 1
        if i != size {
            elements.swapAt(i, size)
            shiftDown(index: i, heapSize: size)
            shiftUp(index: i)
        }
        return elements.removeLast()
    }

    /// Takes a child node and looks at its parents; if a parent is not larger
    /// (max-heap) or not smaller (min-heap) than the child, we exchange them.
    ///
    private mutating func shiftUp(index: Int) {
        var childIndex = index
        let child = elements[childIndex]
        var parentIndex = indexOfParent(childIndex)

        while childIndex > 0, isOrderedBefore(child, elements[parentIndex]) {
            elements[childIndex] = elements[parentIndex]
            childIndex = parentIndex
            parentIndex = indexOfParent(childIndex)
        }

        elements[childIndex] = child
    }

    mutating func shiftDown() {
        shiftDown(index: 0, heapSize: elements.count)
    }

    /// Looks at a parent node and makes sure it is still larger (max-heap) or
    /// smaller (min-heap) than its childeren.
    ///
    private mutating func shiftDown(index: Int, heapSize: Int) {
        var parentIndex = index

        while true {
            let leftChildIndex = indexOfLeftChild(parentIndex)
            let rightChildIndex = leftChildIndex + 1

            // Figure out which comes first if we order them by the sort function:
            // the parent, the left child, or the right child. If the parent comes
            // first, we're done. If not, that element is out-of-place and we make
            // it "float down" the tree until the heap property is restored.
            var first = parentIndex
            if leftChildIndex < heapSize, isOrderedBefore(elements[leftChildIndex], elements[first]) {
                first = leftChildIndex
            }
            if rightChildIndex < heapSize, isOrderedBefore(elements[rightChildIndex], elements[first]) {
                first = rightChildIndex
            }
            if first == parentIndex { return }

            elements.swapAt(parentIndex, first)
            parentIndex = first
        }
    }
}

// MARK: - Searching

extension Heap where T: Equatable {
    /// Searches the heap for the given element. Performance: O(n).
    ///
    func index(of element: T) -> Int? {
        return index(of: element, 0)
    }

    private func index(of element: T, _ i: Int) -> Int? {
        if i >= count { return nil }
        if isOrderedBefore(element, elements[i]) { return nil }
        if element == elements[i] { return i }
        if let j = index(of: element, indexOfLeftChild(i)) { return j }
        if let j = index(of: element, indexOfRightChild(i)) { return j }
        return nil
    }
}
