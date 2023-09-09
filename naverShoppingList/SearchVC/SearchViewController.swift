//
//  ViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/07.
//

import UIKit
import SnapKit
import Kingfisher
import RealmSwift

class SearchViewController: UIViewController {
    
    let realm = try! Realm()
    
    var shoppingList = NaverShopping(total: 0, start: 0, display: 0, items: [])
    
    lazy var searchCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: settingCollectionViewFlowLayout())
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
        view.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
        return view
    }()
    
    let searchView =  SearchView()
    let categortView = CategoryView()
    
    
    var start = 1
    var sort: ProductSort = .sim
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        settup()
        setNavigation()
        
        print(realm.configuration.fileURL!)
        
    }
    
    func settup() {
        searchView.searchBar.delegate = self
    }
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(searchCollectionView)
        view.addSubview(searchView)
        view.addSubview(categortView)
        //  callRequest(searText: "캠핑카", start: start, sort: .sim)
        
    }
    
    func callRequest(searText: String, start: Int, sort: ProductSort) {
        NetwokeManager.shared.callRequest(searText: searText, start: start, sort: sort) { response in
            print("viewdidload",response!)
            guard let response else { return }
            self.shoppingList.items.append(contentsOf: response.items)
            self.searchCollectionView.reloadData()
        }
    }
    
    func setConstraints() {
        
        searchView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        categortView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(10)
            make.top.equalTo(searchView.snp.bottom).offset(5)
        }
        
        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(categortView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

// MARK: - UICollectionViewDataSourcePrefetching
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        // 응답 메세지로 page에 대한 값이 정해져 있다면 조건을 추가해준다.
        // 또한 마지막 페이지가 나오면 더이상 page를 증가시키지 않는다.
        for indexPath in indexPaths {
            
            if shoppingList.items.count - 1 == indexPath.item {
                start += 1
                callRequest(searText: "캠핑카", start: start, sort: .sim)
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===== cancelPrefetchingForItemsAt")
    }
}


// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let selectedCell = shoppingList.items[indexPath.item]
                let vc = DetailViewController()
                vc.detailProduct = selectedCell
                navigationController?.pushViewController(vc, animated: true)
        
        
        
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shoppingList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.identifier, for: indexPath) as? BaseCollectionViewCell else { return UICollectionViewCell() }
        
        let data = shoppingList.items[indexPath.item]
        cell.settupCell(item: data)
        cell.likeButton.tag = indexPath.item
        print("버튼 Tag: \(cell.likeButton.tag)")
        cell.likeButton.addTarget(self, action: #selector(likeBtnClicked), for: .touchUpInside)
        return cell
    }
    
    
    // MARK: - Like 버튼 액션
    @objc func likeBtnClicked(_ sender: UIButton) {
        print("좋아요 버튼 눌림 \(sender.tag)")
        sender.isSelected.toggle()
        print("버튼 선택에 따른 상태 : \(sender.isSelected)")
        
        // 해당 버튼을 눌렀을때 해당 Cell의 정보를 어떻게 가져오지?
        let tagToShoppingList = shoppingList.items[sender.tag]
        
        let task = LocalRealmDB(
            id: Int(tagToShoppingList.productID)!, imageurl: tagToShoppingList.image,
            malName: tagToShoppingList.mallName,
            title: tagToShoppingList.title.encodingText(), price: tagToShoppingList.lprice.numberToThreeCommaString(), isLike: sender.isSelected)
        
        // realm에 저장
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print(error)
        }
        
        
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        print("search 취소버튼 눌림")
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("리턴 버튼 눌림")
        if let text = searchBar.text {
            self.shoppingList.items.removeAll()
            start = 1
            callRequest(searText: text, start: start, sort: .sim)
        }
        view.endEditing(true)
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
}

