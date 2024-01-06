//
//  WeatherForcastView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI


enum durations: String, CaseIterable, Codable{
    case daily = "Daily"
    case hourly = "Hourly";
}

struct WeatherForecastView: View {
    @EnvironmentObject private var weatherMapViewModel: WeatherMapViewModel
    
    @State private var selectedDuration : durations = .daily
    
    
    var showData: some View {
        
        // forcasting Data
        
        VStack{
            
            if(selectedDuration == .daily){
                
                //daily forcasting
                if let dailyData = weatherMapViewModel.weatherDataModel?.daily {
                    ForEach(dailyData, id: \.id) { data in
                        ForcastingLableView(
                            lable:"Date",
                            dateTime: DateFormatterUtils.formattedDate(from: data.dt, format: "dd-MM-yy"),
                            temp: TempConverterUtill.kelvinToCelsius(kelvin: data.temp.day),
                            image: WeatherUtility.getWetherImage(type: data.weather.first?.main ?? .clear))
                    }
                } 
                else {
                    Text("No Daily data available")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
                
                
                
                
            }else{
                
                //Hourly forcasting
                if let hourlyData = weatherMapViewModel.weatherDataModel?.hourly {
                    ForEach(hourlyData, id: \.id) { data in
                        ForcastingLableView(
                            lable: "Hour",
                            dateTime: DateFormatterUtils.formattedDate(from: data.dt, format: "HH:mm"),
                            temp: TempConverterUtill.kelvinToCelsius(kelvin: data.temp),
                            image: WeatherUtility.getWetherImage(type: data.weather.first?.main ?? .clear)
                        )
                    }
                } 
                else {
                    Text("No hourly data available")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
            }
            
        }
    }
    
    var body: some View {
        
        ZStack{
            //background
            Rectangle().fill(LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.23, green: 0.75, blue: 0.95),
                    Color(red: 0.0, green: 0.34, blue: 0.84)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .ignoresSafeArea()
            
            VStack{
                //hedding
                VStack(alignment:.leading){
                    Text("Wether Forcasting")
                        .font(.title)
                        .fontWeight(.medium)
                        .foregroundColor(Color.white)
                    
                    
                    HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/){
                        Label("", systemImage: "mappin.and.ellipse")  // Location icon
                            .foregroundColor(.white)  // Optional: Set color
                            .font(.title)
                        
                        Text("\(weatherMapViewModel.city)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                    
                }
                Spacer()
                
                //picker
                Picker("Select Duration", selection: $selectedDuration) {
                    ForEach(durations.allCases, id: \.self) { duration in
                        Text(duration.rawValue).tag(duration)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                
                //forcasting view
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [
                                .white.opacity(0.1),
                                .white.opacity(0.3)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                        .padding(.all, 15.0)
                    
                    ScrollView{
                        VStack{
                            
                            showData
                            
                        }
                        
                    }
                    .padding()
                    
                }
            }
            
            
            //loading
            .blur(radius: weatherMapViewModel.weatherDataModel == nil ? 10.0 : 0.0)
            if((weatherMapViewModel.weatherDataModel) == nil){
                LoadingView()
            }
            
        }
        
    }
}

struct WeatherForcastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView().environmentObject(WeatherMapViewModel())
    }
}

