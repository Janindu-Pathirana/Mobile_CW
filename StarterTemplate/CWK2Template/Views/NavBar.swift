//
//  NavBar.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI



struct NavBar: View {
    
    @State private var tabSelection = 1
    
    var body: some View {
        
        TabView(selection: $tabSelection) {
            
            WeatherNowView().tag(1)
            
            WeatherForecastView().tag(2)
            
            TouristPlacesMapView().tag(3)
            
        }
        .overlay(alignment:.bottom){
            CustomTabView(tabSelection: $tabSelection)
        }
        
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar().environmentObject(WeatherMapViewModel())
    }
}
