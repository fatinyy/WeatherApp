//
//  WeatherModel.swift
//  Weather
//
//  Created by aifara on 07/03/2024.
//

import Foundation


struct WeatherModel {
    
    let conditionId:Int
    let cityName:String
    let temperature: Double
    let tempMin:Double
    let tempMax:Double
    let descriptions: String
    let dateTimeString: String
    
    
    var dayOfWeekString: String {
            if let day = dayOfWeek(from: dateTimeString) {
                return day
            } else {
                return "Unknown"
            }
        }

    
    
    var temperatureString: String{
        return String(format: "%.1f", temperature)
    }
    

    
    var conditionName:String{
        switch conditionId {
                case 200...232:
                    return "cloud.bolt"
                case 300...321:
                    return "cloud.drizzle"
                case 500...531:
                    return "cloud.rain"
                case 600...622:
                    return "cloud.snow"
                case 701...781:
                    return "cloud.fog"
                case 800:
                    return "sun.max"
                case 801...804:
                    return "cloud.bolt"
                default:
                    return "cloud"
                }
    }
    
    
    
    private func dayOfWeek(from dateStringOrTimestamp: String) -> String? {
           let formatter = DateFormatter()
               
               formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               if let date = formatter.date(from: dateStringOrTimestamp) {
                   let calendar = Calendar.current
                   let today = calendar.startOfDay(for: Date())
                    let inputDay = calendar.startOfDay(for: date)
                   
                   
                   if today == inputDay {
                                return "Today"
                            } else {
                                let day = calendar.component(.weekday, from: date)
                                return calendar.weekdaySymbols[day - 1]
                            }
                   
                   
               } else {
                   return nil
               }
           
       }
    
}
