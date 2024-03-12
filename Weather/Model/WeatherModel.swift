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
           
           // Check if the input is a Unix timestamp (assuming it's seconds since 1970)
           if let unixTime = Double(dateStringOrTimestamp) {
               let date = Date(timeIntervalSince1970: unixTime)
               formatter.dateFormat = "EEEE"  // EEEE for full day of the week like "Monday"
               return formatter.string(from: date)
           } else {
               // Assuming the input is a date string in "yyyy-MM-dd HH:mm:ss" format
               formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               if let date = formatter.date(from: dateStringOrTimestamp) {
                   let calendar = Calendar.current
                   let day = calendar.component(.weekday, from: date)
                   return calendar.weekdaySymbols[day - 1]
               } else {
                   return nil
               }
           }
       }
    
}
