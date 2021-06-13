//
//  SignearAPI+Reservation.swift
//  signear
//
//  Created by 신정섭 on 2021/06/13.
//

import Foundation
import Alamofire
import RxSwift

extension SignearAPI {
    func fetchReservations() -> Observable<Result<[FetchReservationInfoDTO.Response], APIError>> {
        let url = Constants.baseURL + Constants.fetchReservationListURL
        return Observable.create { [weak self] observer in
            let request =
                AF.request(url,
                           method: .get,
                           parameters: FetchReservationInfoDTO.Request(customerId: self?.customerId ?? "").toDictionary,
                           encoding: URLEncoding.queryString,
                           headers: .init(token: self?.token ?? ""))
                .responseString { response in
                    printServerMessage(data: response.data)
                }
                .responseDecodable(of: [FetchReservationInfoDTO.Response].self) { response in
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
    
    func fetchReservationInfo(reservationId: String) -> Observable<Result<FetchReservationInfoDTO.Response, APIError>> {
        let url = Constants.baseURL + Constants.fetchReservationListURL
        return Observable.create { [weak self] observer in
            let request =
                AF.request(url,
                           method: .get,
                           parameters: FetchReservationInfoDTO.Request(customerId: self?.customerId ?? "").toDictionary,
                           encoding: URLEncoding.queryString,
                           headers: .init(token: self?.token ?? ""))
                .responseString { response in
                    printServerMessage(data: response.data)
                }
                .responseDecodable(of: FetchReservationInfoDTO.Response.self) { response in
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
    
    func cancelReservation(reservationId: String) -> Observable<Result<CancelReservationDTO.Response, APIError>> {
        let url = Constants.baseURL + Constants.cancelReservationURL.replacingOccurrences(of: "{reservationId}", with: reservationId)
        return Observable.create { [weak self] observer in
            let request =
                AF.request(url,
                           method: .get,
                           parameters: nil,
                           encoding: URLEncoding.queryString,
                           headers: .init(token: self?.token ?? ""))
                .responseString { response in
                    printServerMessage(data: response.data)
                }
                .responseDecodable(of: CancelReservationDTO.Response.self) { response in
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
