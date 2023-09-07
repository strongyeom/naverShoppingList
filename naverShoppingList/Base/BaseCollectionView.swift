//
//  BaseCollectionView.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit
import SnapKit

class BaseCollectionView : UICollectionViewController {
    
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
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }
    
    func configureView() {
        view.addSubview(baseCollectionView)
    }
    
    func setConstraints() {
        baseCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
