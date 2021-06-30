//
//  EmailCheckUseCase.swift
//  signear
//
//  Created by 홍필화 on 2021/05/09.
//

import Foundation
import RxSwift

protocol EmailCheckUseCaseType {
    func emailCheck(with email: String) -> Observable<Result<Bool, APIError>>
}

class EmailCheckUseCase: EmailCheckUseCaseType {
    func emailCheck(with email: String) -> Observable<Result<Bool, APIError>> {
        return .just(.success(true))
//        return SignearAPI.shared.checkEmail(email)
//            .map { result in
//                switch result {
//                case .success(let isExsit):
//                    return .success(isExsit.isNext)
//                case .failure(let error):
//                    return .failure(error)
//                }
//            }
    }
}
