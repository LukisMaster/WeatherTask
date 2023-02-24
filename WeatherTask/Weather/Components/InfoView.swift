//
//  InfoView.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit

protocol InfoViewDelegate: AnyObject {
    //in
    func updateData(viewModel: InfoViewModel)
    
    //out
    func switchValueChanged(temperatureStandardSwitchIsOn: Bool)
}

class InfoView: UIView {
    
    weak var delegate: InfoViewDelegate?
    
    private var viewModel: InfoViewModel? {
        didSet {
            configure()
        }
    }
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Your City"
        label.font = .helveticaNeueLight(40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var tempLabel: UILabel = {
        let label = UILabel()
        label.text = "95"
        label.font = .helveticaNeueLight(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var degreeLabel: UILabel = {
        let label = UILabel()
        label.text = "°"
        label.font = .helveticaNeueLight(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var celciusLabel: UILabel = {
        let label = UILabel()
        label.text = "C"
        label.font = .helveticaNeueLight(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fahrenheitLabel: UILabel = {
        let label = UILabel()
        label.text = "F"
        label.font = .helveticaNeueLight(25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tempSwitch: UISwitch = {
        let tempSwitch = UISwitch()
        tempSwitch.translatesAutoresizingMaskIntoConstraints = false
        tempSwitch.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        tempSwitch.onTintColor = .clear
        return tempSwitch
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - private InfoView

private extension InfoView {
    func setupUI() {
        subviews(cityLabel,
                 tempLabel,
                 celciusLabel,
                 fahrenheitLabel,
                 tempSwitch,
                 degreeLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.сityLabelTopIndent),
            cityLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.сityLabelLeftIndent),
        
            tempLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.tempLabelBottomIndent),
            tempLabel.leftAnchor.constraint(equalTo: cityLabel.leftAnchor),
            
            degreeLabel.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            degreeLabel.leftAnchor.constraint(equalTo: tempLabel.rightAnchor),
            
            celciusLabel.centerYAnchor.constraint(equalTo: tempLabel.centerYAnchor),
            celciusLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: Constants.celciusLabelRightIndent),
            
            tempSwitch.centerYAnchor.constraint(equalTo: celciusLabel.centerYAnchor),
            tempSwitch.rightAnchor.constraint(equalTo: celciusLabel.leftAnchor, constant: Constants.itemInset),
            
            fahrenheitLabel.centerYAnchor.constraint(equalTo: tempSwitch.centerYAnchor),
            fahrenheitLabel.rightAnchor.constraint(equalTo: tempSwitch.leftAnchor, constant: Constants.itemInset)
        ])
        
    }
    
    func configure() {
        cityLabel.text = viewModel?.city ?? "Your City"
        tempLabel.text = viewModel?.temp ?? "95"
        tempSwitch.isOn = viewModel?.celciusIsOn ?? false
        backgroundColor = UIColor(hex: viewModel?.backgroundHexColor ?? BackgroundHexColor.lightBlue.rawValue)
    }
}

// MARK: - @objc private InfoView

@objc
private extension InfoView {
    func didTapSwitch() {
        delegate?.switchValueChanged(temperatureStandardSwitchIsOn: tempSwitch.isOn)
    }
}


// MARK: - private enum

private extension InfoView {
    enum Constants {
        static let сityLabelLeftIndent: CGFloat = UIScreen.main.bounds.width / 15
        static let сityLabelTopIndent: CGFloat =  UIScreen.main.bounds.width / 20
        static let tempLabelBottomIndent: CGFloat =  -сityLabelTopIndent * 2
        static let celciusLabelRightIndent: CGFloat =  -сityLabelLeftIndent
        static let itemInset: CGFloat =  -сityLabelLeftIndent / 2
    }
}
