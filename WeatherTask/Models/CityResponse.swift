//
//  CityResponse.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 24.02.2023.
//

// MARK: - CityResponse
struct CityResponse: Decodable {
    let name: String?
    let lat, lon: Double?
}
