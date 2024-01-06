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
    
    @State private var touristLocationIndex = 0;
    
    
    @State private var mapCameraPosition = MapCameraPosition.camera(
        MapCamera(
            centerCoordinate:
                CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574)
            , distance: 1000.0))
    
    
    private func calculateMapCameraPosition(coordinate : CLLocationCoordinate2D){
        
        mapCameraPosition = MapCameraPosition.camera(
            MapCamera(centerCoordinate: coordinate
                      , distance: 10000.0)
        )
        
    }
    
    private func nextPlace(){
        
        if (locations.count-1 > touristLocationIndex){
            
            touristLocationIndex+=1
            
            calculateMapCameraPosition(coordinate : locations[touristLocationIndex].coordinates)
            
        }
        
    }
    
    private func prevPlace(){
        
        if (0 < touristLocationIndex){
            
            touristLocationIndex-=1
            
            calculateMapCameraPosition(coordinate : locations[touristLocationIndex].coordinates)
        }
        
    }
    
    var mapNav: some View {
        VStack{
            
            //back to central location
            Button(action: {
                
                calculateMapCameraPosition(coordinate: weatherMapViewModel.coordinates ??
                                   CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574))
                
            }, label: {
                
                Label("", systemImage: "location.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                
            }).buttonBorderShape(.circle)
                .buttonStyle(.bordered)
                .tint(.blue)
                .padding(20.0)
            
            
            //check Tourist Places
            VStack{
                Button(action: {
                    
                    nextPlace()
                    
                }, label: {
                    
                    Label("", systemImage: "arrow.up")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                }).buttonBorderShape(.circle)
                    .buttonStyle(.bordered)
                    .tint(.blue)
                
                
                
                Button(action: {
                    
                    prevPlace()
                    
                }, label: {
                    
                    Label("", systemImage: "arrow.down")
                        .font(.title)
                        .foregroundColor(.blue)
                    
                }).buttonBorderShape(.circle)
                    .buttonStyle(.bordered)
                    .tint(.blue)
                
            }.padding(20.0)
            
            
        }
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
             mapNav
            }
            
            
            //            loading
            .blur(radius: weatherMapViewModel.weatherDataModel == nil ? 10.0 : 0.0)
            if(weatherMapViewModel.weatherDataModel == nil){
                LoadingView(color: .blue).onDisappear(){
                    calculateMapCameraPosition(coordinate: weatherMapViewModel.coordinates ??
                                       CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574))
                }
            }
            
            //Places Data show
            if(isShowDetails == true && selectedLocation != nil){
                LocationDataView(locationData: selectedLocation!, isShow:$isShowDetails)
                
            }
        }
        
        
        .onAppear(){
            //filter locations
            locations = placeviewModel.locations.filter({ l in
                l.cityName == weatherMapViewModel.city
            })
            
            //set camera position
            calculateMapCameraPosition(coordinate: weatherMapViewModel.coordinates ??
                               CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574))
            
        }
        
    }
    
}

struct TouristPlacesMapView_Previews: PreviewProvider {
    static var previews: some View {
        TouristPlacesMapView().environmentObject(WeatherMapViewModel())
    }
}
