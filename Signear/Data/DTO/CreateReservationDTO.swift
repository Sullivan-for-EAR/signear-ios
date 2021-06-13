//
//  CreateReservationDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/06/08.
//

import Foundation

enum CreateReservationDTO {
    struct Request: Codable {
        let date: String
        let startTime: String
        let endTime: String
        let area: String
        let address: String
        let method: Int
        let type: Int
        let request: String
        let customerUser: customerUser
    }
    
    // TODO : Response Data 는 의미가 없음 bool 형태로 그냥 내보내는게 좋음.
}

extension CreateReservationDTO.Request {
    struct customerUser: Codable {
        let customerID: Int
    }
}
