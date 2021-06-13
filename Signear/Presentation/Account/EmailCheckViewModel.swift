//
//  EmailCheckViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/05.
//

import Foundation
import RxCocoa
import RxSwift

protocol EmailCheckViewModelInputs {
    func checkEmail(_ email: String)
}

protocol EmailCheckViewModelOutputs {
    var checkEmailResult: Driver<Bool> { get }
}

protocol EmailCheckViewModelType {
    var inputs: EmailCheckViewModelInputs { get }
    var outputs: EmailCheckViewModelOutputs { get }
}

class EmailCheckViewModel: EmailCheckViewModelType {
    private let disposeBag = DisposeBag()
    private let useCase = EmailCheckUseCase()
    private let _checkEmailResult: PublishRelay<Bool> = .init()
}

extension EmailCheckViewModel: EmailCheckViewModelInputs {
    
    var inputs: EmailCheckViewModelInputs { return self }
    
    func checkEmail(_ email: String) {
        useCase.emailCheck(with: email)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let isExist):
                    self?._checkEmailResult.accept(isExist)
                case .failure(_):
                    // error 처리
                    return
                }
            }).disposed(by: disposeBag)
    }
}

extension EmailCheckViewModel: EmailCheckViewModelOutputs {
    var outputs: EmailCheckViewModelOutputs { return self }
    var checkEmailResult: Driver<Bool> { _checkEmailResult.asDriver(onErrorJustReturn: false) }
}
