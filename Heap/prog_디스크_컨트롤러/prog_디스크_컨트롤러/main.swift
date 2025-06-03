//
//  main.swift
//  prog_디스크_컨트롤러
//
//  Created by choijunios on 6/4/25.
//

import Foundation

// 작업의 번호, 작업의 요청 시각, 작업의 소유 시간을 저장해 두는 대기 큐
// 하드디스크가 작동중이 아니라면, 가장 우선순위가 높은 작업을 실행
// 소요시간 짧은것, 작업의 요청 시각이 빠른 것, 작업의 번호가 작은 것 순
// 작업시작시 마칠때까지 진행
// 작업이 진행중이면 큐로 직행
// 큐에서 작업을 꺼내는 동작은 해당 시점의 모든 작업을 큐에 등록한 이후
// 인풋: [요청 시잠, 소요시간]을 요소로하는 배열이 주어짐
// 결과: 반환시간(종료시간 - 요청시간)의 평균

// 삽입
// - 가장 마지막에 삽입하여 올라가는 형식
// 삭제
// - 마지막 요소를 탑에 넣고 내려가는 형식

class Heap<T> {
    var compare: (T, T) -> Bool
    
    init(compare: @escaping (T, T) -> Bool) {
        self.compare = compare
    }
    
    
    private var list: [T] = []
    
    var isEmpty: Bool { list.isEmpty }
    
    func insert(_ element: T) {
        list.append(element)
        if list.count > 1 {
            bottom_up_balancing(list.endIndex-1)
        }
    }
    
   func pop() -> T? {
       guard list.isEmpty == false else { return nil }
       let top = list[0]
       if list.count > 1 {
           list[0] = list.removeLast()
           top_down_balancing(0)
       } else {
            list = []
       }
       return top
    }
}

extension Heap {
    func bottom_up_balancing(_ index: Int) {
        var current_index = index
        while let pi = get_parent_index(current_index) {
            if compare(list[pi], list[current_index]) {
                swap(pi, current_index)
                current_index = pi
            } else {
                break
            }
        }
    }
    
    func top_down_balancing(_ index: Int) {
        var current_index = index
        while true {
            let left_index = get_left_index(current_index)
            let right_index = get_right_index(current_index)
            var fit_index = current_index
            
            if let li = left_index, compare(list[fit_index], list[li]) {
                fit_index = li
            }
            if let ri = right_index, compare(list[fit_index], list[ri]) {
                fit_index = ri
            }
            
            if fit_index == current_index { break }
            swap(fit_index, current_index)
            current_index = fit_index
        }
    }
}


extension Heap {
    func get_parent_index(_ index: Int) -> Int? {
        if index == 0 { return nil }
        return (index-1)/2
    }
    func get_left_index(_ index: Int) -> Int? {
        let li = 2*index+1
        guard li < list.count else { return nil }
        return li
    }
    func get_right_index(_ index: Int) -> Int? {
        let ri = 2*index+2
        guard ri < list.count else { return nil }
        return ri
    }
    func swap(_ index1: Int, _ index2: Int) {
        let temp = list[index1]
        list[index1] = list[index2]
        list[index2] = temp
    }
}


struct HDDTask: Comparable {
    let number: Int
    let request_time: Int
    let task_duration: Int
    
    // 소요시간 짧은것, 작업의 요청 시각이 빠른 것, 작업의 번호가 작은 것 순
    static func < (lhs: HDDTask, rhs: HDDTask) -> Bool {
        if lhs.task_duration != rhs.task_duration {
            return lhs.task_duration < rhs.task_duration
        } else {
            if lhs.request_time != rhs.request_time {
                return lhs.request_time < rhs.request_time
            } else {
                return lhs.number < rhs.number
            }
        }
    }
}


// jobs길이 1...500
// 요청시점 소요기간 1...1000

func solution(_ jobs:[[Int]]) -> Int {
    
    var tasks: [HDDTask] = []
    for index in 0..<jobs.count {
        let task = HDDTask(
            number: index,
            request_time: jobs[index][0],
            task_duration: jobs[index][1]
        )
        tasks.append(task)
    }
    
    tasks.sort { $0.request_time > $1.request_time }
    
    let minHeap = Heap<HDDTask>(compare: { $0 > $1 })
    var return_time_sum = 0
    let task_cnt = jobs.count
    var time = 0
    
    while !(tasks.isEmpty && minHeap.isEmpty) {
        // 작업 등록
        while let le = tasks.last, le.request_time <= time {
            minHeap.insert(tasks.removeLast())
        }
        
        if let next = minHeap.pop() {
            time += next.task_duration
            return_time_sum += (time - next.request_time)
        } else if let le = tasks.last {
            time = le.request_time
        }
    }
    
    return return_time_sum / task_cnt
}
