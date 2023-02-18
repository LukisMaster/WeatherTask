//
//  HistoryCell.swift
//  weatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    private lazy var sityLabel: UILabel = {
        let label = UILabel()
        label.font = .helveticaNeueLight(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.font = .helveticaNeueLight(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .helveticaNeueLight(25)
        label.text = "dd.mm.yyyy hh:mm:ss"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
    }
    
    func configure(model: HistoryModel) {
        setupDataSity(name: model.city)
        setupDataTemp(temp: model.temp, unit: model.unit)
        setupDataDate(date: model.date)
    }

}

// MARK: - private HistoryCell

private extension HistoryCell {
    func setupUI() {
        contentView.subviews(sityLabel,
                             tempLabel,
                             dateLabel)
                
        NSLayoutConstraint.activate([
            sityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            sityLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.inset),
            
            tempLabel.centerYAnchor.constraint(equalTo: sityLabel.centerYAnchor),
            tempLabel.leftAnchor.constraint(equalTo: sityLabel.rightAnchor),

            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            dateLabel.leftAnchor.constraint(equalTo: sityLabel.leftAnchor)
        ])
    }
    
    func setupDataSity(name: String) {
        sityLabel.text = name
    }
    
    func setupDataTemp(temp: String, unit: ForTemp) {
        switch unit {
        case .celcius: tempLabel.text = ", " + temp + "° C"
        case .fahrenheit: tempLabel.text = temp + "° F"
        }
    }
    
    func setupDataDate(date: Date?) {
        guard let date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy hh:mm:ss"
        let dateDecod = dateFormatter.string(from: date)
        dateLabel.text = dateDecod
    }
}


// MARK: - private enum

private extension HistoryCell {
    enum Constants {
        static let inset: CGFloat = 20
    }
}
