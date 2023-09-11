//
//  NetwokeManager.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import Foundation
import Alamofire

class NetwokeManager {
    static let shared = NetwokeManager()
    
    private init() { }
    


    
    func callRequest(searText: String?, start: Int, sort: ProductSort, completionHandler: @escaping (NaverShopping?) -> Void) {
        guard let searText else { return }
        let text : String = searText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(text)&display=10&start=\(start)&sort=\(sort.rawValue)"
        
        //var components = URLComponents(string: "https://openapi.naver.com/v1/search/shop.json?")!

//        let query = URLQueryItem(name: "query", value: text)
//        let display = URLQueryItem(name: "display", value: "\(display)")
//        let start = URLQueryItem(name: "start", value: "\(start)")
//        print("sort.rawValue",sort.rawValue)
//        let sort = URLQueryItem(name: "sort", value: sort.rawValue)
//        components.queryItems = [query, display, start, sort]
//        guard let url = components.url else { return }
        print("url",url)
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id": "myXCWsXxrg83Q4L0SAdP",
            "X-Naver-Client-Secret": "2s8Jgd07Ij"
        ]
        
        AF.request(url, headers: header).validate(statusCode: 200...500)
            .responseDecodable(of: NaverShopping.self) { response in
                switch response.result {
                case .success(let data):
                    completionHandler(data)
                case .failure(let error):
                    print(error)
                }
            }
    }
}
