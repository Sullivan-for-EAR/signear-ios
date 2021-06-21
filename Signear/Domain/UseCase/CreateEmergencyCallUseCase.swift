//
//  CreateEmergencyCallUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/06/21.
//

import Foundation
import RxSwift

protocol CreateEmergencyCallUseCaseType {
    func call() -> Observable<Result<Bool, APIError>>
}

class CreateEmergencyCallUseCase: CreateEmergencyCallUseCaseType {
    func call() -> Observable<Result<Bool, APIError>> {
        return SignearAPI.shared.createEmergencyCall()
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
