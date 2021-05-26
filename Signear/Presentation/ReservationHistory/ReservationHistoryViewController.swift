//
//  ReservationHistoryViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/26.
//

import UIKit
import RxCocoa
import RxSwift

class ReservationHistoryViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties - Private
    
    private let disposeBag = DisposeBag()
    private var viewModel: ReservationHistoryViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel = ReservationHistoryViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.inputs.fetchReservationHistory()
    }
}

// MARK: - Private

extension ReservationHistoryViewController {
    
    private func configureUI() {
        tableView.register(.init(nibName: "ReservationHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ReservationHistoryTableViewCell")
        
        tableView.rx.modelSelected(ReservationHistoryModel.self)
            .subscribe(onNext: { [weak self] history in
                self?.showHistory(history)
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.reservationHistory
            .drive(tableView.rx.items(cellIdentifier: "ReservationHistoryTableViewCell", cellType: ReservationHistoryTableViewCell.self)) ({ index, history, cell in
                cell.setReservationHistory(history)
            }).disposed(by: disposeBag)
    }
    
    private func showHistory(_ history: ReservationHistoryModel) {
        // TODO
    }
}
