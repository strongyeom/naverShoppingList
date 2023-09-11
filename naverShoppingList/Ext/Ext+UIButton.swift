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
        self.setTitleColor(.white, for: .normal)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
       // self.titleEdgeInsets = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        self.titleLabel?.font = .systemFont(ofSize: 13)
    }
    
    func settingSelectedBtn() {
            self.layer.cornerRadius = 12
            self.clipsToBounds = true
            self.setTitleColor(.black, for: .normal)
            self.backgroundColor = .white
            self.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            self.titleLabel?.font = .systemFont(ofSize: 13)
    }
}
