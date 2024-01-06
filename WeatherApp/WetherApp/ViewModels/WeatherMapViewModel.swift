//
//  WeatherMapViewModel.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit
class WeatherMapViewModel: ObservableObject {
    // MARK:   published variables
    @Published var weatherDataModel: WeatherDataModel?
    @Published var city = "London"
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()
    
//    private var apiKey = "527f8e659bef2fd7a375f540ff9099ce" //my
    private var apiKey = "5af3e08a792abb1819052d23d7ce242b" //sir
    
    init() {
        // MARK:  create Task to load London weather data when the app first launches
        Task {
            do {
              
                try await searchLocation(cityName: self.city)
                
            } catch {
                print("Error loading weather data: \(error)")
            }
        }
    }
    private func getCoordinatesForCity() async throws -> (CLLocationCoordinate2D,MKCoordinateRegion)? {
        do {
            
            print("Cordination getting started")
            
            let geocoder = CLGeocoder()
            let placemarks = try await geocoder.geocodeAddressString(self.city)
            
            if let location = placemarks.first?.location?.coordinate {
                
                print("Cordination done")
                return (location, MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)));
                
                
            } else {
                print("Error: Unable to find the coordinates for the city.")
            }
            
        } catch {
            print("Error: \(error)")
        }
        
        return nil
    }
    
    private func loadData(lat: Double, lon: Double) async throws{
        
        let urlString = "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=&appid=\(self.apiKey)"
       
        
        print("data fetching start")
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            do {
                let (data, _) = try await session.data(from: url)
                //                print(data)
                let weatherDataModel = try JSONDecoder().decode(WeatherDataModel.self, from: data)
                
                DispatchQueue.main.async {
                    self.weatherDataModel = weatherDataModel
                }
                
                print("data fetching done")
                
            } catch {
                
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                } else {
                    print("Error: \(error)")
                }
                throw error // Re-throw the error to the caller
            }
        } else {
            throw NetworkError.invalidURL
        }
    }
    
    enum NetworkError: Error {
        case invalidURL
    }
    
    enum LocationError: Error {
        case invalidLocationName
    }
    
    @MainActor
    func searchLocation(cityName:String) async throws  {
        
        do{
            
            self.city = cityName
            if let(cordination,region) = try await getCoordinatesForCity(){
       
                self.coordinates = cordination
                self.region = region
            
                try await loadData(lat: cordination.latitude, lon:  cordination.longitude)
                
            }
            
        }catch{
            throw NetworkError.invalidURL
        }
        
    }
    
}


