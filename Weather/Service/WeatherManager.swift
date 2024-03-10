//
//  WeatherManager.swift
//  Weather
//
//  Created by aifara on 07/03/2024.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:WeatherModel)
    func didUpdateWeather(_ weatherManager: WeatherManager, weather:[WeatherModel])
    func didFailWithError(error: Error)

}
struct WeatherManager{
    
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        print(urlString)
        performRequest(with: urlString)
    }
    
    
    func fetchWeatherForecast(cityName:String){
        let urlString = "\(forecastURL)&q=\(cityName)"
        print(urlString)
        performRequestForecast(with: urlString)
    }
    
    func fetchWeatherForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(forecastURL)&lat=\(latitude)&lon=\(longitude)"
        print("###################")
        print(urlString)
        performRequestForecast(with: urlString)
    }
    
    
    

    
    func performRequest(with urlString:String){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather =  self.parseJSON(safeData){
                        print("##########")
                        print(weather)
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    
    
    func performRequestForecast(with urlString:String){
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    if let weather =  self.parseForecastJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
        
    }
    
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let descriptions = decodedData.weather[0].description
            
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, descriptions: descriptions)
            
            print(weather.conditionName)
            return weather
        }
        catch{
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    
    
    
    
    func parseForecastJSON(_ weatherData: Data) -> [WeatherModel]? {
        print("D#####")
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do{
            let decodedData = try decoder.decode(ForecastData.self, from: weatherData)
                  var weatherModels: [WeatherModel] = []

                   // Process only the first 5 items
            for index in 0..<min(5, decodedData.list.count) {
                       let forecast = decodedData.list[index]
                
                print("##### \(index)")
                print("Temp : \(forecast.main.temp)")
                       let weatherModel = WeatherModel(conditionId: decodedData.city.id,
                                                       cityName: decodedData.city.name,
                                                       temperature: forecast.main.temp,descriptions: forecast.weather[0].description)
                       weatherModels.append(weatherModel)
                   }
                   return weatherModels
        }
        catch{
            print(error)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    
    
    
    
//    func parseForecastJSON(_ weatherData: Data) -> [WeatherModel]? {
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode([ForecastData].self, from: weatherData)
//            
//            var weatherModels: [WeatherModel] = []
//            
//            // Process only the first 5 items
//            for index in 0..<min(5, decodedData.list.count) {
//                let forecast = decodedData.list[index]
//              
//                
////                print("Date: \(dateString)")
////                print("Temperature: \(forecast.main.temp)°C")
////                print("Weather ID: \(forecast.weather[0].id)")
////                print("Weather Description: \(forecast.weather[0].description)")
////                print("---")
//                
//                let weatherModel = WeatherModel(conditionId: forecast.id,
//                                                cityName: decodedData.city.name,
//                                                temperature: decodedData.main.temp)
//                weatherModels.append(weatherModel)
//            }
//            
//            return weatherModels
//        } catch {
//            print(error)
//            delegate?.didFailWithError(error: error)
//            return nil
//        }
//    }

    
}
