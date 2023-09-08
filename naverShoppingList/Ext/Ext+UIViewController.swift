//
//  Ext+String.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit

extension UIViewController {
    
    func encodingText(text: String) -> String {
        let result = text.components(separatedBy: ["<","b","/",">"]).joined()
        return result
    }
    
}
