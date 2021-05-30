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
    private let tableViewBackgroundView =  Bundle.main.loadNibNamed("ReservationBackgroundView", owner: nil, options: nil)?.first as! UIView
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
        let profileNavigationItem = UIBarButtonItem(image: .init(named: "profileIcon"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = profileNavigationItem
        profileNavigationItem.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.showMyPage()
            }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        tableView.register(UINib(nibName: "ReservationTableViewCell", bundle: nil), forCellReuseIdentifier: "ReservationTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
    
        tableView.rx.modelSelected(ReservationModel.self)
            .subscribe(onNext: { [weak self] reservation in
                self?.showReservation(reservation)
            }).disposed(by: disposeBag)
        
        reservationButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.makeReservation()
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.reservations
            .do { [weak self] reservations in
                guard let self = self else { return }
                self.tableView.backgroundView = reservations.count > 0 ? nil : self.tableViewBackgroundView
            }
            .drive(tableView.rx.items(cellIdentifier: "ReservationTableViewCell", cellType: ReservationTableViewCell.self)) ({ index, reservation, cell in
                cell.setReservation(reservation)
            }).disposed(by: disposeBag)
    }
    
    private func showReservation(_ reservation: ReservationModel) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ReservationInfoViewController") as? ReservationInfoViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func makeReservation() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MakeReservationViewController") as? MakeReservationViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showMyPage() {
        let storyboard = UIStoryboard.init(name: "MyPage", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MyPageViewController") as? MyPageViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ReservationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Delete tableHeaderView
        return .leastNormalMagnitude
    }
}
