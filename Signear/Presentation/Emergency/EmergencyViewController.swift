//
//  EmergencyViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/26.
//

import UIKit
import RxCocoa
import RxSwift

class EmergencyViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var reservationButton: UIButton!
    @IBOutlet private weak var emergencyTranslationButton: UIButton!
    
    // MARK: - Properties - Private
    
    private let disposeBag = DisposeBag()
    private var viewModel: EmergencyViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel = EmergencyViewModel()
    }
}

// MARK: - Private

extension EmergencyViewController {
    
    private func configureUI() {
        reservationButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.createReservation()
            }).disposed(by: disposeBag)
        
        emergencyTranslationButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.viewModel?.inputs.requestEmergencyTranslation()
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.result
            .drive(onNext: { [weak self] result in
                if result {
                    self?.showReservations()
                } else {
                    // TODO : 에러 메세지 표기
                }
            }).disposed(by: disposeBag)
    }
    
    private func createReservation() {
        // TODO
    }
    
    private func showReservations() {
        // TODO
    }
}
