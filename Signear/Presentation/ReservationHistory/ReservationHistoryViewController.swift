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
    
    // MARK: - Actions
    
    @objc private func didTappedBackButton(_ button: UINavigationItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private

extension ReservationHistoryViewController {
    
    private func configureUI() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = .init()
        navigationItem.leftBarButtonItem = .init(image: .init(named: "leftArrowIcon"), style: .plain, target: self, action: #selector(didTappedBackButton(_:)))
        
        tableView.register(.init(nibName: "ReservationHistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "ReservationHistoryTableViewCell")
        
        tableView.rx.modelSelected(ReservationHistoryModel.self)
            .subscribe(onNext: { [weak self] history in
                self?.showHistory(history)
            }).disposed(by: disposeBag)
    }
    
    private func bindUI() {
        viewModel?.outputs.reservationHistory
            .drive(tableView.rx.items(cellIdentifier: "ReservationHistoryTableViewCell", cellType: ReservationHistoryTableViewCell.self)) ({ index, history, cell in
                cell.setHistory(history)
            }).disposed(by: disposeBag)
    }
    
    private func showHistory(_ history: ReservationHistoryModel) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ReservationHistoryInfoViewController") as? ReservationHistoryInfoViewController else { return }
        vc.view.backgroundColor = .init(rgb: 000000, alpha: 0.5)
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = .overFullScreen
        vc.history = history
        present(vc, animated: false)
    }
}
