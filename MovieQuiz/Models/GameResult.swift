import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func comparison(another: GameResult) -> Bool{
        correct > another.correct
    }
}
