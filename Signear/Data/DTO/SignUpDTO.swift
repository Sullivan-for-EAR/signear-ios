//
//  SignUpDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/06/08.
//

import Foundation

enum SignUpDTO {
    struct Request: Codable {
        let email: String
        let password: String
        let phone: String
    }
    
    struct Response: Codable {
        let accessToken: String
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
        }
    }
}
