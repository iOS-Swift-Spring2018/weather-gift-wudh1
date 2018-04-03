//
//  WeatherLocation.swift
//  WeatherGift
//
//  Created by Dan Wu on 3/27/18.
//  Copyright © 2018 Wu. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherLocation {
    
    struct DailyForecast {
        var dailyMaxTemp: Double
        var dailyMinTemp: Double
        var dailySummary: String
        var dailyDate: Double
        var dailyIcon: String
    }
    
    var name = ""
    var coordinates = ""
    var currentTemperature = "--"
    var currentSummary = ""
    var currentIcon = ""
    var currentTime = 0.0
    var timeZone = ""
    var dailyForecastArray = [DailyForecast]()
    
    func getWeather(completed: @escaping () -> ()) {
        let weatherURL = urlBase + urlAPIKey + coordinates
        
        Alamofire.request(weatherURL).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let temperature = json["currently"]["temperature"].double {
                    let roundedTemp = String(format: "%3.f", temperature)
                    self.currentTemperature = roundedTemp + "°"
                }
                else {
                    print("Can't get temp")
                }
                if let summary = json["daily"]["summary"].string {
                    self.currentSummary = summary
                }
                else {
                    print("Can't get summary")
                }
                if let icon = json["currently"]["icon"].string {
                    self.currentIcon = icon
                }
                else {
                    print("Could not return icon")
                }
                if let timeZone = json["timezone"].string {
                    self.timeZone = timeZone
                }
                else {
                    print("Could not return timezone")
                }
                if let time = json["currently"]["time"].double {
                    self.currentTime = time
                }
                else {
                    print("Could not return time")
                }
                let dailyDataArray = json["daily"]["data"]
                self.dailyForecastArray = []
                for day in 1...dailyDataArray.count - 1 {
                    let maxTemp = json["daily"]["data"][day]["temperatureHigh"].doubleValue
                    let minTemp = json["daily"]["data"][day]["temperatureLow"].doubleValue
                    let dateValue = json["daily"]["data"][day]["time"].doubleValue
                    let icon = json["daily"]["data"][day]["icon"].stringValue
                    let dailySummary = json["daily"]["data"][day]["summary"].stringValue
                    let newDailyForecast = DailyForecast(dailyMaxTemp: maxTemp, dailyMinTemp: minTemp, dailySummary: dailySummary, dailyDate: dateValue, dailyIcon: icon)
                    self.dailyForecastArray.append(newDailyForecast)
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
