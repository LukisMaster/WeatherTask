//
//  WeatherInteractor.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 20.02.2023.
//

import Foundation
import CoreLocation


protocol WeatherInteractorInputProtocol: AnyObject {
    func fetchWeatherByLocation()
    func fetchWeather(by city: String)
    func fetchSearchHistory()
    func fetchStartInfoViewValues()
    func changeTemperatureStandard(value: TemperatureUnits)
    func removeHistoryItem(at index: Int)
}

protocol WeatherInteractorOutputProtocol: AnyObject {
    func fetchingFail(with error: Error)
    func historyIsFetched(history: [Weather], tempStandard: TemperatureUnits)
    func temperatureStandardDidSet(with value: TemperatureUnits, currentTemperatureCelsius: Int)
    func startInfoViewValuesDidFetched(units: TemperatureUnits, city: String, temperatureCelsius: Int)
    func newWeatherDidFetched(temp: Double, city: String, date: Date, units: TemperatureUnits)
}

final class WeatherInteractor {
    private let networkService: NetworkFetchWeather = NetworkManager.shared
    private let dataService = CoreDataManager.shared
    private let locationService = LocationManager.shared
    private let defaultsService = UserDefaultsManager.shared
        
    weak var presenter: WeatherInteractorOutputProtocol!
}

// MARK: - WeatherInteractorInputProtocol

extension WeatherInteractor: WeatherInteractorInputProtocol {
    func fetchStartInfoViewValues() {
        presenter.startInfoViewValuesDidFetched(
            units: defaultsService.temperatureUnit,
            city: defaultsService.cityInfoView,
            temperatureCelsius: defaultsService.temperatureInfoView
        )
    }
    

    func fetchWeatherByLocation() {
        guard let coordinate = LocationManager.shared.location?.coordinate else {
            fatalError("In WeatherInteractor. Can't get location coordinates") // тут можно заменить на обработчик ошибки
        }
        fetchWeatherBy(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    
    func fetchWeather(by city: String) {
         networkService.fetchCoordinatesData(city: city) { [weak self] result in
             switch result {
             case .failure(let error):
                 self?.presenter.fetchingFail(with: error) // отправить алерт, либо ничего не делать
             case .success(let cityResponse):
                 guard let lat = cityResponse.lat, let lon = cityResponse.lon else {
                     fatalError("In WeatherInteractor. Not corrected city latitude or longitude ") // тут можно заменить на обработчик ошибки
                 }
                 self?.fetchWeatherBy(latitude: lat, longitude: lon)
             }
         }
     }
    
    func fetchSearchHistory() {
        let history = dataService.fetchWeatherData()
        presenter.historyIsFetched(history: history, tempStandard: defaultsService.temperatureUnit)
    }
    
    func changeTemperatureStandard(value: TemperatureUnits) {
        defaultsService.temperatureUnit = value
        presenter.temperatureStandardDidSet(with: value, currentTemperatureCelsius: defaultsService.temperatureInfoView)
    }
    
    func removeHistoryItem(at index: Int) {
        dataService.deleteWeatherData(at: index)
    }
}


// MARK: - Private funcs

private extension WeatherInteractor {
    func fetchWeatherBy(latitude: Double, longitude: Double) {
        self.networkService.fetchWeatherData(latitude: latitude, longitude: longitude) { [weak self] result in
            switch result {
            case .failure(let error):
                self?.presenter.fetchingFail(with: error) // отправить алерт, либо ничего не делать
            case .success(let weatherResponse):
                let date = Date()
                self?.defaultsService.temperatureInfoView = Int(weatherResponse.main?.temp ?? 0.0)
                self?.defaultsService.cityInfoView = weatherResponse.name ?? ""
                
                self?.dataService.insertWeatherData(
                    temperature: Int16(weatherResponse.main?.temp ?? Double.infinity),
                    location: weatherResponse.name ?? "",
                    date: date
                )
                
                self?.presenter.newWeatherDidFetched(
                    temp: weatherResponse.main?.temp ?? 0.0,
                    city: weatherResponse.name ?? "",
                    date: date,
                    units: self?.defaultsService.temperatureUnit ?? .celsius
                )
               // self?.fetchSearchHistory()
            }
        }
    }
}
