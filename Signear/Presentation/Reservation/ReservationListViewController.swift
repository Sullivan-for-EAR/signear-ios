//
//  ReservationListViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/11.
//

import UIKit
import RxCocoa
import RxSwift

class ReservationListViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var reservationButton: UIButton!
    
    // MARK: Properties - Private
    
    private let disposeBag = DisposeBag()
    
    private var viewModel: ReservationListViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ReservationListViewModel()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.inputs.fetchReservations()
    }
}

// MARK: - Private

extension ReservationListViewController {
    
    private func configureUI() {
        tableView.register(UINib(nibName: "ReservationTableViewCell", bundle: nil), forCellReuseIdentifier: "ReservationTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
    
        tableView.rx.modelSelected(ReservationModel.self)
            .subscribe(onNext: { [weak self] reservation in
                self?.showReservation(reservation)
            }).disposed(by: disposeBag)
        
        reservationButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.makeReservation()
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.reservations
            .drive(tableView.rx.items(cellIdentifier: "ReservationTableViewCell", cellType: ReservationTableViewCell.self)) ({ index, reservation, cell in
                cell.setReservation(reservation)
            }).disposed(by: disposeBag)
    }
    
    private func showReservation(_ reservation: ReservationModel) {
        // TODO
    }
    
    private func makeReservation() {
        // TODO
    }
}
