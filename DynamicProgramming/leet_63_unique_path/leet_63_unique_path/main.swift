//
//  main.swift
//  leet_63_unique_path
//
//  Created by choijunios on 6/13/25.
//

class Solution {
    func uniquePathsWithObstacles(_ obstacleGrid: [[Int]]) -> Int {
        
        let m = obstacleGrid.count
        let n = obstacleGrid.first!.count

        if obstacleGrid[0][0] == 1 { return 0 }

        let NOT_VISIT = -1
        
        var pathCountPerCell: [[Int]] = Array(
            repeating: Array(repeating: NOT_VISIT, count: n),
            count: m
        )
        
        // 0 - 아래로 이동, 1 - 우측으로 이동
        let moveX: [Int] = [1, 0]
        let moveY: [Int] = [0, 1]
        
        
        var searchTargetsQueue: [(Int, Int)] = []
        var nextSearchTargetsQueue: [(Int, Int)] = []
        
        // 탐색 시작전 전처리
        pathCountPerCell[0][0] = 1
        searchTargetsQueue.append((0, 0))
        
        
        while !searchTargetsQueue.isEmpty {
            
            let currentPosition = searchTargetsQueue.removeFirst()
            
            let currentY = currentPosition.0
            let currentX = currentPosition.1
            let currentPathCount = pathCountPerCell[currentY][currentX]
            
            for moveDirectionIndex in 0..<moveX.count {
                let dy = moveY[moveDirectionIndex]
                let dx = moveX[moveDirectionIndex]
                
                let nextY = currentY + dy
                let nextX = currentX + dx
                
                guard
                    nextY >= 0, nextY < m,
                    nextX >= 0, nextX < n,
                    obstacleGrid[nextY][nextX] == 0
                else { continue }
                
                
                if pathCountPerCell[nextY][nextX] == NOT_VISIT {
                    
                    // 첫 방문인 경우 다음 탐색 큐에 넣습니다.
                    nextSearchTargetsQueue.append((nextY, nextX))
                    pathCountPerCell[nextY][nextX] = 0
                    
                }
                
                // 현재 탐색Path를 해당 셀의 총 길 횟수에 더합니다.
                pathCountPerCell[nextY][nextX] += currentPathCount
            }
            
            if searchTargetsQueue.isEmpty {
                searchTargetsQueue = nextSearchTargetsQueue
                nextSearchTargetsQueue = []
            }
        }
        
        let answer = pathCountPerCell[m-1][n-1]
        return answer == NOT_VISIT ? 0 : answer
    }
}
