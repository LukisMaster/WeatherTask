//
//  WeatherPresenter.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 18.02.2023.
//

import Foundation

struct WeatherHistoryData {
    
}

final class WeatherPresenter {
    weak var view: WeatherViewInputProtocol!
    var interactor: WeatherInteractorInputProtocol!
    
    
}


// MARK: - WeatherViewOutputProtocol
extension WeatherPresenter: WeatherViewOutputProtocol {
    func didTapCell(with cellViewModel: HistoryCellViewModel) {
        //without interactor
    }
    
    func didLocationButtonPressed() {
        interactor.fetchWeatherByLocation()
    }
    
    func didTemperatureStandardToggleSwitched(isEnable: Bool) {
        interactor.changeTemperatureStandard(value: isEnable ? TempStandard.celsius : TempStandard.fahrenheit)
    }
    
    func didSearchBarTextChanged(text: String) {
        interactor.fetchWeather(by: text)
    }
    
    func viewDidLoad() {
        interactor.fetchSearchHistory()
    }
    
//    func viewDidLoad() {
////        interactor.fetchSearchHistory()
//    }
    
//    func getCurrentWeather(for cityName: String) {
//        interactor.fetchWeather(by: cityName) { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case .success(let weatherResponse):
//                self.presentWeather(response: weatherResponse)
//            case .failure(let error):
//                self.presentError(error)
//            }
//        }
//    }
}
// MARK: - WeatherInteractorOutputProtocol
extension WeatherPresenter: WeatherInteractorOutputProtocol {
    
    func temperatureStandardDidSet(with value: TempStandard, currentTemperatureCelsius: Int16) {
        view.updateInfoViewWith(city: "", tempCelsius: Int(currentTemperatureCelsius), celsiusIsOn: value == .celsius ? true : false)
    }
    
    func weatherIsFetched(weather: WeatherResponse , currentTemperatureStandard: TempStandard) {
        view.updateInfoViewWith(
            city: weather.name ?? "",
            tempCelsius: Int(weather.main?.temp ?? 0),
            celsiusIsOn: currentTemperatureStandard == .celsius ? true : false
        )
    }
    
    func fetchingFail(with error: Error) {
        print(error.localizedDescription)
    }
    
    func historyIsFetched(history: [Weather]) {
        
    }
    
    
    func weatherHistoryDidReceive(weatherHistory: [Weather]) {
        let section = HistorySectionViewModel()
        weatherHistory.forEach { weather in
            section.rows.append(HistoryCellViewModel(model: WeatherInfoModel(
                date: weather.date,
                city: weather.cityName ?? "No city data",
                temp: String(weather.tempCelsius),
                unit: .celsius
            )))
        }
        view.reloadHistory(for: section)
    }
}


// MARK: - private MainPresenter

private extension WeatherPresenter {
    
}
