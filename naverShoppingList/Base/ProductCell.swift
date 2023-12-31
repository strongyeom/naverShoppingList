//
//  BaseCollectionViewCell.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit
import RealmSwift
import Kingfisher

class ProductCell : BaseCollectionViewCell {
    
    let realmRepository = RealmRepository()
    
    let viewModel = NaverViewModel()
    
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
        view.font = .systemFont(ofSize: 13)
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
        view.isHidden = true
        
        view.backgroundColor = .white
        return view
    }()
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [shoppingImage, malNameLabel, productName, priceLabel])
        stack.axis = .vertical
        stack.spacing = 3
        stack.alignment = .leading
        stack.distribution = .fill
        return stack
    }()
    
    var completionHandler: (() -> Void)?



    override func configureView() {
        
        contentView.addSubview(stackView)
        shoppingImage.addSubview(likeButton)
        sethugging()
        likeButton.addTarget(self, action: #selector(likeButtonClicked(_:)), for: .touchUpInside)
    }
    override func setConstraints() {
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
            self.likeButton.isHidden = false
            self.likeButton.layer.cornerRadius = self.likeButton.frame.width / 2
            self.likeButton.clipsToBounds = true
        }
    }
    
    @objc func likeButtonClicked(_ sender: UIButton) {
        print("좋아요 버튼 눌림")
        completionHandler?()
    }

    
    // Search VC에서 부를때
    func settupCell(item: Item) {
//
//        let url = URL(string: item.image)!
//        self.shoppingImage.kf.setImage(with: url)
        imageDownSizingToKingFisher(item: item)
        self.malNameLabel.text =  "[\(item.mallName)]"
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
                realmRepository.deleData(item: viewModel.realmData.value, shoppingIndex: item)
                self.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
            } else {
                // 포함되어 있지 않다면
               // realmRepository.creatItem(item: item)
                viewModel.addRealm(item: item)
                self.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
        }
    }
    
    func imageDownSizingToKingFisher(item: Item) {
        let url = URL(string: item.image)!
        // 첫 로드시 안됐던 이유는 size에 shoppingImage.bounds.size 들어가 있어서 크기가 정해져 있지 않았기 때문에 이미지가 보여지지 않음
        // size == 해상도라고 생각하면됨 ex) 디스크에 720p -> 메모리 240p로 다운 사이징해서 보여줌
        let processor = DownsamplingImageProcessor(size: .init(width: 150, height: 150))
            self.shoppingImage.kf.setImage(
                with: url,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ]
            )
    }

    // Like VC에서 부를 때
    func likedSettupCell(item: LocalRealmDB) {
        print("LocalRealmDB - \(item)")
        let url = URL(string: item.imageurl)!
        self.shoppingImage.kf.setImage(with: url)
        self.malNameLabel.text = "[\(item.malName)]"
        self.productName.text = item.title.encodingText()
        self.priceLabel.text =  "\(item.price)원"
        
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

extension ProductCell {
    func sethugging() {
        productName.setContentHuggingPriority(.defaultHigh, for: .vertical)
        malNameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
}


