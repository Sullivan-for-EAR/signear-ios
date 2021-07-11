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
        if reservaion.type == .emergency {
            titleLabel.text = "긴급통역 연결 중"
            titleLabel.textColor = .init(rgb: 0xFF453A)
            dateLabel.text = "\(convertDate(date: reservaion.date)) \(convertDate(time: reservaion.startTime ?? ""))"
            reservationStatusImageView.image = reservaion.status.getImage()
            
        } else {
            titleLabel.text = reservaion.address
            titleLabel.textColor = .black
            dateLabel.text = "\(convertDate(date: reservaion.date)) \(convertDate(time: reservaion.startTime ?? ""))"
            reservationStatusImageView.image = reservaion.status.getImage()
        }
    }
}

// MARK: - Private

extension ReservationTableViewCell {
    
    func configureUI() {
        // TODO
    }
    
    private func convertDate(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let convertDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.dateFormat = "MMM dd일 EEEE"
        return dateFormatter.string(from: convertDate)
    }
    
    private func convertDate(time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier:"ko_KR")
        dateFormatter.dateFormat = "HHmm"
        let convertDate = dateFormatter.date(from: time) ?? Date()
        dateFormatter.dateFormat = "a h시 mm분"
        return dateFormatter.string(from: convertDate)
    }
}

