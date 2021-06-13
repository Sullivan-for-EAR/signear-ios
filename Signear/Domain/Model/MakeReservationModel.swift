//
//  MakeReservationModel.swift
//  signear
//
//  Created by 홍필화 on 2021/05/23.
//

import UIKit

struct MakeReservationModel: Equatable {
    var rsID: Int
    var date: String
    var startTime: String
    var endTime: String
    var area: String
    var address: String
    var meetingType: MeetingType
    var request: String
}

extension MakeReservationModel {
    // 수어통역 : 1, 화상통역:2
    enum MeetingType: Int {
        case error = 0
        case sign = 1
        case video = 2
    }
}

