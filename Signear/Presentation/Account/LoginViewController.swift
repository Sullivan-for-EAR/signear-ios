//
//  LoginViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/09.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var findAccountLabel: UILabel!
    
    // MARK: - Properties - Internal
    
    var email: String!
    
    // MARK: - Properties - Private
    
    private let disposeBag = DisposeBag()
    private var viewModel: LoginViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}

// MARK: Private

extension LoginViewController {
    
    private func configureUI() {
        emailTextField.text = email
        configuareBackgroundLayer()
        configureBackImageView()
        
        Observable.of(emailTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty).merge()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: { [weak self] text in
                self?.updateUI()
            }).disposed(by: disposeBag)
        
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 5
        loginButton.setBackgroundColor(.init(rgb: 0x222222), for: .normal)
        loginButton.setBackgroundColor(.init(rgb: 0xB6B6B6), for: .disabled)
        loginButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self,
                      let email = self.emailTextField.text,
                      let password = self.passwordTextField.text else {
                    return
                }
                self.viewModel?.inputs.login(email: email, password: password)
            }).disposed(by: disposeBag)
        
    
        let tapGenture = UITapGestureRecognizer(target: self, action: nil)
        tapGenture.rx.event
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.showFindPasswordViewController()
            }).disposed(by: disposeBag)
        findAccountLabel.addGestureRecognizer(tapGenture)
    }
    
    private func configuareBackgroundLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.init(r: 10, g: 132, b: 255).cgColor,
                                UIColor.init(r: 0, g: 178, b: 255).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func configureBackImageView() {
        let backGenture = UITapGestureRecognizer(target: self, action: nil)
        backGenture.rx.event
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: false)
            }).disposed(by: disposeBag)
        backImageView.addGestureRecognizer(backGenture)
    }
    
    private func bindUI() {
        viewModel?.outputs.loginResult
            .filter { $0 }
            .drive(onNext: { [weak self] result in
                self?.showResevationListViewController()
            }).disposed(by: disposeBag)
    }
    
    private func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.loginButton.isEnabled = self.emailTextField.text?.isValidEmail() == true && self.passwordTextField.text?.isNotEmpty == true
        }
    }
    
    private func showResevationListViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchRootViewToReservationListView()
    }
    
    private func showFindPasswordViewController() {
        let alert = UIAlertController(title: nil,
                                      message: "현재 개발 중입니다.\n곧 이어 드릴게요 :-)",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}
