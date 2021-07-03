//
//  CancelEmergencyCallUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/07/03.
//

import Foundation
import RxSwift

protocol CancelEmergencyCallUseCaseType {
    func cancel(reservationId: Int) -> Observable<Result<Bool, APIError>>
}

class CancelEmergencyCallUseCase: CancelEmergencyCallUseCaseType {
    
    func cancel(reservationId: Int) -> Observable<Result<Bool, APIError>> {
        return SignearAPI.shared.cancelEmergencyCall(reservationId: reservationId)
            .map { result in
                switch result {
                case .success(_):
                    return .success(true)
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
