//
//  TabBarController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/07.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let search = SearchViewCo/Users/yeomseongpil/Desktop/새싹/2차 Recap/naverShoppingList/naverShoppingListntroller()
        search.tabBarItem.title = "검색"
        search.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        search.navigationItem.title = "쇼핑 검색"
        
        let list = ListViewController()
        list.tabBarItem.title = "좋아요"
        list.tabBarItem.image = UIImage(systemName: "heart")
        list.navigationItem.title = "좋아요 목록"
        
        
        let searchHome = UINavigationController(rootViewController: search)
        let listHome = UINavigationController(rootViewController: list)
        
        
        self.tabBar.tintColor = UIColor.black // tab bar icon tint color
        self.tabBar.isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().tintColor = UIColor.white
        
        
        setViewControllers([searchHome, listHome], animated: false)
        
        
    }
}
