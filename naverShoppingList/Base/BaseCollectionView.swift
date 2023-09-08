//
//  BaseCollectionView.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit
import SnapKit

class BaseCollectionView : UIView {
    
    lazy var baseCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: settingCollectionViewFlowLayout())
        collectionView.backgroundColor = .yellow
        return collectionView
    }()
    
    func settingCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: width / 2, height: width / 1.5)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
        
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        configureView()
//        setConstraints()
//    }
//
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView() {
        self.addSubview(baseCollectionView)
    }
    
    func setConstraints() {
        baseCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
