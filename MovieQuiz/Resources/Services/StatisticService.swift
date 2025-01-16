import UIKit

class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum keys: String {
        case gameCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalAccuracy
        case correctAmount
    }
    
    var correctAmount: Int{
        get{
            storage.integer(forKey: keys.correctAmount.rawValue)
        }
        set{
            storage.set(newValue, forKey: keys.correctAmount.rawValue)
        }
    }
    
    var gamesCount: Int {
        get{
            storage.integer(forKey: keys.gameCount.rawValue)
        }
        set{
            storage.set(newValue, forKey: keys.gameCount.rawValue)
        }
    }
    
    var bestGame: GameResult{
        get{
            return GameResult(correct: storage.integer(forKey: keys.bestGameCorrect.rawValue),
                              total: storage.integer(forKey: keys.bestGameTotal.rawValue),
                              date: storage.object(forKey: keys.bestGameDate.rawValue) as? Date ?? Date())
            
            
        }
        set{
            storage.set(newValue.total, forKey: keys.bestGameTotal.rawValue)
            storage.set(newValue.correct, forKey: keys.bestGameCorrect.rawValue)
            storage.set(newValue.date, forKey: keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double{
        get{
            return storage.double(forKey: keys.totalAccuracy.rawValue)
        }
        set{
            storage.set(newValue, forKey: keys.totalAccuracy.rawValue)
        }
    }
    
    func store(correct: Int, total: Int) {
        let newResult = GameResult(correct: correct, total: total, date: Date())
        if newResult.comparison(another: bestGame){
            bestGame = newResult
        }
        gamesCount += 1
        correctAmount += newResult.correct
        let totalQuestions = newResult.total + total
        if totalQuestions != 0{
            totalAccuracy = Double(correctAmount)*10/Double(gamesCount)
        }
    }
}
