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
    private var _reservation: PublishRelay<[MakeReservationModel]> = .init()
    
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
}

// MARK: - MakeReservationViewModelOutputs

extension MakeReservationViewModel: MakeReservationViewModelOutputs {
    var outputs: MakeReservationViewModelOutputs { return self }
    var reservation: Driver<[MakeReservationModel]> { _reservation.asDriver(onErrorJustReturn: [])}
}
