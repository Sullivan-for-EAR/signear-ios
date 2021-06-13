//
//  ReservationTableViewCell.swift
//  signear
//
//  Created by 신정섭 on 2021/05/11.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {
    
    // MARK: - Properties : UI
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var reservationStatusImageView: UIImageView!
    
    // MARK: - Properties : Private
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
}

// MARK: - Internal

extension ReservationTableViewCell {
    
    func setReservation(_ reservaion: ReservationModel) {
        titleLabel.text = reservaion.area
        dateLabel.text = reservaion.date
        reservationStatusImageView.image = reservaion.status.getImage()
    }
}

// MARK: - Private

extension ReservationTableViewCell {
    
    func configureUI() {
        // TODO
    }
}

