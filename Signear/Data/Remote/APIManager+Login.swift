//
//  APIManager+Login.swift
//  signear
//
//  Created by 신정섭 on 2021/05/30.
//

import Foundation
import Alamofire
import RxSwift

extension APIManager: LoginRepository {
    
    func login(email: String, password: String) -> Observable<LoginDTO.ResponseDTO> {
        // TODO : API 에 맞게 alamofire 설정하기
        let url = Constants.baseURL + Constants.loginURL
        let requestDTO = LoginDTO.RequestDTO(email: email, password: password)
        return .just(.init(accesstoken: "test"))
    }
}
