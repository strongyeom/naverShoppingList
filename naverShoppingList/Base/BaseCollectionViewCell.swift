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
    
    var completionHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureView()
        setConstraints()
        likeButton.addTarget(self, action: #selector(likeButtonClicked(_:)), for: .touchUpInside)
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        print("좋아요 버튼 눌림")
        completionHandler?()
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
        
        // Cell이 로드될때 realm의 ID에 있는 데이터와 데이터 통신으로 받아온 ID를 비교해서 같으면 하트 변경
        if realmRepository.fetch().contains(where: { $0.id == item.productID}) {
            // ID가 같으면
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            // ID가 같지 않으면
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        // 버튼 액션 후 realm에 있는 ID와 선택한 Cell의 ID를 비교해서 realm에서 삭제, 추가 해줌 / 하트 변경
        self.completionHandler = { [weak self] in
            guard let self else { return }
            if realmRepository.fetch().contains(where: {
                String($0.id) == item.productID
            }) {
                // 포함되어 있으면
                realmRepository.deleData(item: realmRepository.fetch(), shoppingIndex: item)
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                // 포함되어 있지 않다면
                realmRepository.creatItem(item: item)
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
        

        
    }

    // Like VC에서 부를 때
    func likedSettupCell(item: LocalRealmDB) {
        let url = URL(string: item.imageurl)!
        self.shoppingImage.kf.setImage(with: url)
        self.malNameLabel.text = item.malName
        self.productName.text = item.title.encodingText()
        self.priceLabel.text =  "\(item.price.numberToThreeCommaString())원"
        
        if realmRepository.fetch().contains(where: { $0.id == item.id}) {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }

    }

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
