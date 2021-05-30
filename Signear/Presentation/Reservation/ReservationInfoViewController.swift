//
//  ReservationInfoViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/30.
//

import UIKit
import RxCocoa
import RxSwift

class ReservationInfoViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var LocationLabel: UILabel!
    @IBOutlet private weak var centerLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - Properties - Private
    
    private let disposeBag = DisposeBag()
    private var viewModel: ReservationInfoViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Properties - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuareUI()
        viewModel = ReservationInfoViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.inputs.fetchReservationInfo()
    }
}

// MARK: - Private

extension ReservationInfoViewController {
    private func configuareUI() {
        cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.showCancelAlertView()
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.reservationInfo
            .drive(onNext: { [weak self] reservationInfo in
                self?.setReservationInfo(reservationInfo)
            }).disposed(by: disposeBag)
        
        viewModel?.outputs.cancelResult
            .drive(onNext: { [weak self] isSucceed in
                if isSucceed {
                    self?.navigationController?.popViewController(animated: true)
                }
            }).disposed(by: disposeBag)
    }
    
    private func setReservationInfo(_ reservationInfo: ReservationInfoModel) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.LocationLabel.text = reservationInfo.location
            self.centerLabel.text = reservationInfo.center
            self.dateLabel.text = reservationInfo.date
            self.timeLabel.text = reservationInfo.time
            self.typeLabel.text = reservationInfo.type
            self.descriptionLabel.text = reservationInfo.description
        }
    }
    
    private func showCancelAlertView() {
        let alert = UIAlertController(title: "예약 취소",
                                      message: "수어통역 예약을 정말 취소하시나요?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예약 취소", style: .destructive, handler: { [weak self] _ in
            self?.viewModel?.inputs.cancelReservation()
        }))
        alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showRejectAlertView() {
        let alert = UIAlertController(title: "거절 사유",
                                      message: "해당 날짜는 수어통역 예약이 꽉 찼습니다.\n다른 날짜에 예약 바랍니다.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
