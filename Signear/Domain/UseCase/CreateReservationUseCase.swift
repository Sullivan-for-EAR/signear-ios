//
//  CreateReservationUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/06/13.
//

import Foundation
import RxSwift

protocol CreateReservationUseCaseType {
    func createReservationUseCase(reservation: MakeReservationModel) -> Observable<Result<MakeReservationModel, APIError>>
}

class CreateReservationUseCase: CreateReservationUseCaseType {
    func createReservationUseCase(reservation: MakeReservationModel) -> Observable<Result<MakeReservationModel, APIError>> {
        return SignearAPI.shared.createReservation(reservation: reservation)
            .map { result in
                switch result {
                case .success(let data):
                    return .success(.init(date: data.date,
                                          startTime: data.startTime,
                                          endTime: data.endTime,
                                          area: data.area,
                                          address: data.address,
                                          meetingType: .init(rawValue: data.type) ?? MakeReservationModel.MeetingType.error,
                                          request: data.request))
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
