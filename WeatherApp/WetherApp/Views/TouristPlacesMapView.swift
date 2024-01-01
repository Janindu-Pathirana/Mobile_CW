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
    @State private var isShowDetails = false;
    
    @State private var mapCameraPosition = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate:
                CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574)
            , distance: 1000.0))
    
    
    private func calculateMapCamera(){
        
        mapCameraPosition = MapCameraPosition.camera(
            MapCamera(centerCoordinate: weatherMapViewModel.coordinates ??
                      CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574)
                      , distance: 10000.0)
        )
        
    }
    
    var body: some View {
        
        ZStack{
            
            //map
            Map(
                position: $mapCameraPosition
            ){
                
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
                                
                                isShowDetails = true
                                selectedLocation = location
                                
                            }
                    }
                }
            }
            .mapControlVisibility(.visible)
            .overlay(alignment:.topTrailing){
                
                Button(action: {
                    
                    calculateMapCamera()
                    
                }, label: {
                    
                    Label("", systemImage: "location.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                }).buttonBorderShape(.circle)
                    .buttonStyle(.bordered)
                    .tint(.blue)
                    .padding(20.0)
                
            }
            
            
            //            loading
            .blur(radius: weatherMapViewModel.weatherDataModel == nil ? 10.0 : 0.0)
            if(weatherMapViewModel.weatherDataModel == nil){
                LoadingView(color: .blue).onDisappear(){
                    calculateMapCamera();
                }
            }
            
            //Places Data
            if(isShowDetails == true && selectedLocation != nil){
                LocationDataView(locationData: selectedLocation!, isShow:$isShowDetails)
                
            }
        }
        
        
        .onAppear(){
            locations = placeviewModel.locations.filter({ l in
                l.cityName == weatherMapViewModel.city
            })
            calculateMapCamera()
        }
        
        
    }
    
}

struct TouristPlacesMapView_Previews: PreviewProvider {
    static var previews: some View {
        TouristPlacesMapView().environmentObject(WeatherMapViewModel())
    }
}
