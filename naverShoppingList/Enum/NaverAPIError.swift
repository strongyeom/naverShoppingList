//
//  NaverAPIError.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/21.
//

import Foundation

enum NaverAPIError: Int, Error, LocalizedError {
    case incorrect_query = 400
    case not_contain_id_password = 401
    case no_use_api = 404
    case over_calling = 429
    case invalidServer = 500
    
    var naverErrorDescription: String {
        switch self {
        case .incorrect_query:
            return "올바르지 않은 쿼리입니다."
        case .not_contain_id_password:
            return "클라이언트 ID와 패스워드가 없습니다."
        case .no_use_api:
            return "올바르지 않은 API 입니다."
        case .over_calling:
            return "API 호출이 일일 한도를 초과하였습니다."
        case .invalidServer:
            return "서버가 올바르지 않습니다."
        }
    }
}
