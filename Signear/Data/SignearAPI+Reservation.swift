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
    func createReservation(reservation: MakeReservationModel) -> Observable<Result<CreateReservationDTO.Response, APIError>> {
        let url = Constants.baseURL + Constants.createReservationURL
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let token = self.token,
                  let customerId = self.customerId else {
                return Disposables.create()
            }
            let request =
                AF.request(url,
                           method: .post,
                           parameters: CreateReservationDTO.Request(reservation: reservation, customerId: customerId).toDictionary,
                           encoding: JSONEncoding.default,
                           headers: .init(token: token))
                .responseString { response in
                    printServerMessage(data: response.data)
                }
                .responseDecodable(of: CreateReservationDTO.Response.self) { response in
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
    
    func fetchReservations() -> Observable<Result<[FetchReservationInfoDTO.Response], APIError>> {
        let url = Constants.baseURL + Constants.fetchReservationListURL
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let token = self.token,
                  let customerId = self.customerId else {
                return Disposables.create()
            }
            let request =
                AF.request(url,
                           method: .get,
                           parameters: FetchReservationsDTO.Request(customerId: customerId).toDictionary,
                           encoding: URLEncoding.queryString,
                           headers: .init(token: token))
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
    
    func fetchReservationInfo(reservationId: Int) -> Observable<Result<FetchReservationInfoDTO.Response, APIError>> {
        let url = Constants.baseURL + Constants.fetchReservationInfoURL
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let token = self.token else {
                return Disposables.create()
            }
            let request =
                AF.request(url,
                           method: .get,
                           parameters: FetchReservationInfoDTO.Request(reservationId: reservationId).toDictionary,
                           encoding: URLEncoding.queryString,
                           headers: .init(token: token))
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
    
    func cancelReservation(reservationId: Int) -> Observable<Result<CancelReservationDTO.Response, APIError>> {
        let url = Constants.baseURL + Constants.cancelReservationURL.replacingOccurrences(of: "{reservationId}", with: "\(reservationId)")
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let token = self.token else {
                return Disposables.create()
            }
            let request =
                AF.request(url,
                           method: .post,
                           parameters: nil,
                           encoding: URLEncoding.queryString,
                           headers: .init(token: token))
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
