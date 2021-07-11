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
    private let useCase: CreateEmergencyCallUseCaseType
    private var _result: PublishRelay<Bool> = .init()
    
    // MARK: - Constructor
    
    init(useCase: CreateEmergencyCallUseCaseType) {
        self.useCase = useCase
    }
    
    convenience init() {
        self.init(useCase: CreateEmergencyCallUseCase())
    }
    
}

// MARK: - EmergencyViewModelInputs

extension EmergencyViewModel: EmergencyViewModelInputs {
    
    var inputs: EmergencyViewModelInputs { return self }
    
    func requestEmergencyTranslation() {
        useCase.call()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(_):
                    self?._result.accept(true)
                case .failure(_):
                    break
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - EmergencyViewModelOutputs

extension EmergencyViewModel: EmergencyViewModelOutputs {
    
    var outputs: EmergencyViewModelOutputs { return self }
    
    var result: Driver<Bool> { _result.asDriver(onErrorJustReturn: false) }
}
