//
//  FetchProfileUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/05/26.
//

import Foundation
import RxSwift

protocol FetchProfileUseCaseType {
    func fetchProfile() -> Observable<Result<ProfileModel, APIError>>
}

class FetchProfileUseCase: FetchProfileUseCaseType {
    func fetchProfile() -> Observable<Result<ProfileModel, APIError>> {
        return SignearAPI.shared.getUserInfo()
            .map { response in
                switch response {
                case .success(let data):
                    return .success(.init(name: data.email, phoneNumber: data.phone))
                case .failure(let error):
                    return .failure(error)
                }
            }
    }
}
