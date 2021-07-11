//
//  DateFormatter+Extension.swift
//  signear
//
//  Created by 홍필화 on 2021/06/02.
//

import UIKit

extension DateFormatter {

    static let getDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "M월 dd일 EEEE"
        return formatter
    }()
    
    static let getTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "a h:mm"
        return formatter
    }()
    
    static func getDateString(date: Date) -> String {
        
        return DateFormatter.getDate.string(from: date)
    }
    
    static func getTimeString(date: Date) -> String {
        
        return DateFormatter.getTime.string(from: date)
    }
}
