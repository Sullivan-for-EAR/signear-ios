//
//  ReservationHistoryViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/26.
//

import Foundation
import RxCocoa
import RxSwift

protocol ReservationHistoryViewModelInputs {
    func fetchReservationHistory()
}

protocol ReservationHistoryViewModelOutputs {
    var reservationHistory: Driver<[ReservationHistoryModel]> { get }
}

protocol ReservationHistoryViewModelType {
    var inputs: ReservationHistoryViewModelInputs { get }
    var outputs: ReservationHistoryViewModelOutputs { get }
}

class ReservationHistoryViewModel: ReservationHistoryViewModelType {
    
    // MARK: - Properties - Private
    
    private let useCase: FetchReservationHistoryUseCaseType
    private let disposeBag = DisposeBag()
    private var _reservationHistory: PublishRelay<[ReservationHistoryModel]> = .init()
    
    // MARK: - Constructor
    
    init(useCase: FetchReservationHistoryUseCaseType) {
        self.useCase = useCase
    }
    
    convenience init() {
        self.init(useCase: FetchReservationHistoryUseCase())
    }
    
}

// MARK: - ReservationHistoryViewModelInputs

extension ReservationHistoryViewModel: ReservationHistoryViewModelInputs {
    var inputs: ReservationHistoryViewModelInputs { return self }
    
    func fetchReservationHistory() {
        useCase.fetchReservationHistory()
            .catchAndReturn([])
            .bind(to: _reservationHistory)
            .disposed(by: disposeBag)
    }
}

// MARK: - ReservationHistoryViewModelOutputs

extension ReservationHistoryViewModel: ReservationHistoryViewModelOutputs {
    var outputs: ReservationHistoryViewModelOutputs { return self }
    var reservationHistory: Driver<[ReservationHistoryModel]> { _reservationHistory.asDriver(onErrorJustReturn: []) }
}
