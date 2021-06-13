//
//  HelloViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/11.
//

import UIKit
import RxCocoa
import RxSwift

class HelloViewController: UIViewController {
    
    // MARK : Properties - UI
    
    @IBOutlet private weak var startButton: UIButton!
    
    // MARK : Properties - Private
    
    private let disposeBag = DisposeBag()
    private var viewModel: HelloViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK : Life Cycle
    
    override func viewDidLoad() {
        configureUI()
    }
}

// MARK : Private

extension HelloViewController {
    
    private func configureUI() {
        initBackgroundColor()
        startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.showReservationListViewController()
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
        
    }
    
    private func showReservationListViewController() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.switchRootViewToReservationListView()
    }
}
