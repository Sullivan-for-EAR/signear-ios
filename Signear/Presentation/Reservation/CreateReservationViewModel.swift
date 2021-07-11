//
//  CreateReservationViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/06/28.
//

import Foundation
import RxCocoa
import RxSwift

protocol CreateReservationViewModelInputs {
    func fetchArea()
    func setDate(date: Date)
    func setStartTime(date: Date)
    func setEndTime(date: Date)
    func setArea(area: String)
    func setAddress(address: String)
    func setMeetingType(type: MakeReservationModel.MeetingType)
    func setRequest(request: String)
    func reservation()
}

protocol CreateReservationViewModelOutputs {
    var area: Driver<[String]> { get }
    var reservationResult: Driver<MakeReservationModel?> { get }
}

protocol CreateReservationViewModelType {
    var inputs: CreateReservationViewModelInputs { get }
    var outputs: CreateReservationViewModelOutputs { get }
}

class CreateReservationViewModel: CreateReservationViewModelType {
    
    // MARK: - Properties - Private
    
    private let disposeBag = DisposeBag()
    private var _area: PublishRelay<[String]> = .init()
    private var _reservationResult: PublishRelay<MakeReservationModel?> = .init()
    private var selectedDate: String?
    private var selectedStartTime: String?
    private var selectedEndTime: String?
    private var selectedArea: String?
    private var selectedAddress: String?
    private var selectedmeetingType: MakeReservationModel.MeetingType? = .sign
    private var selectedRequest: String?
    
    private let fetchAreaUseCase = FetchAreaUseCase()
    private let createReservationUseCase = CreateReservationUseCase()
}

extension CreateReservationViewModel: CreateReservationViewModelInputs {
    
    var inputs: CreateReservationViewModelInputs { return self }
    
    func fetchArea() {
        fetchAreaUseCase.fetchArea()
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let area):
                    self?._area.accept(area)
                case .failure(_):
                    break
                }
            }).disposed(by: disposeBag)
    }
    
    func setDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        selectedDate = dateFormatter.string(from: date)
    }
    
    func setStartTime(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        selectedStartTime = dateFormatter.string(from: date)
    }
    
    func setEndTime(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HHmm"
        selectedEndTime = dateFormatter.string(from: date)
    }
    
    func setArea(area: String) {
        selectedArea = area
    }
    
    func setAddress(address: String) {
        selectedAddress = address
    }
    
    func setMeetingType(type: MakeReservationModel.MeetingType) {
        selectedmeetingType = type
    }
    
    func setRequest(request: String) {
        selectedRequest = request
    }
    
    func reservation() {
        guard let date = selectedDate,
              let startTime = selectedStartTime,
              let endTime = selectedEndTime,
              let area = selectedArea,
              let address = selectedAddress,
              let meetingType = selectedmeetingType,
              let request = selectedRequest else {
            return
        }
        let reservation = MakeReservationModel(
            date: date,
            startTime: startTime,
            endTime: endTime,
            area: area,
            address: address,
            meetingType: meetingType,
            request: request
        )
        createReservationUseCase.createReservationUseCase(reservation: reservation)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let result):
                    self?._reservationResult.accept(result)
                case .failure(_):
                    // TODO : error 처리
                    break
                }
            }).disposed(by: disposeBag)
    }
}

extension CreateReservationViewModel: CreateReservationViewModelOutputs {
    var outputs: CreateReservationViewModelOutputs { return self }
    var area: Driver<[String]> { _area.asDriver(onErrorJustReturn: []) }
    var reservationResult: Driver<MakeReservationModel?> { _reservationResult.asDriver(onErrorJustReturn: nil) }
}
