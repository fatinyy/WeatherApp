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


struct Main: Decodable {
    let temp: Double
    let temp_min:Double
    let temp_max:Double
}
 

struct Weather:Decodable{
    let id: Int
    let description : String
}


struct ForecastData: Decodable{
    let list: [List]
    let city: City
}

struct List: Decodable{
    let main: Main
    let weather: [WeatherForecastData]
    let dt_txt: String
}

struct WeatherForecastData: Decodable{
    let main: String
    let description: String
}

struct City: Decodable{
    let name: String
    let id: Int
}

