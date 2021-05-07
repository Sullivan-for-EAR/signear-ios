//
//  CheckEmailUseCase.swift
//  signear
//
//  Created by 홍필화 on 2021/05/08.
//

import Foundation

protocol CheckEmailUseCaseInput {
    func input(_ string: String)
}

protocol CheckEmailUseCaseOutput {
    func output(_ string: String)
}

protocol CheckEmailUseCaseType {
    var inputs: CheckEmailUseCaseInput { get }
    var outputs: CheckEmailUseCaseOutput { get }
    
    func checkEmail(_ email: String)
}


class CheckEmailUseCase: CheckEmailUseCaseType, CheckEmailUseCaseInput, CheckEmailUseCaseOutput {
    
    var inputs: CheckEmailUseCaseInput { return self }
    var outputs: CheckEmailUseCaseOutput { return self }
    
    func input(_ string: String) {
        
    }
    
    func output(_ string: String) {
        
    }
    
    func checkEmail(_ email: String) {
        
    }
    
    
}
