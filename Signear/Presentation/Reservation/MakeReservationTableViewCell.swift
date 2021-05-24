//
//  MakeReservationTableViewCell.swift
//  signear
//
//  Created by 홍필화 on 2021/05/22.
//

import UIKit
import RxCocoa
import RxSwift

protocol MakeReservationTableViewCellDelegate: class {
    func dateBtnPressed()
    func startTimeBtnPressed()
    func endTimeBtnPressed()
    func centerBtnPressed()
    func locationTextFieldInput(_ locationText: String)
    func offlineBtnPressed()
    func onlineBtnPressed()
    func requestsTextViewChanged(_ requestText: String)
    func makeReservationBtnPressed()
}

class MakeReservationTableViewCell: UITableViewCell {
    
    // MARK: - Properties - UI
    @IBOutlet private weak var dateButton: UIButton!
    @IBOutlet private weak var startTimeButton: UIButton!
    @IBOutlet private weak var endTimeButton: UIButton!
    @IBOutlet private weak var centerButton: UIButton!
    
    @IBOutlet private weak var locationTextfield: UITextField!
    
    @IBOutlet private weak var offlineButton: UIButton!
    @IBOutlet private weak var signLanguageLabel: UILabel!
    @IBOutlet private weak var offlineLabel: UILabel!
    
    @IBOutlet private weak var onlineButton: UIButton!
    @IBOutlet private weak var visionTranslationLabel: UILabel!
    @IBOutlet private weak var onlineLabel: UILabel!
    
    @IBOutlet private weak var requestsTextView: UITextView!
    
    @IBOutlet private weak var makeReservationButton: UIButton!
    
    // MARK: Properties - Private
    private var delegate: MakeReservationTableViewCellDelegate?
    private let disposeBag = DisposeBag()
    
    
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
}

// MARK: - Internal

extension MakeReservationTableViewCell {
    func setReservation(_ reservation: MakeReservationModel) {
        // Example
        self.dateButton.setTitle(reservation.date, for: .normal)
    }
}

// MARK: - Private

extension MakeReservationTableViewCell {
    private func configureUI() {
        // TODO
        self.selectionStyle = .none
        
        self.dateButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.dateBtnPressed()
            }).disposed(by: disposeBag)
        
        self.startTimeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.startTimeBtnPressed()
            }).disposed(by: disposeBag)
        
        self.endTimeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.endTimeBtnPressed()
            }).disposed(by: disposeBag)
        
        self.centerButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.centerBtnPressed()
            }).disposed(by: disposeBag)
        
        self.locationTextfield.rx.controlEvent([.editingDidEnd])
            .withLatestFrom(locationTextfield.rx.text.orEmpty)
            .subscribe(onNext: { text in
                self.delegate?.locationTextFieldInput(text)
            }).disposed(by: disposeBag)
        
        
        self.offlineButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.offlineBtnPressed()
            }).disposed(by: disposeBag)
        
        self.onlineButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.onlineBtnPressed()
            }).disposed(by: disposeBag)
        
        self.requestsTextView.rx.didEndEditing
            .withLatestFrom(requestsTextView.rx.text.orEmpty)
            .subscribe(onNext: { text in
                self.delegate?.requestsTextViewChanged(text)
            }).disposed(by: disposeBag)
        
        self.makeReservationButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.makeReservationBtnPressed()
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        // TODO
    }
}
