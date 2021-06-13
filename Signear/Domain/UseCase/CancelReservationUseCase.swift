//
//  CancelReservationUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/05/30.
//

import Foundation
import RxSwift

protocol CancelReservationUseCaseType {
    func cancelReservation(reservationId: String) -> Observable<Result<Bool, APIError>>
}

class CancelReservationUseCase: CancelReservationUseCaseType {
    func cancelReservation(reservationId: String) -> Observable<Result<Bool, APIError>> {
        return SignearAPI.shared.cancelReservation(reservationId: reservationId)
            .map { response in
                switch response {
                case .success(_):
                    return .success(true)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
    
}
