//
//  CreateReservationViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/06/28.
//

import UIKit
import RxCocoa
import RxSwift

class CreateReservationViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var startTimeTextField: UITextField!
    @IBOutlet private weak var endTimeTextField: UITextField!
    @IBOutlet private weak var areaTextField: UITextField!
    @IBOutlet private weak var addressTextField: UITextField!
    @IBOutlet private weak var signTranslationButton: UIButton!
    @IBOutlet private weak var onlineTranslationButton: UIButton!
    @IBOutlet private weak var purposeTextView: UITextView!
    @IBOutlet private weak var reservationButton: UIButton!
    
    // MARK: - Properties - Private
    
    private enum Constants {
        static let purposeTextViewPlaceholder = "수어통역 목적과 요청사항을 입력하세요"
    }
    
    private var viewModel: CreateReservationViewModelType? {
        didSet {
            bindUI()
        }
    }
    private let disposeBag = DisposeBag()
    private let datePicker = UIDatePicker()
    private let startTimePicker = UIDatePicker()
    private let endTimePicker = UIDatePicker()
    private let areaPickerView = UIPickerView()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel = CreateReservationViewModel()
        viewModel?.inputs.fetchArea()
    }
    
    // MARK: - Actions
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardFrame = view.convert(keyboardFrameValue.cgRectValue, from: nil)
        scrollView.contentInset.bottom = keyboardFrame.size.height
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = .zero
    }
    
    @objc private func didDatePickerDoneButtonPressed() {
        view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "MMM dd일 EEEE"
        dateTextField.text = dateFormatter.string(from: datePicker.date)
        viewModel?.inputs.setDate(date: datePicker.date)
    }
    
    @objc private func didStartTimePickerDoneButtonPressed() {
        view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "a H:mm"
        startTimeTextField.text = dateFormatter.string(from: startTimePicker.date)
        viewModel?.inputs.setStartTime(date: startTimePicker.date)
    }
    
    @objc private func didEndTimePickerDoneButtonPressed() {
        view.endEditing(true)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "a H:mm"
        endTimeTextField.text = dateFormatter.string(from: endTimePicker.date)
        viewModel?.inputs.setEndTime(date: endTimePicker.date)
    }
    
    @objc private func didAreaPickerViewDoneButtonPressed() {
        view.endEditing(true)
    }
    
    @objc private func didAddressTextFieldDoneButtonPressed() {
        view.endEditing(true)
    }
    
    @objc private func didPurposeTextViewDoneButtonPressed() {
        view.endEditing(true)
    }
    
    @objc private func didTappedBackButton(_ button: UINavigationItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private

extension CreateReservationViewController {
    
    private func configureUI() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = .init()
        navigationItem.leftBarButtonItem = .init(image: .init(named: "leftArrowIcon"), style: .plain, target: self, action: #selector(didTappedBackButton(_:)))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        configureDatePicker()
        configureStartTimePicker()
        configureEndTimePicker()
        configureAreaPickerView()
        configureAddressTextField()
        configurePurposeTextView()
        configureTranslationTypeButton()
        navigationItem.title = "예약하기"
        
        Observable.of(
            dateTextField.rx.text,
            startTimeTextField.rx.text,
            endTimeTextField.rx.text,
            areaTextField.rx.text,
            addressTextField.rx.text,
            purposeTextView.rx.text
        ).merge()
        .subscribe(onNext: { [weak self] _ in
            self?.updateUI()
        }).disposed(by: disposeBag)
        
        dateTextField.rx.text.asDriver()
            .drive(onNext: { [weak self] text in
                self?.updateUI()
            }).disposed(by: disposeBag)
    
        reservationButton.clipsToBounds = true
        reservationButton.layer.cornerRadius = 5
        reservationButton.setBackgroundColor(.init(rgb: 0x222222), for: .normal)
        reservationButton.setBackgroundColor(.init(rgb: 0xB6B6B6), for: .disabled)
        reservationButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.viewModel?.inputs.reservation()
            }).disposed(by: disposeBag)
    }
    
    private func configureDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButon = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didDatePickerDoneButtonPressed))
        toolbar.setItems([doneButon], animated: true)
        
        dateTextField.delegate = self
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier:"ko_KR")
        datePicker.datePickerMode = .date
    }
    
    private func configureStartTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButon = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didStartTimePickerDoneButtonPressed))
        toolbar.setItems([doneButon], animated: true)
        
        startTimeTextField.delegate = self
        startTimeTextField.inputView = startTimePicker
        startTimeTextField.inputAccessoryView = toolbar
        
        startTimePicker.minimumDate = Date()
        startTimePicker.locale = Locale(identifier:"ko_KR")
        startTimePicker.datePickerMode = .time
    }
    
    private func configureEndTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButon = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didEndTimePickerDoneButtonPressed))
        toolbar.setItems([doneButon], animated: true)
        
        endTimeTextField.delegate = self
        endTimeTextField.inputView = endTimePicker
        endTimeTextField.inputAccessoryView = toolbar
        
        endTimePicker.minimumDate = startTimePicker.date
        endTimePicker.locale = Locale(identifier:"ko_KR")
        endTimePicker.datePickerMode = .time
    }
    
    private func configureAddressTextField() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButon = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didAddressTextFieldDoneButtonPressed))
        toolbar.setItems([doneButon], animated: true)
 
        addressTextField.inputAccessoryView = toolbar
        addressTextField.delegate = self
        addressTextField.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] address in
                self?.viewModel?.inputs.setAddress(address: address)
            }).disposed(by: disposeBag)
    }
    
    private func configureAreaPickerView() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButon = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didAreaPickerViewDoneButtonPressed))
        toolbar.setItems([doneButon], animated: true)
        
        areaTextField.delegate = self
        areaTextField.inputView = areaPickerView
        areaTextField.inputAccessoryView = toolbar
        areaPickerView.rx.modelSelected(String.self)
            .asDriver()
            .drive(onNext: { [weak self] area in
                guard let self = self else {
                    return
                }
                self.areaTextField.text = area[0]
                self.viewModel?.inputs.setArea(area: area[0])
            }).disposed(by: disposeBag)
    }
    
    private func configurePurposeTextView() {
        showTextViewPlaceholder()
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButon = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(didPurposeTextViewDoneButtonPressed))
        toolbar.setItems([doneButon], animated: true)
        
        purposeTextView.layer.cornerRadius = 5
        purposeTextView.layer.borderWidth = 1
        purposeTextView.layer.borderColor = UIColor.init(rgb: 0xD6D6D6).cgColor
        purposeTextView.delegate = self
        purposeTextView.inputAccessoryView = toolbar
        purposeTextView.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] request in
                self?.viewModel?.inputs.setRequest(request: request)
            }).disposed(by: disposeBag)
    }
    
    private func configureTranslationTypeButton() {
        signTranslationButton.isSelected = true
        signTranslationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.viewModel?.inputs.setMeetingType(type: .sign)
                self.signTranslationButton.isSelected = true
                self.onlineTranslationButton.isSelected = false
                self.updateButtonStatus()
            }).disposed(by: disposeBag)
        
        onlineTranslationButton.isSelected = false
        onlineTranslationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.viewModel?.inputs.setMeetingType(type: .video)
                self.signTranslationButton.isSelected = false
                self.onlineTranslationButton.isSelected = true
                self.updateButtonStatus()
            }).disposed(by: disposeBag)
        updateButtonStatus()
    }
    
    private func updateButtonStatus() {
        [signTranslationButton, onlineTranslationButton]
            .map { $0 as UIButton }.forEach {
            if $0.isSelected {
                $0.layer.borderColor = UIColor(rgb: 0x0A84FF).cgColor
                $0.layer.backgroundColor = UIColor(rgb: 0x0A84FF, alpha: 0.05).cgColor
                $0.layer.borderWidth = 2
            } else {
                $0.layer.borderColor = UIColor(rgb: 0xD6D6D6).cgColor
                $0.layer.backgroundColor = UIColor.white.cgColor
                $0.layer.borderWidth = 1
            }
        }
    }
    
    private func showTextViewPlaceholder() {
        purposeTextView.text = Constants.purposeTextViewPlaceholder
        purposeTextView.textColor = .init(rgb: 0xB6B6B6)
    }
    
    private func bindUI() {
        viewModel?.outputs.area
            .drive(areaPickerView.rx.itemTitles) ({ index, area in
                return area
            }).disposed(by: disposeBag)
        
        viewModel?.outputs.reservationResult
            .filter { $0 != nil }
            .map { $0! }
            .drive(onNext: { [weak self] model in
                self?.showSuccessView(model: model)
            }).disposed(by: disposeBag)
    }
    
    private func showSuccessView(model: MakeReservationModel) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SuccessReservationViewController") as? SuccessReservationViewController else { return }
        vc.model = model
        vc.view.backgroundColor = .init(rgb: 000000, alpha: 0.5)
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    private func updateUI() {
        if dateTextField.text?.isEmpty == true ||
            startTimeTextField.text?.isEmpty == true ||
            endTimeTextField.text?.isEmpty == true ||
            areaTextField.text?.isEmpty == true ||
            addressTextField.text?.isEmpty == true ||
            purposeTextView.text.isEmpty ||
            purposeTextView.text == Constants.purposeTextViewPlaceholder {
            reservationButton.isEnabled = false
        } else {
            reservationButton.isEnabled = true
        }
    }
}

// MARK: - UITextFieldDelegate

extension CreateReservationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == areaTextField && areaTextField.text?.isEmpty == true {
            areaTextField.text = "강남구"
        }
        
        let point = CGPoint(x: .zero, y: textField.frame.origin.y - 10)
        scrollView.setContentOffset(point, animated: true)
    }
}

// MARK: - UITextViewDelegate

extension CreateReservationViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == Constants.purposeTextViewPlaceholder &&
            textView.textColor == .init(rgb: 0xB6B6B6) {
            textView.text = nil
            textView.textColor = .black
        }
        let point = CGPoint(x: .zero, y: textView.frame.origin.y - 10)
        scrollView.setContentOffset(point, animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == nil {
            showTextViewPlaceholder()
        }
    }
}
