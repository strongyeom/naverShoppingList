//
//  NaverViewModel.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/22.
//

import Foundation

class NaverViewModel {
    var naverShopping = Observable(NaverShopping(total: 0, start: 0, display: 0, items: []))
    
    func request(query: String?, start: Int, sort: ProductSort) {
        NetwokeManager.shared.callRequest(api: NetworkAPI.naverShopping(query: query, start: start, sort: sort)) { response in
            switch response {
            case .success(let success):
                print("success",success.items.count)
                self.naverShopping.value.items.append(contentsOf: success.items)
            case .failure(let failure):
                print(failure.naverErrorDescription)
            }
        }
    }
    
}
