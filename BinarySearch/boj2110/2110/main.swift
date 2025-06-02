//
//  main.swift
//  2110
//
//  Created by choijunios on 5/31/25.
//

import Foundation

/// 도현이내 집은 N개의 수직선 위에 있다.
/// 각집의 좌표는 x1..xn, 모두 상이한 좌표
/// 공유기는 한집에 하나만 설치할 수 있다.
/// 가장 인접한 두 공유기 사이의 거리가 가능한 크게하여 설치하려고 한다.
/// C개의 공유기를 N개의 집에 적당히 설치해서 두 공유기 상이의 거리를 최대로 하는 것이 목표

/// 입력
/// N : 2...20만
/// C : 2...N
/// xi좌표는 1...10억중에 하나씩주어진다.

/// 출력
/// 가장 인접한 두 공유기 사이의 최대 거리


func solution(house_cnt: Int32, max_share_cnt: Int32, share_pos: [Int32]) -> Int32 {
    var left_b: Int32 = 0
    var right_b: Int32 = share_pos.max()!
    let sorted_pos = share_pos.sorted(by: <)
    var shortest_gap: Int32?
    
    while(left_b <= right_b) {
        let middle: Int32 = (left_b + right_b)/2
        var removed_share_cnt: Int32 = 0
        var lastest_point = sorted_pos[0]
        for house_index in 1..<Int(house_cnt) {
            let distance = sorted_pos[house_index] - lastest_point
            if distance < middle {
                // 작거나 같은 경우, 공유기 제거
                removed_share_cnt += 1
            } else {
                // 큰 경우
                lastest_point = sorted_pos[house_index]
            }
        }
        
        let share_cnt = house_cnt - removed_share_cnt
        if share_cnt >= max_share_cnt {
            // 특정 최소 거리를 만족하는 최대 공유기 수가 제한보다 크거나 같은 경우
            shortest_gap = middle
            
            // 공유기 수를 최대한 줄이려면, 제한값을 늘여야한다.
            left_b = middle + 1
        } else {
            // 제한 보다 작은 경우, 공유기 수를 늘려야한다.
            right_b = middle - 1
        }
    }
    return shortest_gap!
}

let inputs1 = readLine()!.split(separator: " ")
let n = Int32(inputs1[0])!
let c = Int32(inputs1[1])!
let house_pos = (0..<n).map { _ in Int32(readLine()!)! }

let result = solution(house_cnt: n, max_share_cnt: c, share_pos: house_pos)
print(result)
