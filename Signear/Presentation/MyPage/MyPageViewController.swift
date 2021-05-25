//
//  MyPageViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/25.
//

import UIKit
import RxCocoa
import RxSwift

class MyPageViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties - Private
    
    private enum Constants {
        static let profileRow = 0
        static let emergencyRow = 1
        static let historyRow = 2
        static let commentRow = 3
        static let logoutRow = 4
    }
    
    private var viewModel: MyPageViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyPageViewModel()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Private

extension MyPageViewController {
    
    private func configureUI() {
        tableView.register(.init(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.register(.init(nibName: "EmergencyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmergencyTableViewCell")
        tableView.register(.init(nibName: "MyPageTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPageTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindUI() {
        viewModel?.outputs.profile
            .drive(onNext: { [weak self] profile in
                self?.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
            }).disposed(by: disposeBag)
    }
    
    private func showEmergencyCall() {
        // TODO
    }
    
    private func showReservationHistory() {
        // TODO
    }
    
    private func showCommentPage() {
        // TODO
    }
    
    private func logout() {
        // TODO
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Constants.profileRow:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else { return ProfileTableViewCell() }
            return cell
        case Constants.emergencyRow:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmergencyTableViewCell", for: indexPath)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else { return MyPageTableViewCell() }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case Constants.emergencyRow:
            showEmergencyCall()
        case Constants.historyRow:
            showReservationHistory()
        case Constants.commentRow:
            showCommentPage()
        case Constants.logoutRow:
            logout()
        default:
            return
        }
    }
    
}
