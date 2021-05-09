//
//  EmailCheckViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/05.
//

import Foundation

protocol EmailCheckViewModelInputs {
}

protocol EmailCheckViewModelOutputs {
}

protocol EmailCheckViewModelType {
    var inputs: EmailCheckViewModelInputs { get }
    var outputs: EmailCheckViewModelOutputs { get }
}

class EmailCheckViewModel: EmailCheckViewModelType {
    
}

extension EmailCheckViewModel: EmailCheckViewModelInputs {
    
    var inputs: EmailCheckViewModelInputs { return self }
}

extension EmailCheckViewModel: EmailCheckViewModelOutputs {
    
    var outputs: EmailCheckViewModelOutputs { return self }
}
