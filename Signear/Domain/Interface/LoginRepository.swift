//
//  LoginRepository.swift
//  signear
//
//  Created by 신정섭 on 2021/05/30.
//

import Foundation
import RxSwift

protocol LoginRepository {
    func login(email: String, password: String)
}
