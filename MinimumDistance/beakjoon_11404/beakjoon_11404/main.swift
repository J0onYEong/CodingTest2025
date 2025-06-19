//
//  main.swift
//  beakjoon_11404
//
//  Created by choijunios on 6/19/25.
//

import Foundation

func solution(n: Int, m: Int, edgeList: [(Int, Int, Int)]) -> [[Int]] {
    
    // INF값은 모든 간선 가중치의 합 * 2
    let INF = edgeList.map(\.2).reduce(0, +) * 2
    var dists: [[Int]] = Array(repeating: Array(repeating: INF, count: n), count: n)
    for edge in edgeList {
        let start = edge.0-1
        let end = edge.1-1
        let weight = edge.2
        dists[start][end] = min(dists[start][end], weight)
    }
    
    for nodeIndex in 0..<n {
        dists[nodeIndex][nodeIndex] = 0
    }
    
    for middleNodeIndex in 0..<n {
        for startNodeIndex in 0..<n {
            for endNodeIndex in 0..<n {
                
                let temp = dists[startNodeIndex][middleNodeIndex] + dists[middleNodeIndex][endNodeIndex]
                
                dists[startNodeIndex][endNodeIndex] = min(
                    dists[startNodeIndex][endNodeIndex],
                    temp
                )
            }
        }
    }
    
    for si in 0..<n {
        for ei in 0..<n {
            if dists[si][ei] == INF {
                dists[si][ei] = 0
            }
        }
    }
    
    return dists
}


let n = Int(readLine()!)!
let m = Int(readLine()!)!
var edges: [(Int, Int, Int)] = []
for _ in 0..<m {
    let edgeComponents = readLine()!
        .split(separator: " ")
        .map(String.init)
        .compactMap(Int.init)
    
    edges.append((edgeComponents[0], edgeComponents[1], edgeComponents[2]))
}

let result = solution(n: n, m: m, edgeList: edges)

for nodeIndex in 0..<n {
    let dists = result[nodeIndex]
    dists.forEach { dist in
        print(dist, terminator: " ")
    }
    print()
}


