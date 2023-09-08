//
//  BaseCollectionViewCell.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit

class BaseCollectionViewCell : UICollectionViewCell {
    
    let shoppingImage = {
       let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .green
        return view
    }()
    
    let malNameLabel = {
       let view = UILabel()
        view.text = "월드 캠핑카"
        view.font = .systemFont(ofSize: 12)
        view.textColor = .gray
        view.backgroundColor = .green
        return view
    }()
    
    let productName = {
       let view = UILabel()
        view.text = "임시임시임시임시임시임시임시임시임시임시임시임시임시임시"
        view.font = .systemFont(ofSize: 13)
        view.numberOfLines = 2
        view.backgroundColor = .green
        return view
    }()
    
    let priceLabel = {
       let view = UILabel()
        view.text = "20,000원20,000원20,000원20,000원"
        view.font = .systemFont(ofSize: 14, weight: .bold)
        view.backgroundColor = .green
        return view
    }()
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [shoppingImage, malNameLabel, productName, priceLabel])
        stack.axis = .vertical
        stack.spacing = 1
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.backgroundColor = .yellow
        contentView.addSubview(stackView)
    }
    
    func setConstraints() {
        shoppingImage.backgroundColor = .red
        shoppingImage.snp.makeConstraints { make in
         //   make.width.equalTo(self.frame.width)
          //  make.height.equalTo(self.frame.width).multipliedBy(1.0)
            make.size.equalTo(self.frame.width).multipliedBy(1.0)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        productName.setContentHuggingPriority(.defaultHigh, for: .vertical)
        malNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
