//
//  InitialViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/05.
//

import Foundation

protocol InitialViewModelInputs {
}

protocol InitialViewModelOutputs {
}

protocol InitialViewModelType {
    var inputs: InitialViewModelInputs { get }
    var outputs: InitialViewModelOutputs { get }
}

class InitialViewModel: InitialViewModelType {
    
}

extension InitialViewModel: InitialViewModelInputs {
    
    var inputs: InitialViewModelInputs { return self }
}

extension InitialViewModel: InitialViewModelOutputs {
    
    var outputs: InitialViewModelOutputs { return self }
}
