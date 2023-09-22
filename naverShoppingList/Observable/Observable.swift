//
//  Observable.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/22.
//

import Foundation

class Observable<T> {
    
    var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping((T) -> Void)) {
        closure(value)
        listener = closure
    }
}
