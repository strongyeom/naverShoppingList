//
//  ReuseIentifier.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit

protocol ReuseIdentifier {
    static var identifier: String { get }
}

extension UIViewController : ReuseIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UICollectionViewCell : ReuseIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
