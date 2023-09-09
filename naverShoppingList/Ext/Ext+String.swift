//
//  Ext+String.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit

extension String {
    
    func encodingText() -> String {
        let result = self.components(separatedBy: ["<","b","/",">"]).joined()
        return result
    }
    
    
    // 숫자 3자리 마다 , 찍기
    func numberToThreeCommaString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: Int(self))
        return result ?? ""
    }
    
}
