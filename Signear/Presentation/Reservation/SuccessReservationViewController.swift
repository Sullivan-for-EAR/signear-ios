//
//  SuccessReservationViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/07/11.
//

import UIKit
import RxCocoa
import RxSwift

class SuccessReservationViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var showListButton: UIButton!
    
    // MARK: - Properties - Internal
    
    var model: MakeReservationModel!
    
    // MARK: - Properties - Private
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - Private

extension SuccessReservationViewController {
    private func configureUI() {
        configurecloseImageView()
        
        messageLabel.text = "00월 00일 월요일\n오전 00시부터 00시까지\n000000에서\n수어통역을 예약했어요"
            .replacingOccurrences(of: "00월 00일 월요일", with: "\(setDate(date: model.date))")
            .replacingOccurrences(of: "00시부터", with: "\(setTime(date: model.startTime))부터")
            .replacingOccurrences(of: "00시까지", with: "\(setTime(date: model.startTime))까지")
            .replacingOccurrences(of: "000000에서", with: "\(model.address))에서")
            .replacingOccurrences(of: "수어통역을", with: "\(model.meetingType.getString))을")
        
        showListButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: false) { [weak self] in
                    self?.showReservationListViewController()
                }

            }).disposed(by: disposeBag)
    }
    
    private func setDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM dd일 EEEE"
        return dateFormatter.string(from: convertDate)
    }
    
    private func setTime(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "HHmm"
        let convertDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "a H시 mm분"
        return dateFormatter.string(from: convertDate)
    }

    private func configurecloseImageView() {
        let backGenture = UITapGestureRecognizer(target: self, action: nil)
        backGenture.rx.event
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: false)
            }).disposed(by: disposeBag)
        closeImageView.addGestureRecognizer(backGenture)
    }
    
    private func showReservationListViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchRootViewToReservationListView()
    }
}
