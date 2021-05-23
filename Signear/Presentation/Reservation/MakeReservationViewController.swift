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
    
    // MARK: Properties - Private
    private var pickerType: PickerType?
    
    private var disposeBag = DisposeBag()
    
    private var viewModel: MakeReservationViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MakeReservationViewModel()
        self.configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.inputs.fetchReservation()
    }
    
}

// MARK: - Private
extension MakeReservationViewController {
    private func configureUI() {
        tableView.register(UINib(nibName: "MakeReservationTableViewCell", bundle: nil), forCellReuseIdentifier: "MakeReservationTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.rx.modelSelected(MakeReservationModel.self)
            .subscribe(onNext: { [weak self] reservation in
                // TODO
            }).disposed(by: disposeBag)
        
        self.backButton.rx.tap
            .asDriver()
            .drive(onNext: {
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.reservation
            .drive(tableView.rx.items(cellIdentifier: "MakeReservationTableViewCell", cellType: MakeReservationTableViewCell.self)) ( { index, reservation, cell in
                cell.setReservation(reservation)
            }).disposed(by: disposeBag)
    }
    
    
}

extension MakeReservationViewController: MakeReservationTableViewCellDelegate {
    func dateBtnPressed() {
        // TODO
        self.pickerType = .date
        if #available(iOS 14.0, *) {
            self.dateTimePicker.preferredDatePickerStyle = .inline
            self.dateTimePicker.datePickerMode = .date
            self.dateTimePicker.isHidden = false
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func startTimeBtnPressed() {
        // TODO
    }
    
    func endTimeBtnPressed() {
        // TODO
    }
    
    func centerBtnPressed() {
        // TODO
    }
    
    func locationTextFieldInput(_ locationText: String) {
        // TODO
    }
    
    func offlineBtnPressed() {
        // TODO
    }
    
    func onlineBtnPressed() {
        // TODO
    }
    
    func requestsTextViewChanged(_ requestText: String) {
        // TODO
    }
    
    func makeReservationBtnPressed() {
        // TODO
    }
    
    
}
