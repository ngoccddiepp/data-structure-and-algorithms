/// Compared
/*
 - Bubble Sort works by repeatedly swapping the adjacent elements if they are in wrong order
 - Time Complexity: O(n^2)
 - Space Complexity: O(1)
 */

func bubbleSort<Element: Comparable>(_ array: inout [Element]) {
    guard array.count > 1 else {
        return
    }
    
    for sortedSize in 0 ..< array.count - 1 {
        var swapped = false
        for index in 0 ..< array.count - sortedSize - 1 {
            if array[index] > array[index + 1] {
                array.swapAt(index, index + 1)
                swapped = true
            }
        }
        if !swapped {
            return
        }
    }
}

/*
 - Selection Sort works by repeatedly swapping item at current index (current index increase 1 when switched) with item had lowest value
 - Time Complexity: O(n^2)
 - Space Complexity: O(1)
 */

func selectionSort<Element: Comparable>(_ array: inout [Element]) {
    guard array.count > 1 else {
        return
    }
    
    var swapIndex = 0
    
    for sortedSize in 0 ..< array.count {
        swapIndex = sortedSize
        for index in sortedSize ..< array.count {
            if array[swapIndex] > array[index] {
                swapIndex = index
            }
        }
        if swapIndex != sortedSize {
            array.swapAt(sortedSize, swapIndex)
        }
    }
}

/*
 - Insertion Sort works by splitting current array into two parts (one in them are sorted), compare each element with elements in sorted part.
 - Time Complexity: O(n^2)
 - Space Complexity: O(1)
 */

func insertionSort<Element: Comparable>(_ array: inout [Element]){
    guard array.count > 1 else {
        return
    }
    
    for current in 1 ..< array.count {
        for shifting in (1...current).reversed() {
            if array[shifting] < array[shifting - 1] {
                array.swapAt(shifting, shifting - 1)
            } else {
                break
            }
        }
    }
}

/*
 - Merge Sort works by using recursion to split array to sub-arrays which are sorted then merging those sub-arrays to result.
 - Time Complexity: O(nlogn)
 - Space Complexity: O(n)
 */

func mergeSort<Element: Comparable>(_ array: [Element]) -> [Element] {
    guard array.count > 1 else {
        return array
    }
    
    let middle = array.count / 2
    let left = mergeSort(Array(array[..<middle]))
    let right = mergeSort(Array(array[middle...]))
    
    return merge(left, right)
}

func merge<Element: Comparable>(_ left: [Element], _ right: [Element]) -> [Element] {
    var leftIndex = 0
    var rightIndex = 0
    
    var result: [Element] = []
    
    while leftIndex < left.count && rightIndex < right.count {
        let leftElement = left[leftIndex]
        let rightElement = right[rightIndex]
        
        if leftElement < rightElement {
            result.append(leftElement)
            leftIndex += 1
        } else if leftElement > rightElement {
            result.append(rightElement)
            rightIndex += 1
        } else {
            result.append(leftElement)
            leftIndex += 1
            result.append(rightElement)
            rightIndex += 1
        }
    }
    
    if leftIndex < left.count {
        result.append(contentsOf: left[leftIndex...])
    }
    if rightIndex < right.count {
        result.append(contentsOf: right[rightIndex...])
        
    }
    return result
}

/*
 - Quick Sort works by using "Partitioning Atrategies" to sort array:
 + Choose middle element as a pivot
 + Lomuto’s partitioning: Choose last element as a pivot
 + Hoare’s partitioning: Choose first element as a pivot
 + Dutch national flag partitioning
 
 - The most important part of implementing QuickSort is choosing the right partitioning stratery:
   example: arr [8, 7, 6, 5, 4, 3, 2, 1], if we use Lomuto’s partitioning
   ==> less [], equal: [1], greater: [8, 7, 6, 5, 4, 3, 2]
   * So, choosing the first or last element of an sorted array as a pivot makes QuickSort perform like InsertionSort,
   which results in a worst-case performance of O(n^2).
   * Solution: One way to address this problem is by using the median of three pivot selection strategy.
 
 - Time Complexity: O(nlogn)
 - Space Complexity: O(1)
 */

func swap<Element>(_ a: inout [Element], _ i: Int, _ j: Int) {
    if i != j {
        a.swapAt(i, j)
    }
}

func quickSortLomuto<Element: Comparable>(_ array: inout [Element], low: Int, high: Int) {
    if low < high {
        
        /* Implement median of low, center, high to find pivot index. */
        // let pivotIndex = medianOfThree(&array, low: low, high: high)
        // array.swapAt(pivotIndex, high)
        
        let pivot = partitionLomuto(&array, low: low, high: high)
        quickSortLomuto(&array, low: low, high: pivot - 1)
        quickSortLomuto(&array, low: pivot + 1, high: high)
    }
}

func partitionLomuto<Element: Comparable>(_ array: inout [Element], low: Int, high: Int) -> Int {
    let pivot = array[high]
    var i = low
    for j in low ..< high {
        if array[j] <= pivot {
            swap(&array, i, j)
            i += 1
        }
    }
    swap(&array, i, high)
    return i
}

func quickSortHoare<Element: Comparable>(_ array: inout [Element], low: Int, high: Int) {
    if low < high {
        
        /* Implement median of low, center, high to find pivot index. */
        // let pivotIndex = medianOfThree(&array, low: low, high: high)
        // array.swapAt(pivotIndex, low)
        
        let pivot = partitionHoare(&array, low: low, high: high)
        quickSortHoare(&array, low: low, high: pivot - 1)
        quickSortHoare(&array, low: pivot + 1, high: high)
    }
}

func partitionHoare<Element: Comparable>(_ array: inout [Element], low: Int, high: Int) -> Int {
    let pivot = array[low]
    var i = low
    var j = high
    
    while true {
        while array[j] > pivot { j -= 1 }
        while array[i] < pivot { i += 1 }
        
        if i < j {
            swap(&array,i, j)
        } else {
            return j
        }
    }
}

func medianOfThree<Element: Comparable>(_ array: inout [Element], low: Int, high: Int) -> Int {
    let center = (low + high) / 2
    if array[low] > array[center] {
        swap(&array, low, center)
    }
    if array[low] > array[high] {
        swap(&array, low, high)
    }
    if array[center] > array[high] {
        swap(&array, center, high)
    }
    return center
}

func quicksortDutchFlag<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
    if low < high {
        let pivotIndex = medianOfThree(&array, low: low, high: high)
        let (p, q) = partitionDutchFlag(&array, low: low, high: high, pivotIndex: pivotIndex)
        quicksortDutchFlag(&array, low: low, high: p - 1)
        quicksortDutchFlag(&array, low: q + 1, high: high)
    }
}

func partitionDutchFlag<Element: Comparable>(_ a: inout [Element], low: Int, high: Int, pivotIndex: Int) -> (Int, Int) {
    let pivot = a[pivotIndex]
    
    var smaller = low
    var equal = low
    var larger = high
    
    // This loop partitions the array into four (possibly empty) regions:
    //   [low    ...smaller-1] contains all values < pivot,
    //   [smaller...  equal-1] contains all values == pivot,
    //   [larger + 1  ...   high] contains all values > pivot,
    //   [equal ...     larger] are values we haven't looked at yet.
    while equal <= larger {
        if a[equal] < pivot {
            swap(&a, smaller, equal)
            smaller += 1
            equal += 1
        } else if a[equal] == pivot {
            equal += 1
        } else {
            swap(&a, equal, larger)
            larger -= 1
        }
    }
    return (smaller, larger)
}

/*===============================================*/

/// Not Compared

/*
    - Bucket Sort works by dividing elements into groups (buckets), sort them and merge.
 */

func bucketSort(_ nums: inout [Int]) {
    guard nums.count > 1 else {
        return
    }
    
    let max = nums.max()!
    let base = 10
    let numOfBuckets = max / base
    var buckets = [[Int]](repeating: [], count: numOfBuckets + 1)
    
    for num in nums {
        let indexOfBucket = num / base
        buckets[indexOfBucket].append(num)
    }
    
    var result: [Int] = []
    
    let _ = buckets.map{ result.append(contentsOf: $0.sorted()) }
    
    nums = result
}

/*
   - Counting Sort works by creating new array include values are 0 with length equal max value of current array and increasing value at index that equal value of current array.
*/

func countingSort(_ nums: inout [Int]) {
    guard nums.count > 1 else {
        return
    }
    
    let max = nums.max()!
    var countingArray = [Int](repeating: 0, count: max + 1)
    var result: [Int] = []
    
    for num in nums {
        countingArray[num] += 1
    }
    
    for index in countingArray.indices {
        result.append(contentsOf: Array(repeating: index, count: countingArray[index]))
    }
    
    nums = result
}

/*
   - Radix Sort works by dividing elements into groups (buckets), normal case is base by 10.
*/

func radixSort(_ nums: inout [Int]) {
    guard nums.count > 1 else {
        return
    }
    
    let base = 10
    var digits = 1
    var done = false
    
    while !done {
        done = true
        var buckets = [[Int]](repeating: [], count: base)
        nums.forEach { number in
            let remainingPart = number / digits
            let digit = remainingPart % base
            buckets[digit].append(number)
            if remainingPart > 0 {
                done = false
            }
        }
        
        digits *= base
        nums = buckets.flatMap { $0 }
    }
}
