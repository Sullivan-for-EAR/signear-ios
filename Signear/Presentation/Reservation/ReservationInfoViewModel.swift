//
//  ReservationInfoViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/30.
//

import Foundation
import RxCocoa
import RxSwift

protocol ReservationInfoViewModelInputs {
    func fetchReservationInfo(reservationId: Int)
    func cancelReservation(reservationId: Int)
}

protocol ReservationInfoViewModelOutputs {
    var reservationInfo: Driver<ReservationInfoModel?> { get }
    var cancelResult: Driver<Bool> { get }
}

protocol ReservationInfoViewModelType {
    var inputs: ReservationInfoViewModelInputs { get }
    var outputs: ReservationInfoViewModelOutputs { get }
}

class ReservationInfoViewModel: ReservationInfoViewModelType {
    
    // MARK: - Properties - Private
    private let fetchReservationInfoUseCase: FetchReservationInfoUseCaseType
    private let cancelReservationUseCase: CancelReservationUseCaseType
    private let disposeBag = DisposeBag()
    private var _reservationInfo: PublishRelay<ReservationInfoModel?> = .init()
    private var _cancelResult: PublishRelay<Bool> = .init()
    private var reservationId: Int?
    
    init(fetchReservationInfoUseCase: FetchReservationInfoUseCaseType,
         cancelReservationUseCase: CancelReservationUseCaseType) {
        self.fetchReservationInfoUseCase = fetchReservationInfoUseCase
        self.cancelReservationUseCase = cancelReservationUseCase
    }
    
    convenience init() {
        self.init(fetchReservationInfoUseCase: FetchReservationInfoUseCase(),
                  cancelReservationUseCase: CancelReservationUseCase())
    }
}

// MARK: - ReservationInfoViewModelInputs

extension ReservationInfoViewModel: ReservationInfoViewModelInputs {
    
    var inputs: ReservationInfoViewModelInputs { return self }
    
    func fetchReservationInfo(reservationId: Int) {
        self.reservationId = reservationId
        fetchReservationInfoUseCase.fetchReservationInfo(reservationId: reservationId)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let info):
                    self?._reservationInfo.accept(info)
                    break
                case .failure:
                    // TODO : API Error 처리
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    func cancelReservation(reservationId: Int) {
        cancelReservationUseCase.cancelReservation(reservationId: reservationId)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let result):
                    self?._cancelResult.accept(result)
                    break
                case .failure(_):
                    // TODO : API Error 처리
                    break
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - ReservationInfoViewModelOutputs

extension ReservationInfoViewModel: ReservationInfoViewModelOutputs {
    var cancelResult: Driver<Bool> {
        _cancelResult.asDriver(onErrorJustReturn: false)
    }
    
    var outputs: ReservationInfoViewModelOutputs { return self }
    var reservationInfo: Driver<ReservationInfoModel?> { _reservationInfo.asDriver(onErrorJustReturn: nil) }
}
