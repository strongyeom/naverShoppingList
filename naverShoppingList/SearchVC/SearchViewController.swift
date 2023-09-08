//
//  ViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/07.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    lazy var searchCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: settingCollectionViewFlowLayout())
        view.delegate = self
        view.dataSource = self
        view.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
        return view
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
        view.backgroundColor = .white
        view.addSubview(searchCollectionView)
        
        NetwokeManager.shared.callRequest(searText: "캠핑카", display: 30, start: 1, sort: .sim) { response in
            print("viewdidload",response!)
        }
    }

    func setConstraints() {
        searchCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension SearchViewController: UICollectionViewDelegate {
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.identifier, for: indexPath) as? BaseCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}
