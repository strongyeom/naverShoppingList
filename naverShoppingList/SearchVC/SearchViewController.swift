//
//  ViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/07.
//

import UIKit
import SnapKit
import Kingfisher

class SearchViewController: UIViewController {
    
    var shoppingList = NaverShopping(total: 0, start: 0, display: 0, items: [])
    
    lazy var searchCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: settingCollectionViewFlowLayout())
        view.delegate = self
        view.dataSource = self
        view.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
        return view
    }()
    
    let searView =  SearchView()
    let categortView = CategoryView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        settup()
    }
    
    func settup() {
        searView.searchBar.delegate = self
    }
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(searchCollectionView)
        view.addSubview(searView)
        view.addSubview(categortView)
        
        NetwokeManager.shared.callRequest(searText: "캠핑카", display: 30, start: 1, sort: .sim) { response in
            print("viewdidload",response!)
            guard let response else { return }
            self.shoppingList.items.append(contentsOf: response.items)
            self.searchCollectionView.reloadData()
        }
    }

    func setConstraints() {
        
        searView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        categortView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(searView.snp.bottom).offset(5)
        }
        
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categortView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }

}

extension SearchViewController: UICollectionViewDelegate {
    
}

extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.identifier, for: indexPath) as? BaseCollectionViewCell else { return UICollectionViewCell() }
        let data = shoppingList.items[indexPath.item]
        
        let url = URL(string: data.image)!
        cell.shoppingImage.kf.setImage(with: url)
        
        let decodingText = data.title.components(separatedBy: ["<","b","/",">"]).joined()
        cell.malNameLabel.text = data.mallName
        cell.productName.text = decodingText
        cell.priceLabel.text =  "\(example(price: data.lprice))원"
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("search 취소버튼 눌림")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("리턴 버튼 눌림")
    }
}


extension SearchViewController {
    
    func settingCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let spacing: CGFloat = 10
        let width = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: width / 2, height: width / 1.4)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
        
    }
    
    // 숫자 3자리 마다 , 찍기
    func example(price: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: Int(price))
        return result ?? ""
    }
}
