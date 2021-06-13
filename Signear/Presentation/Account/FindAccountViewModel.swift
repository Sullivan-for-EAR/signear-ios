//
//  FindAccountViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/09.
//

import Foundation
import RxCocoa
import RxSwift

protocol FindAccountViewModelInputs {
    func resetPassword(email: String)
}

protocol FindAccountViewModelOutputs {
    var resetPasswordResult: Driver<Bool> { get }
}

protocol FindAccountViewModelType {
    var inputs: FindAccountViewModelInputs { get }
    var outputs: FindAccountViewModelOutputs { get }
}

class FindAccountViewModel: FindAccountViewModelType {
    private let disposeBag = DisposeBag()
    private let useCase = ResetPasswordUseCase()
    private let _resetPasswordResult: PublishRelay<Bool> = .init()
}

// MARK : FindAccountViewModelInputs

extension FindAccountViewModel: FindAccountViewModelInputs {
    
    var inputs: FindAccountViewModelInputs { return self }
    func resetPassword(email: String) {
        useCase.resetPassword(email: email)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let result):
                    self?._resetPasswordResult.accept(result)
                case .failure(_):
                    // TODO : error 처리
                    break
                }
            }).disposed(by: disposeBag)
    }
}

// MARK : FindAccountViewModelOutputs

extension FindAccountViewModel: FindAccountViewModelOutputs {
    
    var outputs: FindAccountViewModelOutputs { return self }
    var resetPasswordResult: Driver<Bool> { _resetPasswordResult.asDriver(onErrorJustReturn: false) }
}
