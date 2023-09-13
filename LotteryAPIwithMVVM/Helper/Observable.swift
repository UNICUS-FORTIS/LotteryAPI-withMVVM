//
//  Observable.swift
//  LotteryAPIwithMVVM
//
//  Created by LOUIE MAC on 2023/09/14.
//

import Foundation

class Observable<T> {
    
    private var listner: ( (T) -> Void )?
    
    
    var value: T {
        didSet {
            listner?(value)
        }
    }
    
    
    init(_ value: T) {
        self.value = value
    }
    
    
    func bind(_ completion: @escaping (T) -> Void) {
        completion(value)
        listner = completion
    }

}
