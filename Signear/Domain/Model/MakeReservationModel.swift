//
//  MakeReservationModel.swift
//  signear
//
//  Created by 홍필화 on 2021/05/23.
//

import UIKit

struct MakeReservationModel {
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
        
        var getString: String {
            switch self {
            case .error:
                return ""
            case .sign:
                return "수어통역"
            case .video:
                return "화상통역"
            }
        }
    }
}

