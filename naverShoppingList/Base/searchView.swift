//
//  BaseCollectionView.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit

class SearchView : BaseView {
    
    let searchBar = {
       let view = UISearchBar()
        view.placeholder = "검색어를 입력해주세요"
        return view
    }()

    override func configureView() {
        self.addSubview(searchBar)
        searchBar.backgroundImage = UIImage()
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}