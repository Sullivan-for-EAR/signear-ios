//
//  APIManager.swift
//  signear
//
//  Created by 신정섭 on 2021/05/30.
//

import Foundation
import Alamofire

class APIManager {
    
    // MARK: - Properties - Static
    
    static let shared = APIManager()
    
    // MARK: - Properties - Internal
    
    enum Constants {
        // baseURL
        #if DEBUG
        static let baseURL = ""
        #else
        static let baseURL = ""
        #endif
        static let loginURL = ""
    }
    
    // MARK: - Life Cycle
    
    private init() { }
}
