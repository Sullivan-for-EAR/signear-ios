//
//  ReservationListViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/11.
//

import Foundation
import RxCocoa
import RxSwift

protocol ReservationListViewModelInputs {
    func fetchReservations()
    func cancelEmergencyCall(reservationId: Int)
}

protocol ReservationListViewModelOutputs {
    var reservations: Driver<[ReservationModel]> { get }
}

protocol ReservationListViewModelType {
    var inputs: ReservationListViewModelInputs { get }
    var outputs: ReservationListViewModelOutputs { get }
}

class ReservationListViewModel: ReservationListViewModelType {

    // MARK: - Properties : Private
    
    private let disposeBag = DisposeBag()
    private let fetchReservationsuseCase: FetchReservationsUseCaseType
    private let cancelEmergencyCallUseCase: CancelEmergencyCallUseCaseType
    private var _reservations: PublishRelay<[ReservationModel]> = .init()
    
    // MARK: - Constructor
    
    init(fetchReservationsuseCase: FetchReservationsUseCaseType,
         cancelEmergencyCallUseCase: CancelEmergencyCallUseCaseType) {
        self.fetchReservationsuseCase = fetchReservationsuseCase
        self.cancelEmergencyCallUseCase = cancelEmergencyCallUseCase
    }
    
    convenience init() {
        self.init(fetchReservationsuseCase: FetchReservationsUseCase(),
                  cancelEmergencyCallUseCase: CancelEmergencyCallUseCase())
    }
}

// MARK: - ReservationListViewModelInputs

extension ReservationListViewModel: ReservationListViewModelInputs {
    
    var inputs: ReservationListViewModelInputs { return self }
    
    func fetchReservations() {
        fetchReservationsuseCase.fetchReservations()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let reservations):
                    self?._reservations.accept(reservations)
                case .failure:
                    self?._reservations.accept([])
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    func cancelEmergencyCall(reservationId: Int) {
        cancelEmergencyCallUseCase.cancel(reservationId: reservationId)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(_):
                    self?.fetchReservations()
                case .failure:
                    // TODO : 예외처리
                    break
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - ReservationListViewModelOutputs

extension ReservationListViewModel: ReservationListViewModelOutputs {
    
    var outputs: ReservationListViewModelOutputs { return self }
    var reservations: Driver<[ReservationModel]> { _reservations.asDriver(onErrorJustReturn: []) }
}
