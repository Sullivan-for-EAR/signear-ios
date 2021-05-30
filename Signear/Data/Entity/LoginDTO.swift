//
//  LoginDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/05/30.
//

import Foundation

enum LoginDTO {
    struct RequestDTO: Codable {
        let email: String
        let password: String
    }
    
    struct ResponseDTO: Codable {
        let accesstoken: String
    }
}
