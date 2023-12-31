//
//  TempConverterUtill.swift
//  CWK2Template
//
//  Created by Janindu Pathirana on 2023-12-28.
//

import Foundation


class TempConverterUtill {
    
    static func kelvinToCelsius(kelvin:Double) -> Double{
        let celsius = kelvin - 273.15
            let roundedCelsius = String(format: "%.1f", celsius)
            return Double(roundedCelsius)!      }
    
   
}
