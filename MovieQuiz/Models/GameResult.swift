import UIKit

struct GameResult {
    var correct: Int
    var total: Int
    var date: Date
    func comparison(another: GameResult) -> Bool{
        correct > another.correct
    }
}
