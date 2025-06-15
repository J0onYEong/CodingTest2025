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
        
        for setIndex in 0..<sumOfSets.count {
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
        
        return result
    }
}
