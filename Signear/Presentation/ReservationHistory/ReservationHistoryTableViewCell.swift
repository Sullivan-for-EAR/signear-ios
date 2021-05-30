//
//  ReservationHistoryTableViewCell.swift
//  signear
//
//  Created by 신정섭 on 2021/05/26.
//

import UIKit

class ReservationHistoryTableViewCell: UITableViewCell {
    
    // MARK: - Properties - UI
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var statusImageView: UIImageView!
}

// MARK: - Internal

extension ReservationHistoryTableViewCell {
    func setReservationHistory(_ history: ReservationHistoryModel) {
        titleLabel.text = history.title
        dateLabel.text = history.date
        statusImageView.image = history.status.getImage()
    }
}
