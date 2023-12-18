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
    
    var likedShoppingList: Results<LocalRealmDB>!
    let viewModel = NaverViewModel()
    
    
    private lazy var searchCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: settingCollectionViewFlowLayout())
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
        view.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        view.backgroundColor = .black
        return view
    }()
    
    lazy var searchView = {
        let search = SearchView()
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
        viewModel.naverShopping.bind { _ in
            DispatchQueue.main.async {
                self.searchCollectionView.reloadData()
            }
        }
        viewModel.fetch()
       
        viewModel.realmData.bind { realmData in
            print("****",realmData)
        }
        
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
        if viewModel.naverShopping.value.items.count > 1 {
            print("버튼이 눌렸다 \(sender.tag)")
            
            self.viewModel.naverShopping.value.items.removeAll()
            let selectedSort: ProductSort = ProductSort.allCases[sender.tag]
            
            for Btn in BtnArray {
                if Btn == sender {
                    // 만약 현재 버튼이 이 함수를 호출한 버튼이라면
                    sort = selectedSort
                    Btn.isSelected = true
                    Btn.setTitleColor(.black, for: .normal)
                    Btn.backgroundColor = UIColor.white
                    viewModel.request(query: userInputText, start: start, sort: sort)
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
            
            if viewModel.naverShopping.value.items.count - 1 == indexPath.item {
                start += 1
                viewModel.request(query: userInputText, start: start, sort: sort)
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
        let selectedCell = viewModel.naverShopping.value.items[indexPath.item]
        print("selectedCell : \(selectedCell)")
        let vc = DetailViewController()
        vc.detailProduct = selectedCell
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.naverShopping.value.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        let item = viewModel.naverShopping.value.items[indexPath.item]
        cell.settupCell(item: item)
        
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
        self.viewModel.naverShopping.value.items.removeAll()
        start = 1
        viewModel.request(query: userInputText, start: start, sort: sort)
        
        searchBar.resignFirstResponder()
    }
    
}
