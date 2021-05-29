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
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
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
        let storyboard = UIStoryboard.init(name: "Emergency", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "EmergencyViewController") as? EmergencyViewController else {
            return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showReservationHistory() {
        let storyboard = UIStoryboard.init(name: "ReservationHistory", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ReservationHistoryViewController") as? ReservationHistoryViewController else {
            return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showCommentPage() {
        // TODO
    }
    
    private func showLogoutAlertView() {
        let alert = UIAlertController(title: "로그아웃",
                                      message: "정말 로그아웃 하시나요?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            self?.logout()
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func logout() {
        navigationController?.popToRootViewController(animated: true)
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
        case Constants.historyRow:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else { return MyPageTableViewCell() }
            cell.setTitle(NSLocalizedString("지난 예약", comment: ""))
            return cell
        case Constants.commentRow:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else { return MyPageTableViewCell() }
            cell.setTitle(NSLocalizedString("의견 남기기", comment: ""))
            return cell
        case Constants.logoutRow:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell", for: indexPath) as? MyPageTableViewCell else { return MyPageTableViewCell() }
            cell.setTitle(NSLocalizedString("로그아웃", comment: ""))
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
            showLogoutAlertView()
        default:
            return
        }
    }
    
}
