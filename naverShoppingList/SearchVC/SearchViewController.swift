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
        view.prefetchDataSource = self
        view.register(BaseCollectionViewCell.self, forCellWithReuseIdentifier: BaseCollectionViewCell.identifier)
        return view
    }()
    
    let searView =  SearchView()
    let categortView = CategoryView()
    
    
    var start = 1
    var sort: ProductSort = .sim
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setConstraints()
        settup()
        setNavigation()

        
       
    }
    
    func settup() {
        searView.searchBar.delegate = self
    }
    
    func configureView() {
        view.backgroundColor = .white
        view.addSubview(searchCollectionView)
        view.addSubview(searView)
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

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let selectedCell = shoppingList.items[indexPath.item]
//        let vc = DetailViewController()
//        vc.detailProduct = selectedCell
//        navigationController?.pushViewController(vc, animated: true)
//
        
        
    }
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
        
       
        cell.malNameLabel.text = data.mallName
        cell.productName.text = encodingText(text: data.title)
        cell.priceLabel.text =  "\(example(price: data.lprice))원"
        cell.likeButton.tag = indexPath.item
        print("\(cell.likeButton.tag)")
        cell.likeButton.addTarget(self, action: #selector(likeBtnClicked(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func likeBtnClicked(_ sender: UIButton) {
        print("좋아요 버튼 눌림 \(sender.tag)")
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
    
    // 숫자 3자리 마다 , 찍기
    func example(price: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(for: Int(price))
        return result ?? ""
    }
    
    // 네비게이션 영역 색상 설정
    func setNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .black
        
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.standardAppearance = appearance
       
        navigationController?.navigationBar.standardAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.scrollEdgeAppearance?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .white
        title = "쇼핑 검색"
    }
}
