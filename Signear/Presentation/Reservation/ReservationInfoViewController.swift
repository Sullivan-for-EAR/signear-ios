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
    
    @IBOutlet private weak var processImageView: UIImageView!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var areaLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var methodLabel: UILabel!
    @IBOutlet private weak var requestLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - Properties - Internal
    
    var reservationId: Int?
    
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
        fetchReservationInfo()
    }
}

// MARK: - Private

extension ReservationInfoViewController {
    private func configuareUI() {
        title = "예약 확인"
        cancelButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.showCancelAlertView()
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.reservationInfo
            .filter { $0 != nil }
            .map { $0! }
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
            self.addressLabel.text = reservationInfo.address
            self.areaLabel.text = reservationInfo.area
            self.setDate(date: reservationInfo.date)
            self.setTime(startTime: reservationInfo.startTime, endTime: reservationInfo.endTime)
            self.setMethod(method: reservationInfo.method)
            self.requestLabel.text = reservationInfo.request
            self.setStatusImageView(status: reservationInfo.status)
        }
    }
    
    private func setDate(date: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM dd일 EEEE"
        dateLabel.text = dateFormatter.string(from: convertDate)
    }
    
    private func setTime(startTime: String?, endTime: String?) {
        guard let startTime = startTime,
              let endTime = endTime else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "HHmm"
        let startDate = dateFormatter.date(from: startTime) ?? Date()
        let endDate = dateFormatter.date(from: endTime) ?? Date()
        dateFormatter.dateFormat = "a H시 mm분"
        timeLabel.text = "\(dateFormatter.string(from: startDate)) ~ \(dateFormatter.string(from: endDate))"
    }
    
    private func setMethod(method: ReservationInfoModel.MeetingType) {
        switch method {
        case .sign:
            methodLabel.text = "수어통역(대면)"
        case .video:
            methodLabel.text = "화상통역(비대면)"
        default:
            break
        }
    }
    
    private func setStatusImageView(status: ReservationInfoModel.Status) {
        switch status {
        case .unread:
            processImageView.image = .init(named: "unReadProcessIcon")
        case .check:
            processImageView.image = .init(named: "waitingProcessIcon")
        case .confirm:
            processImageView.image = .init(named: "confirmProcessIcon")
        case .reject:
            processImageView.image = .init(named: "rejectProcessIcon")
            cancelButton.isHidden = true
        case .cancel:
            processImageView.image = .init(named: "cancelProcessIcon")
            cancelButton.isHidden = true
        default:
            processImageView.image = .init(named: "unReadProcessIcon")
        }
    }
    
    private func showCancelAlertView() {
        let alert = UIAlertController(title: "예약 취소",
                                      message: "수어통역 예약을 정말 취소하시나요?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "예약 취소", style: .destructive, handler: { [weak self] _ in
            guard let self = self,
                  let reservationId = self.reservationId else { return }
            self.viewModel?.inputs.cancelReservation(reservationId: reservationId)
        }))
        alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func fetchReservationInfo() {
        guard let reservationId = reservationId else { return }
        viewModel?.inputs.fetchReservationInfo(reservationId: reservationId)
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
