import Foundation
//문제풀이 당시 Heap 부분 구현이 난해해서 Heap 구현은 다른데서 제작한 코드를 사용함
struct MinHeap<T: Comparable> {
    var heap: [T] = []
    
    var isEmpty: Bool {
        return heap.count <= 1 ? true : false
    }
    
    init() {}
    init(_ element: T) {
        heap.append(element) // 0번 index채우기 용
        heap.append(element) // 실제 Root Node 채움.
    }
    mutating func counting() -> Int{
      return heap.count-1
    }
    mutating func topValue() -> T{
      return heap[1]
    }
    mutating func insert(_ element: T) {
        if heap.isEmpty {
            heap.append(element)
            heap.append(element)
            return
        }
        heap.append(element)
        
        func isMoveUp(_ insertIndex: Int) -> Bool {
            if insertIndex <= 1 { // Root Node일 때,
                return false
            }
            let parentIndex = insertIndex / 2
            return heap[insertIndex] < heap[parentIndex] ? true : false
        }
        
        var insertIndex = heap.count - 1
        while isMoveUp(insertIndex) {
            let parentIndex = insertIndex / 2
            heap.swapAt(insertIndex, parentIndex)
            insertIndex = parentIndex
        }
    }
    
    enum moveDownStatus { case left, right, none }
    
    mutating func pop() -> T? {
        if heap.count <= 1 {
            return nil
        }
        let returnData = heap[1]
        heap.swapAt(1, heap.count - 1)
        heap.removeLast()
        
        func moveDown(_ poppedIndex: Int) -> moveDownStatus {
            let leftChildIndex = poppedIndex * 2
            let rightChildIndex = leftChildIndex + 1
            
            // case1. 모든(왼쪽) 자식 노드가 없는 경우(완전이진트리는 왼쪽부터 채워지므로)
            if leftChildIndex >= heap.count {
                return .none
            }
            
            // case2. 왼쪽 자식 노드만 있는 경우
            if rightChildIndex >= heap.count {
                return heap[leftChildIndex] < heap[poppedIndex] ? .left : .none
            }
            
            // case3. 왼쪽&오른쪽 자식 노드 모두 있는 경우
            // case3-1. 자식들이 자신보다 모두 큰 경우(자신이 제일 작은 경우)
            if (heap[leftChildIndex] > heap[poppedIndex]) && (heap[rightChildIndex] > heap[poppedIndex]) {
                return .none
            }
            
            // case3-2. 자식들이 자신보다 모두 작은 경우(왼쪽과 오른쪽 자식 중, 더 작은 자식을 선별)
            if (heap[leftChildIndex] < heap[poppedIndex]) && (heap[rightChildIndex] < heap[poppedIndex]) {
                return heap[leftChildIndex] < heap[rightChildIndex] ? .left : .right
            }
            
            // case3-3. 왼쪽과 오른쪽 자식 중, 한 자식만 자신보다 작은 경우
            if (heap[leftChildIndex] < heap[poppedIndex]) || (heap[rightChildIndex] < heap[poppedIndex]) {
                return heap[leftChildIndex] < heap[rightChildIndex] ? .left : .right
            }
            
            return .none
        }
        
        var poppedIndex = 1
        while true {
            switch moveDown(poppedIndex) {
            case .none:
                return returnData
            case .left:
                let leftChildIndex = poppedIndex * 2
                heap.swapAt(poppedIndex, leftChildIndex)
                poppedIndex = leftChildIndex
            case .right:
                let rightChildIndex = (poppedIndex * 2) + 1
                heap.swapAt(poppedIndex, rightChildIndex)
                poppedIndex = rightChildIndex
            }
        }
    }
}

var ClassroomHeap : MinHeap<Int> = MinHeap()
let Session = Int(readLine()!)!
var Time = [[Int]]()

for _ in 1...Session{
  Time.append(readLine()!.split(separator: " ").map { Int($0)! })
}

Time = Time.sorted(by: {$0[0] < $1[0]})
Time = Time.sorted(by: {($0[0] == $1[0])&&($0[1] < $1[1])})

ClassroomHeap.insert(Time[0][1])

for i in 1...Session-1{
    if(Time[i][0] >= Int(ClassroomHeap.topValue())){
        ClassroomHeap.pop()
        ClassroomHeap.insert(Time[i][1])
    }
    else if(Time[i][0] < ClassroomHeap.topValue()){
      ClassroomHeap.insert(Time[i][1])
    }
}

print(ClassroomHeap.counting())