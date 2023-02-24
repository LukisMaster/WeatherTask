//
//  HistoryTableViewCell.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit


protocol CellModelRepresentable {
    var viewModel: CellIdentifiable? { get set }
}

class HistoryTableViewCell: UITableViewCell, CellModelRepresentable  {
    var viewModel: CellIdentifiable? {
        didSet {
            configure()
        }
    }
    
    private lazy var сityLabel: UILabel = {
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
    
    func configure() {
        guard let cellViewModel = viewModel as? HistoryCellViewModel else { return }
        setupDataCity(name: cellViewModel.city)
        setupDataTemp(temp: cellViewModel.temp, unit: cellViewModel.unit)
        setupDataDate(date: cellViewModel.date)
    }

}

// MARK: - private HistoryTableViewCell

private extension HistoryTableViewCell {
    func setupUI() {
        contentView.subviews(сityLabel,
                             tempLabel,
                             dateLabel)
                
        NSLayoutConstraint.activate([
            сityLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            сityLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.inset),
            
            tempLabel.centerYAnchor.constraint(equalTo: сityLabel.centerYAnchor),
            tempLabel.leftAnchor.constraint(equalTo: сityLabel.rightAnchor),

            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            dateLabel.leftAnchor.constraint(equalTo: сityLabel.leftAnchor)
        ])
    }
    
    func setupDataCity(name: String) {
        сityLabel.text = name
    }
    
    func setupDataTemp(temp: String, unit: TempStandard) {
        switch unit {
        case .celsius: tempLabel.text = temp + "° C"
        case .fahrenheit: tempLabel.text = temp + "° F"
        }
    }
    
    func setupDataDate(date: Date?) {
        guard let date = date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.mm.yyyy hh:mm:ss"
        let dateDecod = dateFormatter.string(from: date)
        dateLabel.text = dateDecod
    }
}


// MARK: - private enum

private extension HistoryTableViewCell {
    enum Constants {
        static let inset: CGFloat = 20
    }
}
