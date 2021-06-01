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
    func pickerPressed(_ pickerType: String)
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

// MARK: - UITextFieldDelegate

extension MakeReservationTableViewCell {
    func setReservation(_ reservation: MakeReservationModel) {
        dateButton.setTitle(reservation.date, for: .normal)
        startTimeButton.setTitle(reservation.startTime, for: .normal)
        endTimeButton.setTitle(reservation.endTime, for: .normal)
        centerButton.setTitle("\(reservation.center)  ", for: .normal)
        if reservation.type == .offline {
            offlineButton.setButton(state: .selected)
            onlineButton.setButton(state: .normal)
        } else {
            offlineButton.setButton(state: .normal)
            onlineButton.setButton(state: .selected)
        }
    }
}

// MARK: - Private

extension MakeReservationTableViewCell {
    private func configureUI() {
        selectionStyle = .none
        
        requestsTextView.contentOffset = .zero
        requestsTextView.contentInset = UIEdgeInsets.zero
        requestsTextView.textContainerInset = UIEdgeInsets(top: 15.0, left: 25.0, bottom: 15.0, right: 25.0)
        requestsTextView.textContainer.lineFragmentPadding = 0
        
        dateButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.pickerPressed("date")
            }).disposed(by: disposeBag)
        
        startTimeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.pickerPressed("startTime")
            }).disposed(by: disposeBag)
        
        endTimeButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.pickerPressed("endTime")
            }).disposed(by: disposeBag)
        
        centerButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.delegate?.centerBtnPressed()
            }).disposed(by: disposeBag)
        
        locationTextfield.rx.controlEvent([.editingChanged])
            .withLatestFrom(locationTextfield.rx.text.orEmpty)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
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
        
        requestsTextView.rx.didChangeSelection
            .withLatestFrom(requestsTextView.rx.text.orEmpty)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
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
