//
//  UIButton+Extension.swift
//  signear
//
//  Created by 홍필화 on 2021/05/30.
//

import UIKit

extension UIButton {
    func setButton(state: UIControl.State) {
        switch state {
        case .selected:
            self.backgroundColor = UIColor(rgb: 0x0A84FF, alpha: 0.05)
            self.layer.borderWidth = 2.0
            self.layer.borderColor = UIColor(rgb: 0x0A84FF, alpha: 1).cgColor
            break
        case .normal:
            self.layer.borderWidth = 1.0
            self.layer.borderColor = UIColor(rgb: 0xD6D6D6, alpha: 1).cgColor
            self.backgroundColor = .clear
            break
        default:
            break
        }
    }
}
