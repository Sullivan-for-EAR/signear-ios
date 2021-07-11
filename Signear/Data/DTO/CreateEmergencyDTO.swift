//
//  CreateEmergencyDTO.swift
//  signear
//
//  Created by 신정섭 on 2021/06/21.
//

import Foundation

enum CreateEmergencyDTO {
    struct Request: Codable {
        let date: String
        let startTime: String
        let endTime: String
        let type: Int
        let customerUser: CustomerUser
        
        enum CodingKeys: String, CodingKey {
            case date
            case startTime = "start_time"
            case endTime = "end_time"
            case type
            case customerUser
        }
    }
    
    struct Response: Codable {
        let rsID: Int
        let date: String
        let startTime: String
        let endTime: String
        let area: String?
        let address: String?
        let method: Int?
        let status: Int
        let type: Int
        let request: String?
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

extension CreateEmergencyDTO.Request {
    struct CustomerUser: Codable {
        let customerID: Int
    }
}

extension CreateEmergencyDTO.Response {
    struct CustomerUser: Codable {
        let customerID: Int
    }
}
