//
//  CreateReservationDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/06/08.
//

import Foundation

enum CreateReservationDTO {
    struct Request: Codable {
        var date: String
        var startTime: String
        var endTime: String
        var area: String
        var address: String
        var method: Int
        var type: Int
        var request: String
        var customerUser: CustomerUser
        
        init(date: String,
             startTime: String,
             endTime: String,
             area: String,
             address: String,
             method: Int,
             type: Int,
             request: String,
             customerUser: CustomerUser) {
            self.date = date
            self.startTime = startTime
            self.endTime = endTime
            self.area = area
            self.address = address
            self.method = method
            self.type = type
            self.request = request
            self.customerUser = customerUser
        }
        
        init(reservation: MakeReservationModel, customerId: Int) {
            self.date = reservation.date
            self.startTime = reservation.startTime
            self.endTime = reservation.endTime
            self.area = reservation.area
            self.address = reservation.address
            self.method = reservation.meetingType.rawValue
            self.type = 1
            self.request = reservation.request
           self.customerUser = CustomerUser(customerID: customerId)
        }
        
        enum CodingKeys: String, CodingKey {
            case date
            case startTime = "start_time"
            case endTime = "end_time"
            case area
            case address
            case method
            case type
            case request
            case customerUser
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
        let customerUser: CustomerUser
        
        enum CodingKeys: String, CodingKey {
            case rsID
            case date
            case startTime = "start_time"
            case endTime = "end_time"
            case area
            case address
            case method
            case status
            case type
            case request
            case reject
            case customerUser
        }
    }
}

extension CreateReservationDTO.Request {
    struct CustomerUser: Codable {
        let customerID: Int
    }
}

extension CreateReservationDTO.Response {
    struct CustomerUser: Codable {
        let customerID: Int
    }
}
