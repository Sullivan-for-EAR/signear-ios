//
//  FetchAreaUseCase.swift
//  signear
//
//  Created by 신정섭 on 2021/06/29.
//

import Foundation
import RxSwift

protocol FetchAreaUseCaseType {
    func fetchArea() -> Observable<Result<[String], Error>>
}

class FetchAreaUseCase: FetchAreaUseCaseType {
    func fetchArea() -> Observable<Result<[String], Error>> {
        // TODO : repo로 넘기기
        return .just(.success(["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]))
    }
}
