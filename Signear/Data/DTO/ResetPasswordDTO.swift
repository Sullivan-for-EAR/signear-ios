//
//  ResetPasswordDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/06/08.
//

import Foundation

enum ResetPasswordDTO {
    struct Request: Codable {
        let email: String
    }
}
