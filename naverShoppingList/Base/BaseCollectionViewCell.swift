//
//  BaseCollectionViewCell2.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/21.
//

import UIKit

class BaseCollectionViewCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureView() {
        
    }
    
    func setConstraints() {
        
    }
}
