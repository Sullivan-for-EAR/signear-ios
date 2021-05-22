//
//  ReservationListViewModel.swift
//  signear
//
//  Created by 신정섭 on 2021/05/11.
//

import Foundation

protocol ReservationListViewModelInputs {
}

protocol ReservationListViewModelOutputs {
}

protocol ReservationListViewModelType {
    var inputs: ReservationListViewModelInputs { get }
    var outputs: ReservationListViewModelOutputs { get }
}

class ReservationListViewModel: ReservationListViewModelType {
    
}

// MARK: - ReservationListViewModelInputs

extension ReservationListViewModel: ReservationListViewModelInputs {
    var inputs: ReservationListViewModelInputs { return self }
}

// MARK: - ReservationListViewModelOutputs

extension ReservationListViewModel: ReservationListViewModelOutputs {
    var outputs: ReservationListViewModelOutputs { return self }
}
