//
//  UserDefaultsManager.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 25.02.2023.
//

import Foundation

class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}
    
    // Keys for storing values in UserDefaults
    private let temperatureUnitKey = "temperatureUnit"
    private let cityInfoViewKey = "cityInfoView"
    private let temperatureInfoViewKey = "temperatureInfoView"

    // Default value for temperature unit is Celsius
    var temperatureUnit: TemperatureUnits {
        get {
            guard let value = UserDefaults.standard.value(forKey: temperatureUnitKey) as? String else { return .celsius }
            return TemperatureUnits(rawValue: value) ?? .celsius
        }
        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: temperatureUnitKey)
        }
    }
    
    var cityInfoView : String {
        get {
            guard let value = UserDefaults.standard.value(forKey: cityInfoViewKey) as? String else { return "Your city" }
            return value
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: cityInfoViewKey)
        }
    }
    
    var temperatureInfoView : Int {
        get {
            guard let value = UserDefaults.standard.value(forKey: temperatureInfoViewKey) as? Int else { return 0 }
            return value
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: temperatureInfoViewKey)
        }
    }
}
