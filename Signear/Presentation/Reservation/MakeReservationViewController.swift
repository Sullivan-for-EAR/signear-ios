//
//  MakeReservationViewController.swift
//  signear
//
//  Created by 홍필화 on 2021/05/22.
//

import UIKit
import RxSwift
import RxCocoa

class MakeReservationViewController: UIViewController {
    
    enum PickerType {
        case date
        case startTime
        case endTime
    }
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dateTimePicker: UIDatePicker!
    @IBOutlet private weak var centerPickerView: UIPickerView!
    @IBOutlet private weak var doneButton: UIButton!
    
    // MARK: Properties - Private
    
    private var backgroundView = UIView()
    private var pickerType: PickerType?
    private var disposeBag = DisposeBag()
    private var viewModel: MakeReservationViewModelType? {
        didSet {
            bindUI()
        }
    }
    private var centerLists: [String] = ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"]
        
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MakeReservationViewModel()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.inputs.fetchReservation()
        
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
    }
    
}

// MARK: - Private
extension MakeReservationViewController {
    private func configureUI() {
        navigationItem.title = "예약하기"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "leftArrowIcon"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(pressedClose))
        
        backgroundView.backgroundColor = UIColor(rgb: 0x000000, alpha: 0.61)
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIScreen.main.bounds.height)
        
        dateTimePicker.locale = Locale(identifier: "ko_kr")
        
        centerPickerView.delegate = self
        centerPickerView.dataSource = self
        
        tableView.register(UINib(nibName: "MakeReservationTableViewCell", bundle: nil), forCellReuseIdentifier: "MakeReservationTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.rx.modelSelected(MakeReservationModel.self)
            .subscribe(onNext: { [weak self] reservation in
                // TODO
            }).disposed(by: disposeBag)
        
        doneButton.rx.tap
            .asDriver()
            .drive(onNext: { [self] in
                self.setPickerResult()
            }).disposed(by: disposeBag)
        
        backButton.rx.tap
            .asDriver()
            .drive(onNext: {
                //self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.reservation
            .drive(tableView.rx.items(cellIdentifier: "MakeReservationTableViewCell", cellType: MakeReservationTableViewCell.self)) ( { index, reservation, cell in
                cell.delegate = self
                cell.setReservation(reservation)
                
            }).disposed(by: disposeBag)
    }
    
    private func showPicker(type: PickerType) {
        pickerType = type
        if #available(iOS 14.0, *) {
            switch type {
            case .date:
                dateTimePicker.preferredDatePickerStyle = .inline
                dateTimePicker.datePickerMode = .date
            case .startTime:
                dateTimePicker.preferredDatePickerStyle = .wheels
                dateTimePicker.datePickerMode = .time
            case .endTime:
                dateTimePicker.preferredDatePickerStyle = .wheels
                dateTimePicker.datePickerMode = .time
            }
            view.addSubview(backgroundView)
            view.bringSubviewToFront(dateTimePicker)
            view.bringSubviewToFront(doneButton)
            dateTimePicker.isHidden = false
            dateTimePicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    // MARK: uitest
    private func setPickerResult() {
        if !dateTimePicker.isHidden {
            switch pickerType {
            case .date:
                let dateStr = DateFormatter.getDateString(date: self.dateTimePicker.date)
                viewModel?.inputs.updateDate(dateStr)
            case .startTime:
                let startTimeStr = DateFormatter.getTimeString(date: self.dateTimePicker.date)
                viewModel?.inputs.updateStartTime(startTimeStr)
            case .endTime:
                let endTimeStr = DateFormatter.getTimeString(date: self.dateTimePicker.date)
                viewModel?.inputs.updateEndTime(endTimeStr)
            default:
                break
            }
            self.dateTimePicker.isHidden = true
            self.backgroundView.removeFromSuperview()
        } else if !centerPickerView.isHidden {
            self.centerPickerView.isHidden = true
            self.backgroundView.removeFromSuperview()
        }
        print("selected date: \(self.dateTimePicker.date)")
    }
    
    @objc func pressedClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
            let keyboardHeight: CGFloat
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardFrame.cgRectValue.height - self!.view.safeAreaInsets.bottom
            } else {
                keyboardHeight = keyboardFrame.cgRectValue.height
            }
            
            self!.view.frame = CGRect(x: 0, y: -keyboardHeight, width: UIScreen.main.bounds.width, height: self!.view.frame.height)
            self!.view.layoutIfNeeded()
            let indexPath = IndexPath(row: 0, section: 0)
            self!.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async { [weak self] in
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
            self!.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self!.view.frame.height)
            self!.view.layoutIfNeeded()
        }
        
    }
}

extension MakeReservationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return centerLists.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return centerLists[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel?.inputs.updateCenter(centerLists[row])
    }
    
}



extension MakeReservationViewController: MakeReservationTableViewCellDelegate {
    func pickerPressed(_ pickerType: String) {
        switch pickerType {
        case "date":
            showPicker(type: .date)
        case "startTime":
            showPicker(type: .startTime)
        case "endTime":
            showPicker(type: .endTime)
        default:
            break
        }
    }
    
    func centerBtnPressed() {
        self.view.addSubview(self.backgroundView)
        self.view.bringSubviewToFront(self.centerPickerView)
        self.view.bringSubviewToFront(self.doneButton)
        self.centerPickerView.isHidden = false
    }
    
    func locationTextFieldInput(_ locationText: String) {
        // TODO
        print("장소: \(locationText)")
        viewModel?.inputs.updateLocation(locationText)
    }
    
    func offlineBtnPressed(_ isOfflineSelected: Bool) {
        // TODO
        print("isOffline: \(isOfflineSelected)")
        viewModel?.inputs.updateType(.offline)
    }
    
    func onlineBtnPressed(_ isOfflineSelected: Bool) {
        // TODO
        print("isOffline: \(isOfflineSelected)")
        viewModel?.inputs.updateType(.online)
    }
    
    func requestsTextViewChanged(_ requestText: String) {
        // TODO
        print("요청사항: \(requestText)")
        viewModel?.inputs.updateRequests(requestText)
    }
    
    func makeReservationBtnPressed() {
        // TODO
    }
    
    
}
