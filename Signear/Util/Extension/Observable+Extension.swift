//
//  Observable+Extension.swift
//  signear
//
//  Created by 신정섭 on 2021/06/13.
//

import Foundation
import RxSwift

// ref : http://www.ccheptea.com/2019-03-25-handling-rest-errors-with-rxswift/
extension Observable where Element == (HTTPURLResponse, Data) {
    fileprivate func expectingObject<T : Codable>(ofType type: T.Type) -> Observable<Result<T, APIError>> {
        return self.map { (httpURLResponse, data) -> Result<T, APIError> in
            switch httpURLResponse.statusCode {
            case 200 ... 299:
                let object = try JSONDecoder().decode(type, from: data)
                return .success(object)
            default:
                return .failure(.internalError(message: "error"))
            }
        }
    }
}
