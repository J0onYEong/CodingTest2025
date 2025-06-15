//
//  main.swift
//  leet_698_Partition_to_K_Equal_SumSubsets
//
//  Created by choijunios on 6/15/25.
//

class Solution {
    
    private func backTracking(index: Int, nums: [Int], sumOfSets: inout [Int], targetSum: Int) -> Bool {
        
        if index == nums.count {
            // 모든 요소에 대한 서브셋이 결정된 경우
            return sumOfSets.filter({ $0 == targetSum }).count == sumOfSets.count
        }
        
        var failed: Set<Int> = .init()
        for setIndex in 0..<sumOfSets.count {
            
            if failed.contains(sumOfSets[setIndex]) {
                // 실패했던 집합과 동일한 상황을 중복하지 않음
                continue
            }
            
            let currentNumber = nums[index]
            let temp = sumOfSets[setIndex] + currentNumber
            if temp <= targetSum {
                sumOfSets[setIndex] = temp
                let result = backTracking(
                    index: index+1,
                    nums: nums,
                    sumOfSets: &sumOfSets,
                    targetSum: targetSum
                )
                if result {
                    // 해당 선택으로 인한 결과가 합이 같은 서브셋을 만들어낸 경우
                    return true
                }
                sumOfSets[setIndex] -= currentNumber
                failed.insert(sumOfSets[setIndex])
            }
        }
        
        return false
    }
    
    
    private func backTracking(subSetIndex: Int, nums: [Int], numVisit: inout [Bool], sumOfSubSet: inout [Int], targetSum: Int, nextNumIndex: Int) -> Bool {
        
        if subSetIndex == sumOfSubSet.count-1 {
            // 다른 집합들의 총합이 알맞게 채워졌음으로 마지막 집합은 연산 불필요
            return true
        }
        
        if sumOfSubSet[subSetIndex] == targetSum {
            return backTracking(
                subSetIndex: subSetIndex+1,
                nums: nums,
                numVisit: &numVisit,
                sumOfSubSet: &sumOfSubSet,
                targetSum: targetSum,
                nextNumIndex: 0
            )
        }
        
        for numIndex in nextNumIndex..<nums.count {
            if numVisit[numIndex] == false {
                // 방문하지 않은 수인 경우
                let temp = sumOfSubSet[subSetIndex] + nums[numIndex]
                if temp <= targetSum {
                    numVisit[numIndex] = true
                    sumOfSubSet[subSetIndex] = temp
                    let result = backTracking(
                        subSetIndex: subSetIndex,
                        nums: nums,
                        numVisit: &numVisit,
                        sumOfSubSet: &sumOfSubSet,
                        targetSum: targetSum,
                        nextNumIndex: numIndex + 1
                    )
                    if result { return true }
                    sumOfSubSet[subSetIndex] -= nums[numIndex]
                    numVisit[numIndex] = false
                }
            }
        }
        
        return false
    }
    
    
    func canPartitionKSubsets(_ nums: [Int], _ k: Int) -> Bool {
        
        let sumOfNums = nums.reduce(0, +)
        
        if sumOfNums % k != 0 { return false }
        
        var sumOfSets: [Int] = Array(repeating: 0, count: k)
        
        let targetSumOfSet: Int = sumOfNums / k
        
        let sorted = nums.sorted(by: { $0 > $1 })
        
        let result = backTracking(
            index: 0,
            nums: sorted,
            sumOfSets: &sumOfSets,
            targetSum: targetSumOfSet
        )
        
//        var numVisit: [Bool] = Array(repeating: false, count: nums.count)
//        
//        let result = backTracking(
//            subSetIndex: 0,
//            nums: sorted,
//            numVisit: &numVisit,
//            sumOfSubSet: &sumOfSets,
//            targetSum: targetSumOfSet,
//            nextNumIndex: 0
//        )
        
        return result
    }
}
