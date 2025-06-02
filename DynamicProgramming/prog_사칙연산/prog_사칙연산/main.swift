import Foundation

/// 문자열 형태의 숫자와 더하기, 뺄셈 기호가 들어있는 배열이 주어진다.
/// 결과: 서로다른 연산순서의 계산 결과 중 최댓값을 반환
/// 입력 제한:
///     배열은 +,-과 숫자가 들어있는 배열이며 길이는 3...201
///     숫자의 개수는 2개이상 101개 이하, 연산자의 개수는 숫자보다 하나 작다.
///     숫자는 1...1K, 문자열 형태의 자연수
///     숫자와 연산자가 항상 번갈아가며 들어있다.
///
///  DP문제는 2가지 초점을 가진다.
///  - 해는 최적의 부분들로 구성된다.
///  - 부분들의 중복 연산을 막는다.

struct CalcResult {
    var maxValue: Int = 0
    var minValue: Int = 0
}

func solution(_ input_array:[String]) -> Int
{
    var answer = -1
    
    let operator_cnt = (input_array.count-1)/2
    let number_cnt = operator_cnt+1
    
    var dp: [[CalcResult]] = Array(repeating: Array(repeating: .init(), count: number_cnt), count: number_cnt)
    
    for number_index in 0..<number_cnt {
        let number = Int(input_array[number_index*2])!
        dp[number_index][number_index].maxValue = number
        dp[number_index][number_index].minValue = number
    }
    
    for size in 2...number_cnt {
        for start_number_index in 0...(number_cnt-size) {
            let end_number_index = start_number_index+size-1
            
            var max_value = -200_000
            var min_value = 200_000
            
            for inner_size in 1..<size {
                let second_number_index = start_number_index+(inner_size-1)
                let third_number_index = second_number_index+1
                let left_number = dp[start_number_index][second_number_index]
                let right_number = dp[third_number_index][end_number_index]
                
                let operator_index = second_number_index*2 + 1
                let operator_value = input_array[operator_index]
                
                if operator_value == "+" {
                    max_value = max(max_value, left_number.maxValue + right_number.maxValue)
                    min_value = min(min_value, left_number.minValue + right_number.minValue)
                } else {
                    max_value = max(max_value, left_number.maxValue - right_number.minValue)
                    min_value = min(min_value, left_number.minValue - right_number.maxValue)
                }
            }
            dp[start_number_index][end_number_index].minValue = min_value
            dp[start_number_index][end_number_index].maxValue = max_value
        }
    }
    answer = dp[0][number_cnt-1].maxValue
    return answer
}
