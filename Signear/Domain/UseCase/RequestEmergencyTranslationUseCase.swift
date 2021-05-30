//
//  RequestEmergencyTranslationUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/05/26.
//

import Foundation
import RxSwift

protocol RequestEmergencyTranslationUseCaseType {
    func requestEmergencyTranslation() -> Observable<Bool>
}

class RequestEmergencyTranslationUseCase: RequestEmergencyTranslationUseCaseType {
    
    func requestEmergencyTranslation() -> Observable<Bool> {
        // TODO : API
        return .just(true)
    }
}
