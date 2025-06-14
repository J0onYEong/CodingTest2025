//
//  main.swift
//  leet_473_Matchsticks_to_Square
//
//  Created by choijunios on 6/14/25.
//

import Foundation

class Solution {
    
    func backTrace(currentMatchIndex: Int, widths: inout [Int], targetWidth: Int, matches: [Int]) -> Bool {
        
        if currentMatchIndex == matches.count {
            return widths.filter({ $0 == targetWidth }).count == widths.count
        }
        
        for widthIndex in 0..<4 {
            let temp = widths[widthIndex] + matches[currentMatchIndex]
            if temp <= targetWidth {
                widths[widthIndex] = temp
                let result = backTrace(
                    currentMatchIndex: currentMatchIndex+1,
                    widths: &widths,
                    targetWidth: targetWidth,
                    matches: matches
                )
                if result { return true }
                widths[widthIndex] -= matches[currentMatchIndex]
            }
        }
        
        return false
    }
    
    
    func makesquare(_ matchsticks: [Int]) -> Bool {
        
        let sumOfLength = matchsticks.reduce(0, +)
        if sumOfLength % 4 != 0 { return false }
        
        let squareWidth = sumOfLength/4
        var widths = Array(repeating: 0, count: 4)
        
        let sorted = matchsticks.sorted(by: { $0 > $1 })
        let result = backTrace(
            currentMatchIndex: 0,
            widths: &widths,
            targetWidth: squareWidth,
            matches: sorted
        )
        return result
    }
}
