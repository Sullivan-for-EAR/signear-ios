//
//  CreateReservationUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/06/13.
//

import Foundation
import RxSwift

protocol CreateReservationUseCaseType {
    func createReservationUseCase(reservation: MakeReservationModel) -> Observable<Result<Bool, APIError>>
}

class CreateReservationUseCase: CreateReservationUseCaseType {
    func createReservationUseCase(reservation: MakeReservationModel) -> Observable<Result<Bool, APIError>> {
        return SignearAPI.shared.createReservation(reservation: reservation)
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
