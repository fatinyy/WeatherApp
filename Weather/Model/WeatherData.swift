//
//  WeatherData.swift
//  Weather
//
//  Created by aifara on 07/03/2024.
//

import Foundation


struct WeatherData: Decodable{
    let name: String
    let main: Main
    let weather: [Weather]
}


struct Main: Decodable{
    
    let temp: Double
}

struct Weather:Decodable{
    let id: Int
    let description : String
}


struct ForecastData: Decodable{
    let list: [WeatherData]
    let city: City
 
}

struct City: Decodable{
    
    let name: String
    let id: Int
}
