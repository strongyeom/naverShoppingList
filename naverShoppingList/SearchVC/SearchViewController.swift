//
//  ViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/07.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        NetwokeManager.shared.callRequest(searText: "캠핑카", display: 30, start: 1, sort: .sim) { response in
            print("viewdidload",response!)
        }

    }


}

