//
//  TouristPlacesMapView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import Foundation
import SwiftUI
import CoreLocation
import MapKit


struct TouristPlacesMapView: View {
    @EnvironmentObject private var weatherMapViewModel: WeatherMapViewModel
    @StateObject private var placeviewModel = PlacesViewModel()
    
    @State private var locations: [Location] = []
    @State private var selectedLocation :Location? = nil
    @State private var isShowDetails = false
    @State private var  mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574), latitudinalMeters: 600, longitudinalMeters: 600)

    var body: some View {
        
        ZStack{

            //map
            Map(){
                
                //searched Location pin
                
                if let coordinates = weatherMapViewModel.coordinates{
                    Annotation(weatherMapViewModel.city,coordinate:  coordinates){
                        Label("", systemImage: "pin.fill")
                            .font(.title2)
                            .foregroundStyle(.red)
                    }
                }
                
                //placess pins
                ForEach(locations){
                    location in
                    
                    Annotation( location.name, coordinate: location.coordinates) {
                        
                        Image(location.imageNames.first ??  "mappin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.leading, 15.0)
                            .frame(width: 90, height: 90)
                            .onTapGesture {
                                
                                print("tapped")
                                isShowDetails = true
                                selectedLocation = location
                                
                                
                                print(isShowDetails == true && selectedLocation != nil)
                            }
                        
                    }
                }
            }
            .mapControlVisibility(.visible)
            .onTapGesture {
                isShowDetails = false;
            }
          
            
            //            loading
            .blur(radius: weatherMapViewModel.weatherDataModel == nil ? 10.0 : 0.0)
            if(weatherMapViewModel.weatherDataModel == nil){
                LoadingView(color: .blue).onDisappear(){
                    if let data = weatherMapViewModel.weatherDataModel{
                        mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: data.lat, longitude: data.lon), latitudinalMeters: 600, longitudinalMeters: 600)
                    }
                }
            }
            
            //Places Data
            if(isShowDetails == true && selectedLocation != nil){
                LocationDataView(locationData: selectedLocation!)
                    .padding(.horizontal, 20.0)
            }
        }
        
        
        .onAppear(){
            locations = placeviewModel.locations.filter({ l in
                l.cityName == weatherMapViewModel.city
            })
        }
        

    }
    
}

struct TouristPlacesMapView_Previews: PreviewProvider {
    static var previews: some View {
        TouristPlacesMapView().environmentObject(WeatherMapViewModel())
    }
}
