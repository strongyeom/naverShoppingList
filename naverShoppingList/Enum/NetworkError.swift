//
//  NetworkError.swift
//  naverShoppingList
//
//  Created by 염성필 on 2023/09/08.
//

import Foundation

enum NetworkError: Error, CustomDebugStringConvertible {
    case isNotKey
    case isNotParsing
    case NotConnectNetwork
    
    var debugDescription: String {
        switch self {
        case .isNotKey:
            return "올바르지 않은 키입니다."
        case .isNotParsing:
            return "데이터 파싱이 되지 않았습니다."
        case .NotConnectNetwork:
            return "인터넷 연결이 끊겼습니다."
        }
    }
}
