//
//  ReservationListViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/11.
//

import UIKit

class ReservationListViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var reservationButton: UIButton!
    
    // MARK: Properties - Private
    
    private var viewModel: ReservationListViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

// MARK: - Private

extension ReservationListViewController {
    
    private func configureUI() {
        // TODO
    }
    
    private func bindUI() {
        // TODO
    }
}
