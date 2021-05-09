//
//  LoginViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/09.
//

import Foundation

protocol LoginViewModelInputs {
}

protocol LoginViewModelOutputs {
}

protocol LoginViewModelType {
    var inputs: LoginViewModelInputs { get }
    var outputs: LoginViewModelOutputs { get }
}

class LoginViewModel: LoginViewModelType {
    
}

// MARK : LoginViewModelInputs

extension LoginViewModel: LoginViewModelInputs {
    
    var inputs: LoginViewModelInputs { return self }
}

// MARK : LoginViewModelOutputs

extension LoginViewModel: LoginViewModelOutputs {
    var outputs: LoginViewModelOutputs { return self }
}
