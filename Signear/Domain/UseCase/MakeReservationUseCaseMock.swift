//
//  MakeReservationUseCaseMock.swift
//  signear
//
//  Created by 홍필화 on 2021/05/28.
//

import Foundation
import RxCocoa
import RxSwift

class MakeReservationUseCaseMock: MakeReservationUseCaseType {
    
    var callsCount: Int = 0
    var result: Observable<[MakeReservationModel]>!
    
    func fetchReservation() -> Observable<[MakeReservationModel]> {
        callsCount += 1
        return result
    }
}
