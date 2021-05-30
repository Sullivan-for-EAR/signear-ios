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
    func fetchReservationInfo()
    func cancelReservation()
}

protocol ReservationInfoViewModelOutputs {
    var reservationInfo: Driver<ReservationInfoModel> { get }
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
    private var _reservationInfo: PublishRelay<ReservationInfoModel> = .init()
    private var _cancelResult: PublishRelay<Bool> = .init()
    
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
    
    func fetchReservationInfo() {
        fetchReservationInfoUseCase.fetchReservationInfo()
            .bind(to: _reservationInfo)
            .disposed(by: disposeBag)
    }
    
    func cancelReservation() {
        cancelReservationUseCase.cancelReservation()
            .bind(to: _cancelResult)
            .disposed(by: disposeBag)
    }
}

// MARK: - ReservationInfoViewModelOutputs

extension ReservationInfoViewModel: ReservationInfoViewModelOutputs {
    var cancelResult: Driver<Bool> {
        _cancelResult.asDriver(onErrorJustReturn: false)
    }
    
    var outputs: ReservationInfoViewModelOutputs { return self }
    var reservationInfo: Driver<ReservationInfoModel> { _reservationInfo.asDriver(onErrorJustReturn: .init()) }
}
