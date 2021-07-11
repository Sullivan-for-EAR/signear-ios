//
//  DeleteReservationHistoryUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/07/11.
//

import Foundation
import RxSwift

protocol DeleteReservationHistoryUseCaseType {
    func delete(reservationId: Int) -> Observable<Result<Bool, APIError>>
}

class DeleteReservationHistoryUseCase: DeleteReservationHistoryUseCaseType {
    func delete(reservationId: Int) -> Observable<Result<Bool, APIError>> {
        return SignearAPI.shared.deleteReservationHistory(reservationId: reservationId)
    }
}
