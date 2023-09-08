//
//  CategoryView.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import UIKit

class CategoryView : BaseView {
    
    let button1 = {
       let view = UIButton()
        view.setTitle("정확도", for: .normal)
        view.setBtnConfigure()
        view.backgroundColor = .green
        return view
    }()
    
    let button2 = {
       let view = UIButton()
        view.setTitle("날짜순", for: .normal)
        view.backgroundColor = .green
        view.setBtnConfigure()
        return view
    }()
    
    let button3 = {
       let view = UIButton()
        view.setTitle("가격높은순", for: .normal)
        view.backgroundColor = .green
        view.setBtnConfigure()
        return view
    }()
    
    let button4 = {
       let view = UIButton()
        view.setTitle("가격낮은순", for: .normal)
        view.backgroundColor = .green
        view.setBtnConfigure()
        return view
    }()
    
    lazy var stackView = {
        let stack = UIStackView(arrangedSubviews: [button1, button2, button3, button4])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.alignment = .fill
        stack.distribution = .fillEqually
        return stack
    }()

    override func configureView() {
        self.addSubview(stackView)
        self.backgroundColor = .red
    }
    
    override func setConstraints() {
        stackView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(5)
            make.height.equalTo(40)
            make.width.equalTo(UIScreen.main.bounds.width * 0.75)
        }
    }
    
}
