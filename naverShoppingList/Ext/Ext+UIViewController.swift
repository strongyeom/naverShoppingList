//
//  Ext+UIViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/09.
//

import UIKit


extension UIViewController {
    
//    func settingCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .vertical
//        let spacing: CGFloat = 10
//        let width = UIScreen.main.bounds.width - (spacing * 3)
//        layout.itemSize = CGSize(width: width / 2, height: width / 1.4)
//        layout.minimumLineSpacing = spacing
//        layout.minimumInteritemSpacing = spacing
//        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
//        return layout
//
//    }

    // 네비게이션 영역 색상 설정
    func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
        
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
        title = "쇼핑 검색"
    }
}

