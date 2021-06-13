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
    func updateDate(_ date: String)
    func updateStartTime(_ startTime: String)
    func updateEndTime(_ endTime: String)
    func updateArea(_ area: String)
    func updateLocation(_ location: String)
    func updateRequests(_ requests: String)
    func updateType(_ type: MakeReservationModel.MeetingType)
    func makeReservation()
}

protocol MakeReservationViewModelOutputs {
    var reservation: Driver<[MakeReservationModel]> { get }
    var createReservationResult: Driver<Bool> { get }
}

protocol MakeReservationViewModelType {
    var inputs: MakeReservationViewModelInputs { get }
    var outputs: MakeReservationViewModelOutputs { get }
}

class MakeReservationViewModel: MakeReservationViewModelType {
    
    // MARK: Properties - Private
    
    private let disposeBag = DisposeBag()
    private let useCase: CreateReservationUseCaseType
    private var _reservation: BehaviorRelay<[MakeReservationModel]> = .init(value: [])
    private var _createReservationResult: PublishRelay<Bool> = .init()
    
    // MARK: - Constructor
    
    init(useCase: CreateReservationUseCaseType) {
        self.useCase = useCase
    }
    
    convenience init() {
        self.init(useCase: CreateReservationUseCase())
    }
}

// MARK: - MakeReservationViewModelInputs

extension MakeReservationViewModel: MakeReservationViewModelInputs {
    
    var inputs: MakeReservationViewModelInputs { return self }
    
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

    func updateArea(_ area: String) {
        var reservation = _reservation.value[0]
        reservation.area = area
        _reservation.accept([reservation])
    }

    func updateLocation(_ address: String) {
        var reservation = _reservation.value[0]
        reservation.address = address
        _reservation.accept([reservation])
    }

    func updateRequests(_ requests: String) {
        var reservation = _reservation.value[0]
        reservation.request = requests
        _reservation.accept([reservation])
    }

    func updateType(_ meetingType: MakeReservationModel.MeetingType) {
        var reservation = _reservation.value[0]
        reservation.meetingType = meetingType
        _reservation.accept([reservation])
    }
    
    func makeReservation() {
        let reservation = _reservation.value[0]
        useCase.createReservationUseCase(reservation: reservation)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?._createReservationResult.accept(true)
                case .failure:
                    // TODO : API Error
                    break
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - MakeReservationViewModelOutputs

extension MakeReservationViewModel: MakeReservationViewModelOutputs {
    
    var outputs: MakeReservationViewModelOutputs { return self }
    var reservation: Driver<[MakeReservationModel]> { _reservation.asDriver(onErrorJustReturn: [])}
    var createReservationResult: Driver<Bool> { _createReservationResult.asDriver(onErrorJustReturn: false) }
}
