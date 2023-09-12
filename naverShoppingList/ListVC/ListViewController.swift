//
//  ListViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/07.
//

import UIKit
import RealmSwift
import SnapKit


class ListViewController: UIViewController {
    
    let realmRepository = RealmRepository()
    
    var likedShoppingList: Results<LocalRealmDB>!
    
    lazy var listCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: settingCollectionViewFlowLayout())
        view.delegate = self
        view.dataSource = self
        view.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
        view.backgroundColor = .black
        return view
    }()
    
    let searchView =  SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        likedShoppingList = realmRepository.fetch()
        configureView()
        setConstraints()
        setNavigation(inputTitle: "좋아요 목록")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ListViewController - viewWillAppear")
        print("Realm에 저장된 데이터들 List: \(likedShoppingList)")
        self.listCollectionView.reloadData()
    }
    
    func configureView() {
        view.addSubview(listCollectionView)
        view.addSubview(searchView)
        searchView.searchBar.delegate = self
    }
    
    func setConstraints() {
        searchView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        listCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailViewController()
        let selectedItem = likedShoppingList[indexPath.item]
        let task = Item(title: selectedItem.title, image: selectedItem.imageurl, lprice: selectedItem.price, mallName: selectedItem.malName, productID: selectedItem.id)
        vc.detailProduct = task
        print("ListVC - Cell 눌림 ")
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedShoppingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BaseCollectionViewCell.identifier, for: indexPath) as? BaseCollectionViewCell else { return UICollectionViewCell() }
        let item = likedShoppingList[indexPath.item]
        
        
        cell.likedSettupCell(item: item)
        
        cell.completionHandler = { [weak self] in
            guard let self else { return }
            self.realmRepository.deleData(item: realmRepository.fetch(), realmIndex: item)
            self.listCollectionView.reloadData()
        }
        return cell
    }
}

extension ListViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        likedShoppingList = realmRepository.fetch()
        self.listCollectionView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("$56")
        
        if let text = searchBar.text {
            likedShoppingList = realmRepository.fetchFilter(text: text)
        }
        self.listCollectionView.reloadData()
        
    }
    
    
}
