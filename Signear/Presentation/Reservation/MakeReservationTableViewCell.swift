//
//  MakeReservationTableViewCell.swift
//  signear
//
//  Created by 홍필화 on 2021/05/22.
//

import UIKit
import RxCocoa
import RxSwift

protocol MakeReservationTableViewCellDelegate: AnyObject {
    func pickerPressed(_ pickerType: String)
    func centerBtnPressed()
    func locationTextFieldInput(_ locationText: String)
    func offlineBtnPressed(_ isOfflineSelected: Bool)
    func onlineBtnPressed(_ isOnlineSelected: Bool)
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
    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
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

extension MakeReservationTableViewCell {
    func setReservation(_ reservation: MakeReservationModel) {
        dateButton.setTitle(reservation.date, for: .normal)
        startTimeButton.setTitle(reservation.startTime, for: .normal)
        endTimeButton.setTitle(reservation.endTime, for: .normal)
        centerButton.setTitle("\(reservation.area)  ", for: .normal)
        if reservation.meetingType == .sign {
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
        requestsTextView.delegate = self
        
        locationTextfield.delegate = self
        
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
        
//        locationTextfield.rx.controlEvent([.editingChanged])
//            .withLatestFrom(locationTextfield.rx.text.orEmpty)
//            //.debounce(.milliseconds(500), scheduler: MainScheduler.instance)
//            //.distinctUntilChanged()
//            .subscribe(onNext: { text in
//                self.delegate?.locationTextFieldInput(text)
//            }).disposed(by: disposeBag)
        
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
                self?.delegate?.onlineBtnPressed(true)
            }).disposed(by: disposeBag)
        
//        requestsTextView.rx.didChangeSelection
//            .withLatestFrom(requestsTextView.rx.text.orEmpty)
//            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
//            .distinctUntilChanged()
//            .subscribe(onNext: { text in
//                self.delegate?.requestsTextViewChanged(text)
//            }).disposed(by: disposeBag)
        
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

extension MakeReservationTableViewCell: UITextViewDelegate, UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let str = textField.text!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        if textField.text!.isEmpty || str.count == 0 {
            textField.placeholder = "수어통역이 필요한 장소를 입력해주세요"
        } else {
            self.delegate?.locationTextFieldInput(textField.text!)
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "수어통역 목적과 요청사항을 입력하세요" {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textViewHeightConstraint.constant = textView.contentSize.height
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let str = textView.text.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "\n", with: "")
        if textView.text.isEmpty || str.count == 0 {
            textView.text = "수어통역 목적과 요청사항을 입력하세요"
            textView.textColor = UIColor(rgb: 0xB6B6B6)
        } else {
            self.delegate?.requestsTextViewChanged(textView.text)
        }
    }
}
