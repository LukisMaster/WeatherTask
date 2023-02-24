//
//  NetworkManager.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 24.02.2023.
//

import Foundation

protocol NetworkFetchWeather {
    func fetchCoordinatesData(city: String, completion: @escaping (Result<CityResponse, Error>) -> Void)
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void)
}

final class NetworkManager: NetworkFetchWeather {
    
    // MARK: - Properties
    
    static let shared = NetworkManager()
    
    init() {}
    
    // MARK: - Methods
    
    func fetchWeatherData(latitude: Double, longitude: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void) {
        
        let urlString = "\(Constant.URLStringForFetchWeather)lat=\(latitude)&lon=\(longitude)&appid=\(Constant.apiKey)&units=\(Constant.units)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            do {
                let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchCoordinatesData(city: String, completion: @escaping (Result<CityResponse, Error>) -> Void) {
        
        let urlString = "\(Constant.URLStringForFetchCity)q=\(city)&appid=\(Constant.apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            do {
                let response = try JSONDecoder().decode(CityResponse.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

// MARK: - Constant
    enum Constant {
        static let apiKey = "YOUR_API_KEY_HERE"
        static let URLStringForFetchWeather = "https://api.openweathermap.org/data/2.5/weather?"
        static let URLStringForFetchCity = "https://api.openweathermap.org/geo/1.0/direct?"
        static let units = "metric"    // Celsius
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidData
}
