//
//  MyPageViewController.swift
//  signear
//
//  Created by 신정섭 on 2021/05/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    // MARK: - Properties - UI
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties - Private
    
    private var viewModel: MyPageViewModelType? {
        didSet {
            bindUI()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - Private

extension MyPageViewController {
    private func bindUI() {
        
    }
}
