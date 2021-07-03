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
                guard let self = self else { return }
                if reservation.type == .emergency {
                    self.showCancelEmergencyCallAlertView(reservation)
                } else {
                    self.showReservation(reservation)
                }
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
        vc.reservationId = reservation.rsID
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showCancelEmergencyCallAlertView(_ reservation: ReservationModel) {
        let alert = UIAlertController(title: "긴급통역 취소",
                                      message: "긴급통역 연결을 정말 취소하시나요?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "연결 취소", style: .destructive, handler: { [weak self] _ in
            self?.viewModel?.inputs.cancelEmergencyCall(reservationId: reservation.rsID)
        }))
        alert.addAction(UIAlertAction(title: "닫기", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func makeReservation() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CreateReservationViewController") as? CreateReservationViewController else { return }
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
