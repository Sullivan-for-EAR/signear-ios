//
//  FetchReservationInfoDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/06/08.
//

import Foundation

enum FetchReservationInfoDTO {
    struct Response {
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
