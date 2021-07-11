//
//  String+Extension.swift
//  signear
//
//  Created by 신정섭 on 2021/07/04.
//

import Foundation

extension String {
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}
