//
//  ReservationInfoModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/30.
//

import Foundation

struct ReservationInfoModel: Equatable {
    
    let status: String
    let location: String
    let center: String
    let date: String
    let time: String
    let type: String
    let description: String
    
    init() {
        self.init(status: "", location: "", center: "", date: "", time: "", type: "", description: "")
    }
    
    init(status: String,
         location: String,
         center: String,
         date: String,
         time: String,
         type: String,
         description: String) {
        self.status = status
        self.location = location
        self.center = center
        self.date = date
        self.time = time
        self.type = type
        self.description = description
    }
}
