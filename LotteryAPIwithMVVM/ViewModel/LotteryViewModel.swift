//
//  LotteryViewModel.swift
//  LotteryAPIwithMVVM
//
//  Created by LOUIE MAC on 2023/09/14.
//

import Foundation

class LotteryViewModel {
    
    private let networkManager = NetworkManager.shared
    
    public private(set) var dateArray:[Int] = []
    private var initialNumber = 1084

    
    var number1 = Observable(0)
    var number2 = Observable(0)
    var number3 = Observable(0)
    var number4 = Observable(0)
    var number5 = Observable(0)
    var number6 = Observable(0)
    var number7 = Observable(0)
    var winning = Observable("")
    
    lazy var numbersArray = [number1, number2, number3, number4, number5, number6, number7]
    
    
    func fetchLottoAPI(round: Int) {
        networkManager.callRequest(round: round) { [weak self] result in
            
            switch result {
            case .success(let result):
                self?.number1.value = result.drwtNo1
                self?.number2.value = result.drwtNo2
                self?.number3.value = result.drwtNo3
                self?.number4.value = result.drwtNo4
                self?.number5.value = result.drwtNo5
                self?.number6.value = result.drwtNo6
                self?.number7.value = result.bnusNo
                self?.winning.value = self?.format(for: result.firstWinamnt) ?? ""
                
            case .failure(let error):
                switch error {
                case .dataError:
                    print("데이터 에러")
                case .networkingError:
                    print("네트워킹 에러")
                case .parseError:
                    print("파싱에러")
                }
            }
        }
    }
    
    func format(for number:Int) -> String {
        let numberformat = NumberFormatter()
        numberformat.numberStyle = .decimal
        return numberformat.string(for: number)!
    }
    
    func makeRound() {
        for _ in 1...20 {
            dateArray.append(initialNumber)
            initialNumber -= 7
        }
    }
    
    func numberOfInComponent() -> Int {
        return dateArray.count
    }
}
