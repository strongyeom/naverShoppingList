//
//  NetworkAPI.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/22.
//

import Foundation
import Alamofire

enum NetworkAPI {
    
    private var baseURL: String {
        return "https://openapi.naver.com/v1/search/shop.json?display=30"
    }
    
    case naverShopping(query: String, start: Int, sort: ProductSort)
    
    var endPoint: URL {
        switch self {
        case .naverShopping:
            return URL(string: baseURL)!
        }
    }
    
    var header: HTTPHeaders {
        return ["X-Naver-Client-Id": "myXCWsXxrg83Q4L0SAdP",
                "X-Naver-Client-Secret": "2s8Jgd07Ij"]
    }
    
    
    
    var query: [String: Any] {
        switch self {
        case .naverShopping(let query, let start, let sort):
            return ["query": query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
             "start": start,
             "sort": sort.rawValue] as [String : Any]
        }
    }
}
