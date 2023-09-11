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
    
    let realmRepository = RealmRepository()
    
    var likedShoppingList: Results<LocalRealmDB>!
    
    var shoppingList = NaverShopping(total: 0, start: 0, display: 0, items: [])
    
    lazy var searchCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: settingCollectionViewFlowLayout())
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
        view.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
       // view.backgroundColor = .clear
        view.backgroundColor = .black
        return view
    }()
    
    let searchView =  SearchView()
    let categortView = CategoryView()
    
    var BtnArray = [UIButton]()
    var userInputText: String?
    var start = 1
    var sort: ProductSort = .sim
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        setNavigation(inputTitle: "쇼핑 검색")
        print(realmRepository.realm.configuration.fileURL!)
        
       
    }
 
    func configureView() {
        view.addSubview(searchCollectionView)
        view.addSubview(searchView)
        view.addSubview(categortView)
        searchView.searchBar.delegate = self

        [categortView.button1, categortView.button2, categortView.button3, categortView.button4].forEach {
            BtnArray.append($0)
            $0.addTarget(self, action: #selector(sortBtnClicked(_:)), for: .touchUpInside)
        }
    }
    
    @objc func sortBtnClicked(_ sender: UIButton) {
        print("버튼이 눌렸다 \(sender.tag)")

        self.shoppingList.items.removeAll()
        let selectedSort: ProductSort = ProductSort.allCases[sender.tag]

        for Btn in BtnArray {
                 if Btn == sender {
                     // 만약 현재 버튼이 이 함수를 호출한 버튼이라면
                     sort = selectedSort
                     Btn.isSelected = true
                     Btn.setTitleColor(.black, for: .normal)
                     Btn.backgroundColor = UIColor.white
                 } else {
                     // 이 함수를 호출한 버튼이 아니라면
                     Btn.isSelected = false
                     Btn.setTitleColor(.white, for: .normal)
                     Btn.backgroundColor = .clear
                 }
             }
       
        callRequest(searText: userInputText, start: start, sort: sort)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likedShoppingList = realmRepository.fetch()
        print("Realm에 저장된 데이터들 Search : \(likedShoppingList)")
        self.searchCollectionView.reloadData()
    }
    
    func callRequest(searText: String?, start: Int, sort: ProductSort) {
        NetwokeManager.shared.callRequest(searText: searText, start: start, sort: sort) { response in
           // print("viewdidload",response!)
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
                callRequest(searText: userInputText, start: start, sort: sort)
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
        
        cell.likeButton.tag = indexPath.item
        for i in likedShoppingList {
            if shoppingList.items[indexPath.item].productID.contains(String(i.id)) {
                print("같은 ID 입니다. \(shoppingList.items[indexPath.item].productID)")
                
                    shoppingList.items[indexPath.item].isLike = true
                    cell.likeButton.isSelected = true
                  //  print("\(shoppingList.items)")
                
            }
        }
        // List에서 넘어온 ID를 CellforRowAt에서 비교해서 해당 isSelected = false로 설정

       
        let data = shoppingList.items[indexPath.item]
        
        cell.settupCell(item: data)
        cell.likeButton.addTarget(self, action: #selector(likeBtnClicked), for: .touchUpInside)
        return cell
    }
    
    // MARK: - Like 버튼 액션
    @objc func likeBtnClicked(_ sender: UIButton) {

        print("좋아요 버튼 눌림 \(sender.tag)")
        sender.isSelected.toggle()
        
        var tagToShoppingList = shoppingList.items[sender.tag]
        
        
        print("버튼 선택에 따른 상태 : \(sender.isSelected)")

        if tagToShoppingList.isLike == sender.isSelected {
            print("네트워크에서 설정한 isLike와 버튼 isSelcted가 같을때 ")
            tagToShoppingList.isLike = false
            print("likedShoppingList.count",likedShoppingList.count)
            
        } else {
            print("네트워크에서 설정한 isLike와 버튼 isSelcted가 다를때 ")
            print("SearchVC Bool 값일때- \(tagToShoppingList.isLike) != \(sender.isSelected)")
            tagToShoppingList.isLike = true
            realmRepository.creatItem(item: tagToShoppingList)
        }



        sender.isSelected ? sender.setImage(UIImage(systemName: "heart.fill"), for: .normal) : sender.setImage(UIImage(systemName: "heart"), for: .normal)

    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        print("search 취소버튼 눌림")
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("리턴 버튼 눌림")
        
            userInputText = searchBar.text
            self.shoppingList.items.removeAll()
            start = 1
            callRequest(searText: userInputText, start: start, sort: sort)
        
        searchBar.resignFirstResponder()
    }
    
}
