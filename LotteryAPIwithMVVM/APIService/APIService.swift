//
//  APIService.swift
//  LotteryAPIwithMVVM
//
//  Created by LOUIE MAC on 2023/09/14.
//

import Foundation


enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}


class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func callRequest(round:Int, completion: @escaping (Result<Lottery, NetworkError>)-> Void) {
        
        guard let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)") else { return }
        let rq = URLRequest(url: url, timeoutInterval: 5)

        print(rq)
        URLSession.shared.dataTask(with: rq) { data, response, error in
            
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(.networkingError))
                    return
                }
                            
                guard let safeData = data else {
                    completion(.failure(.dataError))
                    return
                }
                
                do {
                    
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Lottery.self, from: safeData)
                    completion(.success(result))
                    
                } catch {
                    
                    completion(.failure(.parseError))
                }
            }
        }.resume()
    }
}

