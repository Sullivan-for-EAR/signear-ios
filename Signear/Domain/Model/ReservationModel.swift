//
//  ReservationModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/22.
//

import UIKit

struct ReservationModel: Equatable {
    let title: String
    let date: String
    let status: Status
}

extension ReservationModel {
    enum MeetingType {
        case sign
        case video
    }
    
    enum Status {
        case unread
        case check
        case confirm
        case reject
    }
}

// MARK: - ReservationStatus Image

extension ReservationModel.Status {
    func getImage() -> UIImage? {
        switch self {
        case .unread:
            return UIImage.init(named: "unreadReservationIcon")
        case .check:
            return UIImage.init(named: "checkReservationIcon")
        case .confirm:
            return UIImage.init(named: "confirmReservationIcon")
        case .reject:
            return UIImage.init(named: "rejectReservationIcon")
        }
    }
}
