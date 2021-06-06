//
//  MakeReservationViewModel.swift
//  signear
//
//  Created by 홍필화 on 2021/05/22.
//

import Foundation
import RxCocoa
import RxSwift

protocol MakeReservationViewModelInputs {
    func fetchReservation()
    func updateDate(_ date: String)
    func updateStartTime(_ startTime: String)
    func updateEndTime(_ endTime: String)
    func updateCenter(_ center: String)
    func updateLocation(_ location: String)
    func updateRequests(_ requests: String)
    func updateType(_ type: ReservationType)
    func makeReservation() -> Bool
}

protocol MakeReservationViewModelOutputs {
    var reservation: Driver<[MakeReservationModel]> { get }
}

protocol MakeReservationViewModelType {
    var inputs: MakeReservationViewModelInputs { get }
    var outputs: MakeReservationViewModelOutputs { get }
}

class MakeReservationViewModel: MakeReservationViewModelType {
    
    // MARK: Properties - Private
    
    private let disposeBag = DisposeBag()
    private let useCase: MakeReservationUseCaseType
    private var _reservation: BehaviorRelay<[MakeReservationModel]> = .init(value: [])
    
    // MARK: - Constructor
    
    init(useCase: MakeReservationUseCaseType) {
        self.useCase = useCase
    }
    
    convenience init() {
        self.init(useCase: MakeReservationUseCase())
    }
    
}

// MARK: - MakeReservationViewModelInputs

extension MakeReservationViewModel: MakeReservationViewModelInputs {
    
    var inputs: MakeReservationViewModelInputs { return self }
    
    func fetchReservation() {
        useCase.fetchReservation()
            .catchAndReturn([])
            .bind(to: _reservation)
            .disposed(by: disposeBag)
    }
    
    func updateDate(_ date: String) {
        var reservation = _reservation.value[0]
        reservation.date = date
        _reservation.accept([reservation])
    }
    
    func updateStartTime(_ startTime: String) {
        var reservation = _reservation.value[0]
        reservation.startTime = startTime
        _reservation.accept([reservation])
    }

    func updateEndTime(_ endTime: String) {
        var reservation = _reservation.value[0]
        reservation.endTime = endTime
        _reservation.accept([reservation])
    }

    func updateCenter(_ center: String) {
        var reservation = _reservation.value[0]
        reservation.center = center
        _reservation.accept([reservation])
    }

    func updateLocation(_ location: String) {
        var reservation = _reservation.value[0]
        reservation.location = location
        _reservation.accept([reservation])
    }

    func updateRequests(_ requests: String) {
        var reservation = _reservation.value[0]
        reservation.requests = requests
        _reservation.accept([reservation])
    }

    func updateType(_ type: ReservationType) {
        var reservation = _reservation.value[0]
        reservation.type = type
        _reservation.accept([reservation])
    }
    
    func makeReservation() -> Bool {
        let reservation = _reservation.value[0]
        print("reservation: \(reservation)")
        if reservation.location != "" && reservation.requests != "" {
            return true
        } else {
            return false
        }
    }
}

// MARK: - MakeReservationViewModelOutputs

extension MakeReservationViewModel: MakeReservationViewModelOutputs {
    var outputs: MakeReservationViewModelOutputs { return self }
    var reservation: Driver<[MakeReservationModel]> { _reservation.asDriver(onErrorJustReturn: [])}
}
