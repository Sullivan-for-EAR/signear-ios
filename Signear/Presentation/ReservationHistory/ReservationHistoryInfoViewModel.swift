//
//  ReservationHistoryInfoViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/07/11.
//

import Foundation
import RxCocoa
import RxSwift

protocol ReservationHistoryInfoViewModelInputs {
    func deleteHistory(reservationId: Int)
}

protocol ReservationHistoryInfoViewModelOutputs {
    var deleteResult: Driver<Bool> { get }
}

protocol ReservationHistoryInfoViewModelType {
    var inputs: ReservationHistoryInfoViewModelInputs { get }
    var outputs: ReservationHistoryInfoViewModelOutputs { get }
}

class ReservationHistoryInfoViewModel: ReservationHistoryInfoViewModelType {
    
    // MARK: - Properties - Private
    
    private let disposeBag = DisposeBag()
    private let deleteReservationHistoryUseCase: DeleteReservationHistoryUseCaseType
    private var _deleteResult: PublishRelay<Bool> = .init()
    
    // MARK: - Life cycle
    
    init(deleteReservationHistoryUseCase: DeleteReservationHistoryUseCaseType) {
        self.deleteReservationHistoryUseCase = deleteReservationHistoryUseCase
    }
    
    convenience init() {
        self.init(deleteReservationHistoryUseCase: DeleteReservationHistoryUseCase())
    }
}

extension ReservationHistoryInfoViewModel: ReservationHistoryInfoViewModelInputs {
    var inputs: ReservationHistoryInfoViewModelInputs { return self }
    
    func deleteHistory(reservationId: Int) {
        deleteReservationHistoryUseCase.delete(reservationId: reservationId)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(_):
                    self?._deleteResult.accept(true)
                    break
                case .failure(_):
                    break
                }
            }).disposed(by: disposeBag)
    }
}

extension ReservationHistoryInfoViewModel: ReservationHistoryInfoViewModelOutputs {
    var outputs: ReservationHistoryInfoViewModelOutputs { return self }
    var deleteResult: Driver<Bool> { _deleteResult.asDriver(onErrorJustReturn: false) }
}
