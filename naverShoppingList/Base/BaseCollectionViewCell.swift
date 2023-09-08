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
    
    let likeButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.backgroundColor = .white
        view.tintColor = .black
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
        shoppingImage.addSubview(likeButton)
        sethugging()
    }
    
    func setConstraints() {
        shoppingImage.backgroundColor = .red
        shoppingImage.snp.makeConstraints { make in
            make.size.equalTo(self.frame.width).multipliedBy(1.0)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints { make in
            make.size.equalTo(35)
            make.trailing.bottom.equalTo(shoppingImage).inset(10)
        }
        
        DispatchQueue.main.async {
            self.likeButton.layer.cornerRadius = self.likeButton.frame.width / 2
            self.likeButton.clipsToBounds = true
            
        }
    }
        
        func sethugging() {
            productName.setContentHuggingPriority(.defaultHigh, for: .vertical)
            malNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
            priceLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        }
}
