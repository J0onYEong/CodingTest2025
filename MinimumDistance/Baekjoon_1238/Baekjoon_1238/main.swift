//
//  main.swift
//  Baekjoon_1238
//
//  Created by choijunios on 6/20/25.
//

struct MinHeap<T: Comparable> {
    
    private var list: [T] = []
    
    var isEmpty: Bool { list.isEmpty }
    
    mutating func insert(_ element: T) {
        list.append(element)
        
        if list.count < 2 { return }
        
        bottomUpBalancing(list.count-1)
    }
    
    mutating func pop() -> T? {
        
        guard !list.isEmpty else { return nil }
        
        if list.count < 2 {
            return list.removeFirst()
        } else {
            let rootElement = list.first!
            
            list[0] = list.removeLast()
            topDownBalancing(0)
            
            return rootElement
        }
    }
    
    // 시작 위치의 인덱스를 제외한 트리는 규칙을 만족함을 전제함
    
    private mutating func topDownBalancing(_ startIndex: Int) {
        let leftChildIndex = 2*startIndex + 1
        let rightChildIndex = leftChildIndex + 1
        
        var minIndex = startIndex
        
        // 왼쪽 자식 확인
        if leftChildIndex < list.count {
            if list[leftChildIndex] < list[minIndex] {
                minIndex = leftChildIndex
            }
        }
        
        // 오른쪽 자식 확인
        if rightChildIndex < list.count {
            if list[rightChildIndex] < list[minIndex] {
                minIndex = rightChildIndex
            }
        }
        
        guard minIndex != startIndex else {
            // 밸런싱할 필요가 없는 경우
            return
        }
        
        swapElement(minIndex, startIndex)
        topDownBalancing(minIndex)
    }
    
    mutating func bottomUpBalancing(_ startIndex: Int) {
        guard startIndex != 0 else {
            // 루트는 부모가 없음으로
            return
        }
        
        let parentIndex: Int = (startIndex - 1) / 2
        
        if list[parentIndex] > list[startIndex] {
            // 현재노드가 더 작은 경우
            swapElement(parentIndex, startIndex)
            bottomUpBalancing(parentIndex)
        }
    }
    
    private mutating func swapElement(_ lhs: Int, _ rhs: Int) {
        let temp = list[lhs]
        list[lhs] = list[rhs]
        list[rhs] = temp
    }
}

struct DirectedEdge {
    let start: Int
    let end: Int
    let weight: Int
    
    var reversing:  Self {
        DirectedEdge(start: end, end: start, weight: weight)
    }
}

struct Node: Identifiable {
    let id: Int
}

struct Solution {
    
    private struct WeightAndNode: Comparable {
        let nodeId: Int
        let weight: Int
        
        static func < (lhs: WeightAndNode, rhs: WeightAndNode) -> Bool {
            return lhs.weight < rhs.weight
        }
    }
    
    private static func dijkstra(startNode: Node, nodes: [Node], edges: [DirectedEdge]) -> [Int: Int] {
        
        let edgeDict: [Int: [DirectedEdge]] = edges.reduce(into: [:]) { partialResult, edge in
            partialResult[edge.start, default: []].append(edge)
        }
        
        var minHeap: MinHeap<WeightAndNode> = .init()
        minHeap.insert(.init(nodeId: startNode.id, weight: 0))
        
        var dists: [Int: Int] = nodes.reduce(into: [:]) { partialResult, node in
            partialResult[node.id] = Int.max
        }
        dists[startNode.id] = 0
        
        while let element = minHeap.pop() {
            let currentNodeId = element.nodeId
            let accumulatedWeight = element.weight
            
            if let nodeEdges = edgeDict[currentNodeId] {
                
                for edge in nodeEdges {
                    
                    let endNodeId = edge.end
                    let weight = edge.weight
                    let nextMoveWeight = accumulatedWeight+weight
                    
                    if nextMoveWeight < dists[endNodeId]! {
                        // 기존의 값보다 작은 경우에만
                        dists[endNodeId] = nextMoveWeight
                        minHeap.insert(.init(nodeId: endNodeId, weight: nextMoveWeight))
                    }
                }
            }
        }
        return dists
    }
    
    static func solution(partyNode: Node, nodes: [Node], edges: [DirectedEdge]) -> Int {
        
        guard nodes.contains(where: { $0.id == partyNode.id })
        else { fatalError() }
        
        // #1. 약방향 연산(각자 마을 -> 파티 장소)
        let goPartyDists = dijkstra(
            startNode: partyNode,
            nodes: nodes,
            edges: edges.map { $0.reversing }
        )
        
        // #2. 정방향 연산(파티 장소 -> 각자 마을)
        let goHomeRoadDists = dijkstra(
            startNode: partyNode,
            nodes: nodes,
            edges: edges
        )
        
        
        // #3. 두개를 합친 후 최대 소요시간 도출
        let totalMoveDists = goPartyDists.merging(goHomeRoadDists, uniquingKeysWith: +)
        
        return totalMoveDists.values.sorted(by: >).first!
    }
}


// n, m, x
let firstLine = readLine()!
    .split(separator: " ")
    .map(String.init)
    .compactMap(Int.init)

let n = firstLine[0]
let m = firstLine[1]
let x = firstLine[2]

var edges: [DirectedEdge] = []
for _ in 0..<m {
    let edgeLine = readLine()!
        .split(separator: " ")
        .map(String.init)
        .compactMap(Int.init)
    edges.append(.init(
        start: edgeLine[0],
        end: edgeLine[1],
        weight: edgeLine[2]
    ))
}

let result = Solution.solution(
    partyNode: Node(id: x),
    nodes: (1...n).map(Node.init),
    edges: edges
)

print(result)
