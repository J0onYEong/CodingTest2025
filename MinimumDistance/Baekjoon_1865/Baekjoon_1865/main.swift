//
//  main.swift
//  Baekjoon_1865
//
//  Created by choijunios on 6/21/25.
//

struct Node {
    let id: Int
}

struct Edge {
    let startNodeId: Int
    let endNodeId: Int
    let weight: Int
}

struct TravelSolution {
    
    static func isTimeReversableCaseAvailable(nodes: [Node], edges: [Edge]) -> Bool {
        
        let INF = 2_500 * 10_000
        
        var dists: [Int: Int] = nodes.reduce(into: [:]) { partialResult, node in
            partialResult[node.id] = INF
        }
        var bfDists: [Int: Int] = [:]
        
        dists[0] = 0
        let nodeCount = nodes.count

        for roopOrder in 0...nodeCount {
            
            for edge in edges {
                
                let startNodeId = edge.startNodeId
                let endNodeId = edge.endNodeId
                let weight = edge.weight
                
                guard
                    let startNodeDist = dists[startNodeId],
                    let endNodeDist = dists[endNodeId]
                else { fatalError("Key not found Error") }
                
                let currentDistanceToEnd = startNodeDist + weight
                
                if currentDistanceToEnd < endNodeDist {
                    dists[endNodeId] = currentDistanceToEnd
                }
            }
            
            if roopOrder == nodeCount-1 {
                bfDists = dists
            }
        }
        
        // 두 딕셔너리가 다르다는 것은 음수사이클이 있음을 의미
        
        return bfDists != dists
    }
}

let tc = Int(readLine()!)!

for _ in 0..<tc {
    
    let line1 = readLine()!
        .split(separator: " ")
        .map(String.init)
        .compactMap(Int.init)
    
    guard line1.count == 3 else { fatalError("Input error") }
    
    let n = line1[0]
    let m = line1[1]
    let w = line1[2]
    
    var edges: [Edge] = []
    
    for _ in 0..<m {
        
        let roadEdgeInfoLine = readLine()!
            .split(separator: " ")
            .map(String.init)
            .compactMap(Int.init)
        
        guard roadEdgeInfoLine.count == 3 else { fatalError("Input error") }
        
        let start = roadEdgeInfoLine[0]
        let end = roadEdgeInfoLine[1]
        let weight = roadEdgeInfoLine[2]
        
        edges.append(contentsOf: [
            .init(startNodeId: start, endNodeId: end, weight: weight),
            .init(startNodeId: end, endNodeId: start, weight: weight),
        ])
    }
    
    for _ in 0..<w {
        let wormHoleEdgeInfoLine = readLine()!
            .split(separator: " ")
            .map(String.init)
            .compactMap(Int.init)
        
        guard wormHoleEdgeInfoLine.count == 3 else { fatalError("Input error") }
        
        let start = wormHoleEdgeInfoLine[0]
        let end = wormHoleEdgeInfoLine[1]
        let weight = wormHoleEdgeInfoLine[2] * -1
        
        edges.append(contentsOf: [
            .init(startNodeId: start, endNodeId: end, weight: weight)
        ])
    }
    
    let nodes = (1...n).map(Node.init)
    
    let result = TravelSolution.isTimeReversableCaseAvailable(
        nodes: nodes,
        edges: edges
    )
    
    print(result ? "YES" : "NO")
}


