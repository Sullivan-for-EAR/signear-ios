//
//  SignearAPI+Emergency.swift
//  signear
//
//  Created by 신정섭 on 2021/06/21.
//

import Foundation
import Alamofire
import RxSwift

extension SignearAPI {
    func createEmergencyCall() -> Observable<Result<CreateEmergencyDTO.Response, APIError>> {
        let url = Constants.baseURL + Constants.createEmergencyCallURL
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDate = dateFormatter.string(from: Date())
        dateFormatter.dateFormat = "HHmm"
        let currentTime = dateFormatter.string(from: Date())
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let token = self.token,
                  let customerId = self.customerId else {
                return Disposables.create()
            }
            let request =
                AF.request(url,
                           method: .post,
                           parameters: CreateEmergencyDTO.Request(date: currentDate, startTime: currentTime, endTime: currentTime, type: 2, customerUser: .init(customerID: customerId)).toDictionary,
                           encoding: JSONEncoding.default,
                           headers: .init(token: token))
                .responseString { response in
                    printServerMessage(data: response.data)
                }
                .responseDecodable(of: CreateEmergencyDTO.Response.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        print(error.localizedDescription)
                        observer.onNext(.failure(.internalError(message: error.localizedDescription)))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
    
    func cancelEmergencyCall(reservationId: Int) -> Observable<Result<CancelEmergencyCallDTO.Response, APIError>> {
        let url = Constants.baseURL + Constants.cancelEmergencyCallURL.replacingOccurrences(of: "{reservationId}", with: "\(reservationId)")
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let token = self.token else {
                return Disposables.create()
            }
            let request =
                AF.request(url,
                           method: .post,
                           encoding: URLEncoding.default,
                           headers: .init(token: token))
                .responseString { response in
                    printServerMessage(data: response.data)
                }
                .responseDecodable(of: CancelEmergencyCallDTO.Response.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(.success(data))
                    case .failure(let error):
                        print(error.localizedDescription)
                        observer.onNext(.failure(.internalError(message: error.localizedDescription)))
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}
