//
//  ResetPasswordUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/06/13.
//

import Foundation
import RxSwift

protocol ResetPasswordUseCaseType {
    func resetPassword(email: String) -> Observable<Result<Bool, APIError>>
}

class ResetPasswordUseCase: ResetPasswordUseCaseType {
    func resetPassword(email: String) -> Observable<Result<Bool, APIError>> {
        return SignearAPI.shared.resetPassword(email: email)
    }
}
