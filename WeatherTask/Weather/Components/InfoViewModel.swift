//
//  InfoViewModel.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 23.02.2023.
//


final class InfoViewModel {
    var backgroundHexColor: String
    var city: String
    var temp: String
    var celsiusIsOn: Bool
    
    init(city: String, tempCelsius: Int, celsiusIsOn: Bool) {
        let temperature = celsiusIsOn ? tempCelsius : celsiusConvertToFahrenheit(tempCelsius)
        self.city = city
        self.temp = String(temperature)
        self.celsiusIsOn = celsiusIsOn
        self.backgroundHexColor = getHexColor(from: tempCelsius)
    }
    
    init(model: WeatherInfoModel? = nil) {
        city = model?.city ?? ""
        temp = model?.temp ?? ""
        celsiusIsOn = model?.unit == .fahrenheit ? false : true
        
        backgroundHexColor = getHexColor(from: toCelsiusInt(temperature: temp, celsiusIsOn: celsiusIsOn))
        }
}

 // MARK: - fileprivate funcs
fileprivate func celsiusConvertToFahrenheit(_ celsius: Int) -> Int {
    (celsius * 9 / 5) + 32
}

fileprivate func toCelsiusInt(temperature: String, celsiusIsOn: Bool) -> Int? {
    guard let temperature = Int(temperature) else { return nil }
    return celsiusIsOn ? temperature : celsiusConvertToFahrenheit(temperature)
}

fileprivate func getHexColor(from celsiusTemperature: Int?) -> String {
    switch celsiusTemperature {
    case let temperature? where (..<10).contains(temperature):
        return  BackgroundHexColor.lightBlue.rawValue
    case let temperature? where (10..<26).contains(temperature):
        return  BackgroundHexColor.lightOrange.rawValue
    case let temperature? where (26...).contains(temperature):
        return  BackgroundHexColor.lightRed.rawValue
    default:
        return  BackgroundHexColor.lightBlue.rawValue
    }
}
