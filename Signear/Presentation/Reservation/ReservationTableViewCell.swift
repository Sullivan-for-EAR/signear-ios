//
//  ReservationTableViewCell.swift
//  signear
//
//  Created by 신정섭 on 2021/05/11.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {
    
    // MARK: - Properties : Private
    
    private var reservationTitleLabel: UILabel = UILabel()
    private var reservationDateLabel: UILabel = UILabel()
    private var reservateionStatusLabel: UILabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
}

// MARK: Private

extension ReservationTableViewCell {
    private func configureUI() {
        self.contentView.addSubview(reservationTitleLabel)
        reservationTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        reservationTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24).isActive = true
        reservationTitleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20).isActive = true
        
        self.contentView.addSubview(reservationDateLabel)
        reservationDateLabel.translatesAutoresizingMaskIntoConstraints = false
        reservationDateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24).isActive = true
        reservationDateLabel.topAnchor.constraint(equalTo: self.reservationTitleLabel.bottomAnchor, constant: 3).isActive = true
        reservationDateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -20).isActive = true
    }
}
