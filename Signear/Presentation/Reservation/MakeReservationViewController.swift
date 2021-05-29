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
    @IBOutlet weak var doneButton: UIButton!
    
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
    
    var MakeReservationModelDict: [String: Any] = [:]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MakeReservationViewModel()
        self.configureUI()
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
        self.backgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6071275685)
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: UIScreen.main.bounds.height)
        
        self.dateTimePicker.locale = Locale(identifier: "ko_kr")
        
        centerPickerView.delegate = self
        centerPickerView.dataSource = self
        
        tableView.register(UINib(nibName: "MakeReservationTableViewCell", bundle: nil), forCellReuseIdentifier: "MakeReservationTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.rx.modelSelected(MakeReservationModel.self)
            .subscribe(onNext: { [weak self] reservation in
                // TODO
            }).disposed(by: disposeBag)
        
        self.doneButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.setPickerResult()
            }).disposed(by: disposeBag)
        
        self.backButton.rx.tap
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
    
    // MARK: uitest
    private func setPickerResult() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        
        if !dateTimePicker.isHidden {
            switch pickerType {
            case .date:
                let tempDate = self.dateTimePicker.date
                dateFormatter.dateFormat = "M월 dd일 EEEE"
                let dateStr = dateFormatter.string(from: tempDate)
                self.MakeReservationModelDict["date"] = dateStr
                break
            case .startTime:
                dateFormatter.dateFormat = "a hh:mm"
                let dateStr = dateFormatter.string(from: self.dateTimePicker.date)
                self.MakeReservationModelDict["startTime"] = dateStr
                break
            case .endTime:
                dateFormatter.dateFormat = "a hh:mm"
                let dateStr = dateFormatter.string(from: self.dateTimePicker.date)
                self.MakeReservationModelDict["endTime"] = dateStr
                break
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
        print("dict: \(self.MakeReservationModelDict)")
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        DispatchQueue.main.async {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
            let keyboardHeight: CGFloat
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                keyboardHeight = keyboardFrame.cgRectValue.height
            }
            
            self.view.frame = CGRect(x: 0, y: -keyboardHeight, width: UIScreen.main.bounds.width, height: self.view.frame.height)
            self.view.layoutIfNeeded()
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        DispatchQueue.main.async {
            guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
            let keyboardHeight: CGFloat
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                keyboardHeight = keyboardFrame.cgRectValue.height
            }
            
            self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.frame.height)
            self.view.layoutIfNeeded()
            
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
        self.MakeReservationModelDict["center"] = centerLists[row]
        print("selected center: \(centerLists[row])")
    }
    
}



extension MakeReservationViewController: MakeReservationTableViewCellDelegate {
    func dateBtnPressed() {
        self.pickerType = .date
        if #available(iOS 14.0, *) {
            self.view.addSubview(self.backgroundView)
            self.view.bringSubviewToFront(self.dateTimePicker)
            self.view.bringSubviewToFront(self.doneButton)
            self.dateTimePicker.preferredDatePickerStyle = .inline
            self.dateTimePicker.datePickerMode = .date
            self.dateTimePicker.isHidden = false
            self.dateTimePicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
    }
    
    func startTimeBtnPressed() {
        self.pickerType = .startTime
        if #available(iOS 14.0, *) {
            self.view.addSubview(self.backgroundView)
            self.view.bringSubviewToFront(self.dateTimePicker)
            self.view.bringSubviewToFront(self.doneButton)
            self.dateTimePicker.preferredDatePickerStyle = .wheels
            self.dateTimePicker.datePickerMode = .time
            self.dateTimePicker.isHidden = false
            self.dateTimePicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
    }
    
    func endTimeBtnPressed() {
        self.pickerType = .endTime
        if #available(iOS 14.0, *) {
            self.view.addSubview(self.backgroundView)
            self.view.bringSubviewToFront(self.dateTimePicker)
            self.view.bringSubviewToFront(self.doneButton)
            self.dateTimePicker.preferredDatePickerStyle = .wheels
            self.dateTimePicker.datePickerMode = .time
            self.dateTimePicker.isHidden = false
            self.dateTimePicker.backgroundColor = .white
        } else {
            // Fallback on earlier versions
        }
    }
    
    func centerBtnPressed() {
        // TODO
        self.view.addSubview(self.backgroundView)
        self.view.bringSubviewToFront(self.centerPickerView)
        self.view.bringSubviewToFront(self.doneButton)
        self.centerPickerView.isHidden = false
    }
    
    func locationTextFieldInput(_ locationText: String) {
        // TODO
        print("장소: \(locationText)")
        
    }
    
    func offlineBtnPressed(_ isOfflineSelected: Bool) {
        // TODO
        print("isOffline: \(isOfflineSelected)")
    }
    
    func onlineBtnPressed(_ isOfflineSelected: Bool) {
        // TODO
        print("isOffline: \(isOfflineSelected)")
    }
    
    func requestsTextViewChanged(_ requestText: String) {
        // TODO
        print("요청사항: \(requestText)")
    }
    
    func makeReservationBtnPressed() {
        // TODO
    }
    
    
}
