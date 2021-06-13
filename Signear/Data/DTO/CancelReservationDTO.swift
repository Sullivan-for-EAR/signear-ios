//
//  CancelReservationDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/06/13.
//

import Foundation

enum CancelReservationDTO {
    struct Response: Codable {
        let rsID: Int
        let date: String
        let startTime: String
        let endTime: String
        let area: String
        let address: String
        let method: Int
        let status: Int
        let type: Int
        let request: String
        let reject: String?
    }
}
