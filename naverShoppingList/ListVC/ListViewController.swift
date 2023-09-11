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
        let selectedCell = likedShoppingList[indexPath.item]
        let vc = DetailViewController()
        
        let task = Item(title: selectedCell.title, image: selectedCell.imageurl, lprice: selectedCell.price, mallName: selectedCell.malName, productID: String(selectedCell.id))
        vc.detailProduct = task
        
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
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(cancelLikeBtnClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func cancelLikeBtnClicked(_ sender: UIButton) {
        print("검색VC에서 좋아요 취소 \(sender.tag)")
        sender.setImage(UIImage(systemName: "heart"), for: .normal)

        let selectedCell = likedShoppingList[sender.tag]

        realmRepository.deleData(item: selectedCell)
        print("취소 버튼 눌림 , Realm에 저장된 데이터들 List: \(likedShoppingList)")
        self.listCollectionView.reloadData()
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
