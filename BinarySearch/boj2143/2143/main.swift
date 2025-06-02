//
//  main.swift
//  2143
//
//  Created by choijunios on 6/2/25.
//

import Foundation

/// 특정 배열의 연속하는 부분 배열을 부배열이라고 한다.
/// A, B라는 두 배열이 주어질때 두 배열의 부배열 요소들의 합이 T가되는 부 배열 쌍의 개수를 구해라
/// 입력:
///     T: -1B...1B
///     n: 1...1K
///     m: 1...1K
///     각배열의 원소: -1M...1M
///
/// 출력: 가능한 쌍의수, 한가지도 없으면 0을 출력

func get_range_sum_arr(arr: [Int32]) -> [Int32] {
    var temp_sum: Int32 = 0
    var range_sum_arr: [Int32] = []
    for index in 0..<arr.count {
        temp_sum += arr[index]
        range_sum_arr.append(temp_sum)
    }
    return range_sum_arr
}

func get_range_sum(_ sum_arr: [Int32], start: Int, end: Int) -> Int32 {
    let begin = start - 1
    if begin < 0 {
        return sum_arr[end]
    }
    return sum_arr[end] - sum_arr[begin]
}

func get_permutation(_ arr: [Int32]) -> [Int32] {
    var p_list: [Int32] = []
    let arr_cnt = arr.count
    for size in 1...arr_cnt {
        for start_index in 0...(arr_cnt-size) {
            let sum = get_range_sum(arr, start: start_index, end: start_index+size-1)
            p_list.append(sum)
        }
    }
    return p_list
}


extension Array where Element: Comparable {
    func lower_bound(_ element: Element) -> Int? {
        var left = 0
        var right = count-1
        var target_index: Int?
        while left <= right {
            let middle = (left + right)/2
            let me = self[middle]
            if me < element {
                left = middle+1
            } else if me > element {
                right = middle-1
            } else {
                // 값이 일치하는 경우 범위를 더 줄인다.
                target_index = middle
                right = middle-1
            }
        }
        return target_index
    }
    
    func upper_bound(_ element: Element) -> Int? {
        var left = 0
        var right = count-1
        var target_index: Int?
        while left <= right {
            let middle = (left + right)/2
            let me = self[middle]
            if me < element {
                left = middle+1
            } else if me > element {
                // 중간값이 더 큰 경우만 기록한다.
                right = middle-1
            } else {
                // 값이 일치하는 경우 큰쪽으로 이동
                left = middle+1
                target_index = middle
            }
        }
        guard let ti = target_index else { return nil }
        return ti + 1
    }
}


func solution(t: Int32, n: Int32, n_arr: [Int32], m: Int32, m_arr: [Int32]) -> Int64 {
    let range_sum_for_n = get_range_sum_arr(arr: n_arr)
    let range_sum_for_m = get_range_sum_arr(arr: m_arr)
    
    let p_list_for_n = get_permutation(range_sum_for_n).sorted()
    let p_list_for_m = get_permutation(range_sum_for_m).sorted()
    
    var answer: Int64 = 0
    
    for element in p_list_for_n {
        let rest = t - element
        let lb_index = p_list_for_m.lower_bound(rest)
        let ub_index = p_list_for_m.upper_bound(rest)
        guard let li = lb_index, let ui = ub_index else { continue }
        answer += Int64(ui - li)
    }
    return answer
}


let t = Int32(readLine()!)!
let n = Int32(readLine()!)!
let n_arr: [Int32] = readLine()!.split(separator: " ").map { Int32($0)! }
let m = Int32(readLine()!)!
let m_arr: [Int32] = readLine()!.split(separator: " ").map { Int32($0)! }
let result = solution(t: t, n: n, n_arr: n_arr, m: m, m_arr: m_arr)
print(result)
