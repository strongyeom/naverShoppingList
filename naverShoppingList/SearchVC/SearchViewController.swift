//
//  ViewController.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/07.
//

import UIKit
import SnapKit
import RealmSwift

class SearchViewController: BaseViewController {
    
    let realmRepository = RealmRepository()
    
    var likedShoppingList: Results<LocalRealmDB>! {
        didSet {
            print("shoppingList가 변화되었다.")
            self.searchCollectionView.reloadData()
        }
    }
        
    var shoppingList = NaverShopping(total: 0, start: 1, display: 0, items: [])
    

    
    private lazy var searchCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: settingCollectionViewFlowLayout())
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
        view.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
       // view.backgroundColor = .clear
        view.backgroundColor = .black
        return view
    }()
    
    lazy var searchView = {
       let search =  SearchView()
        search.searchBar.delegate = self
        return search
    }()
    
    let categortView = CategoryView()
    
    var BtnArray = [UIButton]()
    var userInputText: String?
    var start = 1
    var sort: ProductSort = .sim
    
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realmRepository.realm.configuration.fileURL!)
        print(#function)
    }
 
    override func configureView() {
        print(#function)
        setConfigure()
        setCategoriesButton()
        setNavigation(inputTitle: "쇼핑 검색")
    }
    
    func setConfigure() {
        view.addSubview(searchCollectionView)
        view.addSubview(searchView)
        view.addSubview(categortView)
    }
    
    func setCategoriesButton() {
        [categortView.button1, categortView.button2, categortView.button3, categortView.button4].forEach {
            BtnArray.append($0)
            $0.addTarget(self, action: #selector(sortBtnClicked(_:)), for: .touchUpInside)
        }
    }
    
    
    @objc func sortBtnClicked(_ sender: UIButton) {
        
        if BtnArray[sender.tag].isSelected == true {
            return
        }
        if shoppingList.items.count > 1 {
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
                         callRequest(searText: userInputText, start: start, sort: sort)
                     } else {
                         // 이 함수를 호출한 버튼이 아니라면
                         Btn.isSelected = false
                         Btn.setTitleColor(.white, for: .normal)
                         Btn.backgroundColor = .clear
                     }
                 }
            print("조건문 이후 ",BtnArray[sender.tag].isSelected)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        likedShoppingList = realmRepository.fetch()
        print("Realm에 저장된 데이터들 Search : \(likedShoppingList)")
       // self.searchCollectionView.reloadData()
    }
    
    fileprivate func callRequest(searText: String?, start: Int, sort: ProductSort) {
        print(#function)
        guard let searText else { return }
        NetwokeManager.shared.callRequest(api: NetworkAPI.naverShopping(query: searText, start: start, sort: sort)) { response in
            
            switch response {
            case .success(let success):
                self.shoppingList.items.append(contentsOf: success.items)
                print(self.shoppingList.items.count)
                self.searchCollectionView.reloadData()
            case .failure(let failure):
                print(failure.naverErrorDescription)
                let alert = UIAlertController(title: "오류가 발생하였습니다.", message: failure.naverErrorDescription, preferredStyle: .alert)
                let ok = UIAlertAction(title: "확인", style: .default)
                alert.addAction(ok)
                self.present(alert, animated: true)
            }
        }
    }
    
    override func setConstraints() {
        
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
        print("selectedCell : \(selectedCell)")
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        
        let data = shoppingList.items[indexPath.item]
        
        cell.settupCell(item: data)
      
        return cell
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
        
        userInputText = searchBar.text?.lowercased()
            self.shoppingList.items.removeAll()
            start = 1
            callRequest(searText: userInputText, start: start, sort: sort)
        
        searchBar.resignFirstResponder()
    }
    
}
