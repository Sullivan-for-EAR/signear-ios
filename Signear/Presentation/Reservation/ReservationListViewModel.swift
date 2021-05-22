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
    private let useCase: FetchReservationsUseCaseType
    private var _reservations: BehaviorRelay<[ReservationModel]> = .init(value: [])
    
    // MARK: - Constructor
    
    convenience init() {
        self.init(useCase: FetchReservationsUseCase())
    }
    
    init(useCase: FetchReservationsUseCaseType) {
        self.useCase = useCase
    }
}

// MARK: - ReservationListViewModelInputs

extension ReservationListViewModel: ReservationListViewModelInputs {
    
    var inputs: ReservationListViewModelInputs { return self }
    
    func fetchReservations() {
        useCase.fetchReservations()
            .bind(to: _reservations)
            .disposed(by: disposeBag)
    }
    
}

// MARK: - ReservationListViewModelOutputs

extension ReservationListViewModel: ReservationListViewModelOutputs {
    
    var outputs: ReservationListViewModelOutputs { return self }
    var reservations: Driver<[ReservationModel]> { _reservations.asDriver(onErrorJustReturn: []) }
}
