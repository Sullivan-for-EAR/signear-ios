//
//  ReservationHistoryInfoViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/07/11.
//

import UIKit
import RxCocoa
import RxSwift

class ReservationHistoryInfoViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var requestLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    // MARK: - Properties - Internal
    
    var history: ReservationHistoryModel!
    
    // MARK: - Properties - Private
    
    private let disposeBag = DisposeBag()
    private var viewModel: ReservationHistoryInfoViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel = ReservationHistoryInfoViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
}

// MARK: - Private

extension ReservationHistoryInfoViewController {
    private func configureUI() {
        closeButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: false)
            }).disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showDeleteAlertView()
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.deleteResult
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: false)
            }).disposed(by: disposeBag)
    }
    
    private func updateUI() {
        statusImageView.image = history.status.getImage()
        addressLabel.text = history.address
        areaLabel.text = history.area
        setDate(date: history.date)
        setTime(startTime: history.startTime, endTime: history.endTime)
        setMethod(method: history.method)
        requestLabel.text = history.request
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
        dateFormatter.dateFormat = "a h시 mm분"
        timeLabel.text = "\(dateFormatter.string(from: startDate)) ~ \(dateFormatter.string(from: endDate))"
    }
    
    private func setMethod(method: ReservationHistoryModel.MeetingType?) {
        switch method {
        case .sign:
            methodLabel.text = "수어통역(대면)"
        case .video:
            methodLabel.text = "화상통역(비대면)"
        default:
            break
        }
    }
    
    private func showDeleteAlertView() {
        let alert = UIAlertController(title: nil,
                                      message: "정말 삭제하시나요?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive, handler: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.viewModel?.inputs.deleteHistory(reservationId: self.history.rsID)
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
