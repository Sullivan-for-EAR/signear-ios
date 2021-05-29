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
    var delegate: MakeReservationTableViewCellDelegate?
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configureUI()
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
        self.dateButton.setTitle(reservation.date, for: .normal)

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.locationTextFieldInput(textField.text!)
    }
}

// MARK: - Private

extension MakeReservationTableViewCell {
    private func configureUI() {
        // TODO
        self.selectionStyle = .none
        
        self.locationTextfield.delegate = self
        
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
                self?.offlineButton.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 0.05)
                self?.offlineButton.layer.borderWidth = 2.0
                self?.offlineButton.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
                self?.onlineButton.layer.borderWidth = 1.0
                self?.onlineButton.layer.borderColor = #colorLiteral(red: 0.8700304627, green: 0.8700509667, blue: 0.8700398803, alpha: 1)
                self?.onlineButton.backgroundColor = .clear
                self?.delegate?.offlineBtnPressed(true)
            }).disposed(by: disposeBag)
        
        self.onlineButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.onlineButton.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 0.05)
                self?.onlineButton.layer.borderWidth = 2.0
                self?.onlineButton.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
                self?.offlineButton.backgroundColor = .clear
                self?.offlineButton.layer.borderWidth = 1.0
                self?.offlineButton.layer.borderColor = #colorLiteral(red: 0.8700304627, green: 0.8700509667, blue: 0.8700398803, alpha: 1)
                self?.delegate?.onlineBtnPressed(false)
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
