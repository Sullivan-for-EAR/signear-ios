//
//  FetchReservationsDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/07/01.
//

import Foundation

enum FetchReservationsDTO {
    
    struct Request: Codable {
        let customerId: Int
        
        enum CodingKeys: String, CodingKey {
            case customerId = "customer_id"
        }
    }
}
