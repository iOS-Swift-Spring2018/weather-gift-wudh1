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
    var name = ""
    var coordinates = ""
    var currentTemperature = "--"
    
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
                    print("Could not return")
                }
            case .failure(let error):
                print(error)
            }
            completed()
        }
    }
}
