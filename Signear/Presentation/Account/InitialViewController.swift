//
//  InitialViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/05.
//

import UIKit

class InitialViewController: UIViewController {
    
    // MARK : Properties - UI
    @IBOutlet private weak var startButton: UIButton!
    
    // MARK : Properties - Private
    
    private var viewModel: InitialViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK : UI Life Cycle
    
    override func viewDidLoad() {
        initUI()
    }
    
}

// MARK : Private

extension InitialViewController {
    
    private func initUI() {
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
        
    }
}
