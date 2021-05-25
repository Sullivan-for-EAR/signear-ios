//
//  MyPageViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/25.
//

import Foundation

protocol MyPageViewModelInputs {
}

protocol MyPageViewModelOutputs {
}

protocol MyPageViewModelType {
    var inputs: MyPageViewModelInputs { get }
    var outputs: MyPageViewModelOutputs { get }
}

class MyPageViewModel: MyPageViewModelType {
    
}

extension MyPageViewModel: MyPageViewModelInputs {
    var inputs: MyPageViewModelInputs { return self }
}

extension MyPageViewModel: MyPageViewModelOutputs {
    var outputs: MyPageViewModelOutputs { return self }
}
