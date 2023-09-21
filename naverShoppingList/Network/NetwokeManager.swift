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
    

    
    func callRequest(api: NetworkAPI, completionHandler: @escaping (Result<NaverShopping, NaverAPIError>) -> Void) {

        // Alamofire에서 ErrorHandling을 하려면 어떻게 할까?
        AF.request(api.endPoint, parameters: api.query, headers: api.header).validate(statusCode: 200...500)
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
