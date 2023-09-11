//
//  BaseCollectionViewCell.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit
import RealmSwift

class BaseCollectionViewCell : UICollectionViewCell {
    
    let realmRepository = RealmRepository()
    
    let shoppingImage = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        // 이미지 뷰에서 버튼 클릭이 가능하게 하려면 isUserInteractionEnabled 해야함 왜냐하면 기본값으로 false로 되어 있음
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let malNameLabel = {
        let view = UILabel()
        view.text = "월드 캠핑카"
        view.font = .systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    let productName = {
        let view = UILabel()
        view.text = "임시임시임시임시임시임시임시임시임시임시임시임시임시임시"
        view.font = .systemFont(ofSize: 13)
        view.numberOfLines = 2
        return view
    }()
    
    let priceLabel = {
        let view = UILabel()
        view.text = "20,000원20,000원20,000원20,000원"
        view.font = .systemFont(ofSize: 14, weight: .bold)
        return view
    }()

    let likeButton = {
        let view = UIButton()
        view.setImage(UIImage(systemName: "heart"), for: .normal)
        view.tintColor = .black
        view.backgroundColor = .white
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
        contentView.addSubview(stackView)
        shoppingImage.addSubview(likeButton)
        sethugging()
    }
    func setConstraints() {
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
    
    // Search VC에서 부를때
    func settupCell(item: Item) {
        let url = URL(string: item.image)!
        self.shoppingImage.kf.setImage(with: url)
        self.malNameLabel.text = item.mallName
        self.productName.text = item.title.encodingText()
        self.priceLabel.text =  "\(item.lprice.numberToThreeCommaString())원"
        print("item.isLike : \(item.isLike)")
        item.isLike ? likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }

    // Like VC에서 부를 때
    func likedSettupCell(item: LocalRealmDB) {
        let url = URL(string: item.imageurl)!
        self.shoppingImage.kf.setImage(with: url)
        self.malNameLabel.text = item.malName
        self.productName.text = item.title.encodingText()
        self.priceLabel.text =  "\(item.price.numberToThreeCommaString())원"
        item.isLike ? likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal) : likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    
    
        
    // 이렇게 생각해보자 버튼 클릭은 단순히 저장하고 삭제 기능만 하는데,
    // true일때는 하트의 색상을 채워주고 저장, false일때는 빈 하트로 하고 realm delete하는 건 어때?

    
    override func prepareForReuse() {
        super.prepareForReuse()
        shoppingImage.image = nil
    }
}

extension BaseCollectionViewCell {
    func sethugging() {
        productName.setContentHuggingPriority(.defaultHigh, for: .vertical)
        malNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}
