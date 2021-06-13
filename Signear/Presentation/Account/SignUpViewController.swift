//
//  SignUpViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/09.
//

import UIKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController {
    
    // MARK : Properties - UI
    @IBOutlet private weak var backImageView: UIImageView!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var phoneTextField: UITextField!
    @IBOutlet private weak var signUpButton: UIButton!
    
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

extension SignUpViewController {
    
    private func configureUI() {
        emailTextField.text = email
        initBackgroundColor()
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
                self?.showHelloViewController()
            }).disposed(by: disposeBag)
    }
    
    private func showHelloViewController() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "HelloViewController") as? HelloViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
}

