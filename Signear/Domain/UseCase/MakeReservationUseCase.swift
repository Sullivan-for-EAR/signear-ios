//
//  MakeReservationUseCase.swift
//  signear
//
//  Created by 홍필화 on 2021/05/16.
//

import Foundation
import RxSwift

protocol MakeReservationUseCaseType {
    func fetchReservation() -> Observable<[MakeReservationModel]>
}

class MakeReservationUseCase: MakeReservationUseCaseType {
    func fetchReservation() -> Observable<[MakeReservationModel]> {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.dateFormat = "M월 dd일 EEEE"
        let dateStr = formatter.string(from: Date())
        
        
        let value = [MakeReservationModel(date: dateStr, startTime: "오전 00:00", endTime: "오전 00:00", center: "강동구", location: "", requests: "", type: .offline)]
        
        return .just(value)
    }
    
    
}
