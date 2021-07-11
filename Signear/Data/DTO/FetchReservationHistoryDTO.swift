//
//  FetchReservationHistoryDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/07/11.
//

import Foundation

enum FetchReservationHistoryDTO {
    struct Request: Encodable {
        let customerId: String
        
        private enum CodingKeys: String, CodingKey {
            case customerId = "customer_id"
        }
    }
}
