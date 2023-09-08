//
//  Ext+UIButton.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit

extension UIButton {
    func setBtnConfigure() {
        self.layer.cornerRadius = 12
        self.clipsToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        self.titleLabel?.font = .systemFont(ofSize: 13)
    }
}
