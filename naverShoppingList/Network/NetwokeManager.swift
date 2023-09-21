//
//  NetwokeManager.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import Foundation
import Alamofire

final class NetwokeManager {
    static let shared = NetwokeManager()
    
    private init() { }
    

    
    func callRequest(searText: String?, start: Int, sort: ProductSort, completionHandler: @escaping (Result<NaverShopping, NaverAPIError>) -> Void) {
        guard let searText else { return }
        let text : String = searText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&display=30&start=\(start)&sort=\(sort.rawValue)"
        print("url",url)
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "myXCWsXxrg83Q4L0SAdP",
            "X-Naver-Client-Secret": "2s8Jgd07Ij"
        ]
        
        // Alamofire에서 ErrorHandling을 하려면 어떻게 할까?
        AF.request(url, headers: header).validate(statusCode: 200...500)
            .responseDecodable(of: NaverShopping.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(.success(data))
                case .failure(_):
                    let status = response.response?.statusCode ?? 500
                    guard let error = NaverAPIError(rawValue: status) else {
                        return
                    }
                    completionHandler(.failure(error))
                }
            }
    }
}
