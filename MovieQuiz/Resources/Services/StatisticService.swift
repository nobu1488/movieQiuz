import UIKit

class StatisticService: StatisticServiceProtocol {
    
    private let storage: UserDefaults = .standard
    
    private enum Keys: String {
        case gameCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalAccuracy
        case correctAmount
    }
    
    var correctAmount: Int{
        get{
            storage.integer(forKey: Keys.correctAmount.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.correctAmount.rawValue)
        }
    }
    
    var gamesCount: Int {
        get{
            storage.integer(forKey: Keys.gameCount.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.gameCount.rawValue)
        }
    }
    
    var bestGame: GameResult{
        get{
            return GameResult(correct: storage.integer(forKey: Keys.bestGameCorrect.rawValue),
                              total: storage.integer(forKey: Keys.bestGameTotal.rawValue),
                              date: storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date())
            
            
        }
        set{
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double{
        get{
            return storage.double(forKey: Keys.totalAccuracy.rawValue)
        }
        set{
            storage.set(newValue, forKey: Keys.totalAccuracy.rawValue)
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
