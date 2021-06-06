//
//  MakeReservationModel.swift
//  signear
//
//  Created by 홍필화 on 2021/05/23.
//

import UIKit

struct MakeReservationModel: Equatable {
    var date: String
    var startTime: String
    var endTime: String
    var center: String
    var location: String
    var requests: String
    var type: ReservationType
    
    init(date: String, startTime: String, endTime: String, center: String, location: String, requests: String, type: ReservationType) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.center = center
        self.location = location
        self.requests = requests
        self.type = type
    }
    
    mutating func changeData(date: String, startTime: String, endTime: String, center: String, location: String, requests: String, type: ReservationType) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.center = center
        self.location = location
        self.requests = requests
        self.type = type
    }
}

enum ReservationType {
    case offline
    case online
}
