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
    
    // MARK : Properties - UI
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var findAccountLabel: UILabel!
    
    // MARK : Properties - Internal
    
    var email: String!
    
    // MARK : Properties - Private
    
    private let disposeBag = DisposeBag()
    private var viewModel: LoginViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK : Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LoginViewModel()
        configureUI()
    }
}

// MARK : Private

extension LoginViewController {
    
    private func configureUI() {
        emailTextField.text = email
        initBackgroundColor()
        nextButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self = self,
                      let email = self.emailTextField.text,
                      let password = self.passwordTextField.text else {
                    return
                }
                self.viewModel?.inputs.login(email: email, password: password)
            }).disposed(by: disposeBag)
    }
    
    private func initBackgroundColor() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.init(r: 10, g: 132, b: 255).cgColor,
                                UIColor.init(r: 0, g: 178, b: 255).cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func bindUI() {
        viewModel?.outputs.loginResult
            .filter { $0 }
            .drive(onNext: { [weak self] result in
                self?.showResevationListViewController()
            }).disposed(by: disposeBag)
    }
    
    private func showResevationListViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchRootViewToReservationListView()
    }
}
