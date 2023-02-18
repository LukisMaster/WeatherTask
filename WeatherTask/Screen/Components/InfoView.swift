//
//  InfoView.swift
//  weatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import UIKit


class InfoView: UIView {
    
    lazy var sityLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Sity"
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
        let obj = UISwitch()
        obj.translatesAutoresizingMaskIntoConstraints = false
        obj.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        obj.onTintColor = .clear
        return obj
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
        backgroundColor = UIColor(hex: "#5ac8fa") // light blue
        backgroundColor = UIColor(hex: "#FFD580") // light orange
        backgroundColor = UIColor(hex: "#FF6666") // light red
        
        
        subviews(sityLabel,
                 tempLabel,
                 celciusLabel,
                 fahrenheitLabel,
                 tempSwitch,
                 degreeLabel)
        
        NSLayoutConstraint.activate([
            sityLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.sityLabelTopIndent),
            sityLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: Constants.sityLabelLeftIndent),
        
            tempLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Constants.tempLabelBottomIndent),
            tempLabel.leftAnchor.constraint(equalTo: sityLabel.leftAnchor),
            
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
}

// MARK: - @objc private InfoView

@objc
private extension InfoView {
    func didTapSwitch() {
        if tempSwitch.isOn {
            convertTempToCelcius()
        } else {
            convertTempToFahrenheit()
        }
    }
    
    func convertTempToCelcius() {
        // (°C × 9/5) + 32 = °F
        guard let actualTemp = tempLabel.text else { return }
        guard let actualTemp = Int(actualTemp) else { return }
        let newTemp = (actualTemp - 32) * 5 / 9
        tempLabel.text = String(newTemp)
    }
    
    func convertTempToFahrenheit() {
        // (°C × 9/5) + 32 = °F
        guard let actualTemp = tempLabel.text else { return }
        guard let actualTemp = Int(actualTemp) else { return }
        let newTemp = (actualTemp * 9 / 5) + 32
        tempLabel.text = String(newTemp)
    }
}


// MARK: - private enum

private extension InfoView {
    enum Constants {
        static let sityLabelLeftIndent: CGFloat = UIScreen.main.bounds.width / 15
        static let sityLabelTopIndent: CGFloat =  UIScreen.main.bounds.width / 20
        static let tempLabelBottomIndent: CGFloat =  -sityLabelTopIndent * 2
        static let celciusLabelRightIndent: CGFloat =  -sityLabelLeftIndent
        static let itemInset: CGFloat =  -sityLabelLeftIndent / 2
    }
}
