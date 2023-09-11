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
        
        let search = SearchViewController()
        search.tabBarItem.title = "검색"
        search.tabBarItem.image = UIImage(systemName: "magnifyingglass")
       
        
        let list = ListViewController()
        list.tabBarItem.title = "좋아요"
        list.tabBarItem.image = UIImage(systemName: "heart")
       
        
        

               
        
        let searchHome = UINavigationController(rootViewController: search)
        let listHome = UINavigationController(rootViewController: list)
        
        self.tabBar.isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().tintColor = UIColor.white
       

        
        setViewControllers([searchHome, listHome], animated: false)
        
        
    }
}
