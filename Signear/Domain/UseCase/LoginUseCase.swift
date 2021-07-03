//
//  LoginUseCase.swift
//  signear
//
//  Created by 홍필화 on 2021/05/09.
//

import Foundation
import RxSwift

protocol LoginUseCaseType {
    func login(email: String, password: String) -> Observable<Result<Bool, APIError>>
}

class LoginUseCase: LoginUseCaseType {
    func login(email: String, password: String) -> Observable<Result<Bool, APIError>> {
        return SignearAPI.shared.login(email: email, password: password)
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
