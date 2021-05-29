//
//  EmergencyViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/26.
//

import Foundation
import RxCocoa
import RxSwift

protocol EmergencyViewModelInputs {
    func requestEmergencyTranslation()
}

protocol EmergencyViewModelOutputs {
    var result: Driver<Bool> { get }
}

protocol EmergencyViewModelType {
    var inputs: EmergencyViewModelInputs { get }
    var outputs: EmergencyViewModelOutputs { get }
}

class EmergencyViewModel: EmergencyViewModelType {
    
    // MARK: - Properties - Private
    private let disposeBag = DisposeBag()
    private let useCase: RequestEmergencyTranslationUseCaseType
    private var _result: PublishRelay<Bool> = .init()
    
    // MARK: - Constructor
    
    init(useCase: RequestEmergencyTranslationUseCaseType) {
        self.useCase = useCase
    }
    
    convenience init() {
        self.init(useCase: RequestEmergencyTranslationUseCase())
    }
    
}

// MARK: - EmergencyViewModelInputs

extension EmergencyViewModel: EmergencyViewModelInputs {
    
    var inputs: EmergencyViewModelInputs { return self }
    
    func requestEmergencyTranslation() {
        useCase.requestEmergencyTranslation()
            .catchAndReturn(false)
            .bind(to: _result)
            .disposed(by: disposeBag)
    }
}

// MARK: - EmergencyViewModelOutputs

extension EmergencyViewModel: EmergencyViewModelOutputs {
    
    var outputs: EmergencyViewModelOutputs { return self }
    
    var result: Driver<Bool> { _result.asDriver(onErrorJustReturn: false) }
}
