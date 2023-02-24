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
    var celciusIsOn: Bool
    
    init(model: WeatherInfoModel? = nil) {
        city = model?.city ?? ""
        temp = model?.temp ?? ""
        celciusIsOn = model?.unit == .fahrenheit ? false : true
        backgroundHexColor = getHexColor()
    }
}
    
// MARK: - Private
private extension InfoViewModel {
    
    var celciusTemp: Int? {
        guard let temp = Int(temp) else { return nil }
        return celciusIsOn ? temp : ( (temp - 32) * 5 / 9 )
    }
    
    func getHexColor() -> String {
        switch celciusTemp {
    
        case let temperature? where (..<10).contains(temperature):
            return BackgroundHexColor.lightBlue.rawValue
        case let temperature? where (10..<26).contains(temperature):
            return BackgroundHexColor.lightOrange.rawValue
        case let temperature? where (26...).contains(temperature):
            return BackgroundHexColor.lightRed.rawValue
        default:
            return BackgroundHexColor.lightBlue.rawValue
        }
    }
}
    
    
//    func convertTempToCelcius() {
//        // (°C × 9/5) + 32 = °F
//        guard let actualTemp = tempLabel.text else { return }
//        guard let actualTemp = Int(actualTemp) else { return }
//        let newTemp = (actualTemp - 32) * 5 / 9
//        tempLabel.text = String(newTemp)
//    }
//
//    func convertTempToFahrenheit() {
//        // (°C × 9/5) + 32 = °F
//        guard let actualTemp = tempLabel.text else { return }
//        guard let actualTemp = Int(actualTemp) else { return }
//        let newTemp = (actualTemp * 9 / 5) + 32
//        tempLabel.text = String(newTemp)
//    }
    

