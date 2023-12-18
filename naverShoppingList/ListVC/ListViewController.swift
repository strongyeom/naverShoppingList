//
//  ListViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/07.
//

import UIKit
import RealmSwift
import SnapKit


class ListViewController: BaseViewController {
    
    let realmRepository = RealmRepository()
    
    var likedShoppingList: Results<LocalRealmDB>!
    
    private lazy var listCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: settingCollectionViewFlowLayout())
        view.delegate = self
        view.dataSource = self
        view.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        view.backgroundColor = .black
        return view
    }()
    let viewModel = NaverViewModel()
    private let searchView =  SearchView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ListViewController - viewWillAppear")
        print("Realm에 저장된 데이터들 List: \(likedShoppingList)")
        self.listCollectionView.reloadData()
    }
    
   override func configureView() {
       setConfigure()
       
       viewModel.fetch()
       viewModel.realmData.bind { realmData in
           self.likedShoppingList = realmData
       }
       setNavigation(inputTitle: "좋아요 목록")
        searchView.searchBar.delegate = self
    }
    
    fileprivate func setConfigure() {
        view.addSubview(listCollectionView)
        view.addSubview(searchView)
    }
    
    override func setConstraints() {
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
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
        
        if let text = searchBar.text?.lowercased() {
            likedShoppingList = realmRepository.fetchFilter(text: text)
        }
        self.listCollectionView.reloadData()
        
    }
    
    
}
