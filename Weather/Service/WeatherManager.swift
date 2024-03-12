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
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?APPID=&units=metric"
    let forecastURL = "https://api.openweathermap.org/data/2.5/forecast?APPID=c&units=metric"
    
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
            let minTemp = decodedData.main.temp_min
            let maxTemp = decodedData.main.temp_max
            let name = decodedData.name
            let descriptions = decodedData.weather[0].description
            let dateTimeString = "Today"
            
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp,tempMin:decodedData.main.temp_min,tempMax: maxTemp, descriptions: descriptions, dateTimeString:dateTimeString)
            
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
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(ForecastData.self, from: weatherData)
            
            var weatherModels: [WeatherModel] = []
            
    
            for index in stride(from: 0, to: decodedData.list.count, by: 8) {
                

                let forecast = decodedData.list[index]
                
                print("#######\(forecast.dt_txt)")
                
                let weatherModel = WeatherModel(conditionId: decodedData.city.id,
                                                cityName: decodedData.city.name,
                                                temperature: forecast.main.temp,tempMin:forecast.main.temp_min,tempMax:forecast.main.temp_max,descriptions: forecast.weather[0].description, dateTimeString: forecast.dt_txt)
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
    
    
    
}
