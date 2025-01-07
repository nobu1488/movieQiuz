import UIKit

class StatisticService: StatisticServiceProtocol{
    
    private let storage: UserDefaults = .standard
    
    var gamesCount: Int {
        get{
             return storage.integer(forKey: "gameCount")
        }
        set{
            storage.set(newValue, forKey: "gameCount")
        }
    }
    
    var bestGame: GameResult{
        get{
            return GameResult(correct: storage.integer(forKey: "bestGameCorrect"),
                       total: storage.integer(forKey: "bestGameTotal"),
                       date: UserDefaults.standard.object(forKey: "bestGameDate") as? Date ?? Date())
            
            
        }
        set{
            storage.set(newValue.total, forKey: "bestGameTotal")
            storage.set(newValue.correct, forKey: "bestGameCorrect")
            storage.set(newValue.date, forKey: "bestGameDate")
        }
    }
    
    var totalAccuracy: Double{
        get{
            return storage.double(forKey: "totalAccuracy")
        }
        set{
            storage.set(newValue, forKey: "totalAccuracy")
        }
    }
    
    func store(correct: Int, total: Int) {
        let newResult = GameResult(correct: correct, total: total, date: Date())
        if newResult.comparison(another: bestGame){
            bestGame = newResult
        }
        gamesCount += 1
        let totalCorrectAnswers = newResult.correct + correct
        let totalQuestions = newResult.total + total
        if totalQuestions != 0{
            totalAccuracy = Double(totalCorrectAnswers)/Double(totalQuestions)
        }
        }
}
