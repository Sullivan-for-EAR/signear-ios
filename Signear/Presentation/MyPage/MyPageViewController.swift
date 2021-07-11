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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties - Private
    
    private enum Constants {
        static let emergencyRow = 0
        static let historyRow = 1
        static let commentRow = 2
        static let logoutRow = 3
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
        viewModel?.inputs.fetchProfile()
    }
    
    // MARK: - Actions
    
    @objc private func didTappedBackButton(_ button: UINavigationItem) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private

extension MyPageViewController {
    
    private func configureUI() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = .init()
        navigationItem.leftBarButtonItem = .init(image: .init(named: "leftArrowIcon"), style: .plain, target: self, action: #selector(didTappedBackButton(_:)))
        
        tableView.register(.init(nibName: "EmergencyTableViewCell", bundle: nil), forCellReuseIdentifier: "EmergencyTableViewCell")
        tableView.register(.init(nibName: "MyPageTableViewCell", bundle: nil), forCellReuseIdentifier: "MyPageTableViewCell")
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func bindUI() {
        viewModel?.outputs.profile
            .drive(onNext: { [weak self] profile in
                guard let self = self else { return }
                self.nameLabel.text = profile.name
                self.phoneLabel.text = profile.phoneNumber
            }).disposed(by: disposeBag)
    }
    
    private func showEmergencyCall() {
        let alert = UIAlertController(title: nil,
                                      message: "현재 개발 중입니다.\n곧 이어 드릴게요 :-)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true, completion: nil)
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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchRootViewToInitialView()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
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
