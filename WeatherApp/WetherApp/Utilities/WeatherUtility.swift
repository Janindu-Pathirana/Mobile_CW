//
//  WeatherUtility.swift
//  CWK2Template
//
//  Created by Janindu Pathirana on 2023-12-28.
//

import Foundation

class WeatherUtility{
    
    static func getWetherImage(type: Main)->String{
        
//        var type : Main = Main(rawValue: typeString) ?? .clear
        
        var image = "sun-cloud"
        
        switch type {
        case .clear:
            image = "sun"
        case .clouds:
            image = "sun-cloud"
        case .rain:
            image = "rain"
        case .mist:
            image = "sun-cloud"
        case .smoke:
            image = "sun-cloud"
        case .haze:
            image = "sun-cloud"
        case .dust:
            image = "sun-cloud"
        case .fog:
            image = "sun-cloud"
        case .sand:
            image = "sun-cloud"
        case .ash:
            image = "sun-cloud"
        case .squall:
            image = "thunderstorm-rain"
        case .tornado:
            image = "thunderstorm-rain"
        case .snow:
            image = "snow-cloud"
        case .drizzle:
            image = "rain3"
        case .thunderstorm:
            image = "thunderstorm-rain"
        }
        
        
        return image
    }
}
