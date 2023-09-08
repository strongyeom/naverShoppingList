//
//  DetailViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var detailProduct: Item?
    
    var webView: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
    }
    
    func configureView() {
        view.addSubview(webView)
        
        guard let detailProduct else { return }
        let myURL = URL(string:"https://msearch.shopping.naver.com/product/\(detailProduct.productID)")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
 
        navigationItem.title = encodingText(text: detailProduct.title)
         

    }
    
    func setConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension DetailViewController: WKUIDelegate, UINavigationControllerDelegate {
    
}
