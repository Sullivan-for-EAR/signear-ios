//
//  SignUpViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/09.
//

import Foundation
import RxCocoa
import RxSwift

protocol SignUpViewModelInputs {
    func signUp(email: String, password: String, phoneNumber: String)
}

protocol SignUpViewModelOutputs {
    var signUpResult: Driver<Bool> { get }
}

protocol SignUpViewModelType {
    var inputs: SignUpViewModelInputs { get }
    var outputs: SignUpViewModelOutputs { get }
}

class SignUpViewModel: SignUpViewModelType {
    private let disposeBag = DisposeBag()
    private let useCase = SignUpUseCase()
    private let _signUpResult: PublishRelay<Bool> = .init()
}

extension SignUpViewModel: SignUpViewModelInputs {
    
    var inputs: SignUpViewModelInputs { return self }
    
    func signUp(email: String, password: String, phoneNumber: String) {
        useCase.signUp(email: email,
                       password: password,
                       phoneNumber: phoneNumber)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let result):
                    self?._signUpResult.accept(result)
                case .failure(_):
                    // TODO: error 처리
                    return
                }
            }).disposed(by: disposeBag)
    }
}

extension SignUpViewModel: SignUpViewModelOutputs {
    var outputs: SignUpViewModelOutputs { return self }
    var signUpResult: Driver<Bool> { _signUpResult.asDriver(onErrorJustReturn: false) }
}
