//
//  FetchReservationInfoDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/06/08.
//

import Foundation

enum FetchReservationInfoDTO {
    
    struct Request: Codable {
        let customerId: Int
        
        enum CodingKeys: String, CodingKey {
            case customerId = "customer_id"
        }
    }
    
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

extension FetchReservationInfoDTO.Response {
    func toDomain() -> ReservationModel {
        return .init(rsID: rsID,
                     date: date,
                     startTime: startTime,
                     endTime: endTime,
                     area: area,
                     address: address,
                     method: .init(rawValue: method) ?? ReservationModel.MeetingType.error,
                     status: .init(rawValue: status) ?? ReservationModel.Status.error,
                     type: .init(rawValue: type) ?? ReservationModel.CallType.error,
                     request: request,
                     reject: reject)
    }
    
    func toDomain() -> ReservationInfoModel {
        return .init(rsID: rsID,
                     date: date,
                     startTime: startTime,
                     endTime: endTime,
                     area: area,
                     address: address,
                     method: .init(rawValue: method) ?? ReservationInfoModel.MeetingType.error,
                     status: .init(rawValue: status) ?? ReservationInfoModel.Status.error,
                     type: .init(rawValue: type) ?? ReservationInfoModel.CallType.error,
                     request: request,
                     reject: reject)
    }
}
