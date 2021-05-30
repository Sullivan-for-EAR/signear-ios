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
    func offlineBtnPressed(_ isOfflineSelected: Bool)
    func onlineBtnPressed(_ isOfflineSelected: Bool)
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
    weak var delegate: MakeReservationTableViewCellDelegate?
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}

// MARK: - Internal

extension MakeReservationTableViewCell: UITextFieldDelegate {
    func setReservation(_ reservation: MakeReservationModel) {
        // Example
        dateButton.setTitle(reservation.date, for: .normal)

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.locationTextFieldInput(textField.text!)
    }
}

// MARK: - Private

extension MakeReservationTableViewCell {
    private func configureUI() {
        // TODO
        selectionStyle = .none
        
        locationTextfield.delegate = self
        
        dateButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.dateBtnPressed()
            }).disposed(by: disposeBag)
        
        startTimeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.startTimeBtnPressed()
            }).disposed(by: disposeBag)
        
        endTimeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.endTimeBtnPressed()
            }).disposed(by: disposeBag)
        
        centerButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.centerBtnPressed()
            }).disposed(by: disposeBag)
        
        locationTextfield.rx.controlEvent([.editingDidEnd])
            .withLatestFrom(locationTextfield.rx.text.orEmpty)
            .subscribe(onNext: { text in
                self.delegate?.locationTextFieldInput(text)
            }).disposed(by: disposeBag)
        
        offlineButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.offlineButton.setButton(state: .selected)
                self?.onlineButton.setButton(state: .normal)
                self?.delegate?.offlineBtnPressed(true)
            }).disposed(by: disposeBag)
        
        onlineButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.offlineButton.setButton(state: .normal)
                self?.onlineButton.setButton(state: .selected)
                self?.delegate?.onlineBtnPressed(false)
            }).disposed(by: disposeBag)
        
        requestsTextView.rx.didEndEditing
            .withLatestFrom(requestsTextView.rx.text.orEmpty)
            .subscribe(onNext: { text in
                self.delegate?.requestsTextViewChanged(text)
            }).disposed(by: disposeBag)
        
        makeReservationButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.makeReservationBtnPressed()
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        // TODO
    }
}
