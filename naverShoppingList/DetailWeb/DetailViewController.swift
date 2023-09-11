//
//  DetailViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit
import WebKit
import RealmSwift

class DetailViewController: UIViewController {
    
    var realmRepository = RealmRepository()
    
    var detailProduct: Item?
    
    var likeButtonImage: UIImage?
    var webView: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }
    
    func configureView() {
        view.addSubview(webView)
        
     
        
        guard let detailProduct else { return }
        
        
         if realmRepository.fetch().contains(where: { $0.id == detailProduct.productID}) {
             likeButtonImage =  UIImage(systemName: "heart.fill")
         } else {
             likeButtonImage = UIImage(systemName: "heart")
         }
        
        let myURL = URL(string:"https://msearch.shopping.naver.com/product/\(detailProduct.productID)")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        navigationItem.title = detailProduct.title.encodingText()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: likeButtonImage, style: .plain, target: self, action: #selector(likeBtnClicked(_:)))
        
    }
    
    @objc func likeBtnClicked(_ sender: UIBarButtonItem) {
        print("좋아요 버튼 ")
        guard let detailProduct else { return }
        // 좋아요 눌렸으면 하트 색상 바꿔져 있어야함
        
        if realmRepository.fetch().contains(where: { $0.id == detailProduct.productID }) {
            realmRepository.deleData(item: realmRepository.fetch(), shoppingIndex: detailProduct)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        } else {
            realmRepository.creatItem(item: detailProduct)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
        }
        
        
    }
    
    func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension DetailViewController: WKUIDelegate, UINavigationControllerDelegate {
    
}


