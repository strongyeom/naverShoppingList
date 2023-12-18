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
        view.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        
        view.searchTextField.autocapitalizationType = .none
        view.searchTextField.textColor = .black
        // Search 텍스트 필드 배경색 설정
        view.searchTextField.backgroundColor = UIColor(red: 243 / 256 , green: 243 / 256, blue: 243 / 256, alpha: 1.0)
        
        view.setShowsCancelButton(true, animated: true)
        let cancelButtonAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
         UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes , for: .normal)

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
