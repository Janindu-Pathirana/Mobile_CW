//
//  WeatherNowView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI


struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State private var isLoading = false
    @State private var temporaryCity = ""
    @State private var cityName = ""
    
    
    
    func getCurrentDate()->String{
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM"
        let formattedDate = formatter.string(from: now)
        
        return formattedDate
    }
    
    //genarate borrom card in one row
    func genarateForcastingCards(wetherData:[Daily].SubSequence)-> some View{
        
        var forcastingCards: some View {
            HStack{
                
                ForEach(wetherData){data in
                    
                    if(
                        DateFormatterUtils.formattedDate(from: data.dt, format: "dd-MM")
                        ==
                        getCurrentDate()
                      
                    ){
                        
                        HomeForcastingView(
                            text: "Today",
                            temp: TempConverterUtill.kelvinToCelsius(kelvin: data.temp.day ),
                            image: WeatherUtility.getWetherImage(type: data.weather.first?.main ?? .clear))
                    }
                    
                    else{
                        HomeForcastingView(
                            text: "\(DateFormatterUtils.formattedDate(from: data.dt, format: "dd/MM"))",
                            temp: TempConverterUtill.kelvinToCelsius(kelvin: data.temp.day ),
                            image: WeatherUtility.getWetherImage(type: data.weather.first?.main ?? .clear))
                    }
                    
                }
                
                
            }.padding(.horizontal)
        }
        
        return forcastingCards;
        
    }
    
    //genarate borrom forcasting rows
    func genarateForcastingRows(perRow:Int, rowCount:Int) -> some View{
        
        var rows: some View {
            VStack{
                if let wetherData = weatherMapViewModel.weatherDataModel?.daily{
                    
                    ScrollView{
                        let indices = Array(1..<rowCount+1)
                        ForEach(indices, id: \.self){ i in
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
                                
                                
                                ScrollView(.horizontal){
                                    let range = i * perRow
                                    let start = (i-1) * perRow
                                    genarateForcastingCards(wetherData: wetherData[start..<range])
                                    
                                }
                                
                                
                            }
                            .frame(minHeight: 200, maxHeight: 300)
                            .padding(.bottom, 10.0)
                         
                        }
                       
                    }
                }
            }
        }
        
        
        return rows;
    }
    
    var forcasting: some View {
        
        //bottom forcasting
        
        VStack(alignment: .leading){
            Text("Forcasting")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
            
            genarateForcastingRows(perRow: 4,rowCount:2)
            
            
        }.padding(.all, 15.0)
        
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
  
          
            VStack(alignment: .leading){
                
                //search bar
                HStack(alignment: .top){
                    TextField("", text: $cityName)
                    
                        .font(.title3)
                        .padding(8)
                        .foregroundColor(.white)
                        .accentColor(.white)
                        .overlay(
                            cityName.isEmpty ? Text("Enter City name")
                                .padding(8)
                                .font(.title3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundColor(.white)
                            : nil
                        )
                    
                    Spacer()
                    
                    Button(action: {
                        Task{
                            do{
                                isLoading = true
                                
                                try await weatherMapViewModel.searchLocation(cityName: cityName)
                                
                                isLoading = false
                            }catch{
                                print("error")
                            }
                        }
                        
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                        
                    }
                }.padding([.top, .leading, .trailing], 20.0)
                
                
                //date time
                VStack{
                    let timestamp = TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0)

                     let formattedDate = DateFormatterUtils.formattedDateTime(from: timestamp)
                                     Text(formattedDate)
                                         .padding()
                                         .font(.title)
                                         .foregroundColor(.white)
                                         
                }
                
                //top wether details
                HStack{
                    
                    let currentData = weatherMapViewModel.weatherDataModel?.current
                    
                    Image(WeatherUtility.getWetherImage(type: currentData?.weather.first?.main ?? .clouds))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200.0, height: 200.0)
                        .padding(.leading,-50)
                    
                    Spacer()
                    
                    VStack(alignment: .center){
                        Text("\(TempConverterUtill.kelvinToCelsius(kelvin: currentData?.temp ?? 0.0)  )"+"°")
                            .font(.custom("Helvetica Neue", size: 60))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                        Text(currentData?.weather.first?.weatherDescription.rawValue ?? "")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.white)
                        
                        Text("feels Like \(TempConverterUtill.kelvinToCelsius(kelvin: currentData?.feelsLike ?? 0.0)  )"+"°")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Text("Pressure \( currentData?.pressure ?? 0) hpa")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Text("Wind \( String(format: "%.1f", currentData?.windSpeed ?? 0) ) mph")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        Text("Humidity \( currentData?.humidity ?? 0 ) %")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                        
                    }.frame(width: 200)
                    
                }
                
                forcasting
                Spacer()
                
            }
            
            //loading screen
            .blur(radius: (isLoading || weatherMapViewModel.weatherDataModel == nil) ? 10.0 : 0.0)
            if((isLoading || weatherMapViewModel.weatherDataModel == nil)){
                LoadingView()
            }
            
            
        }
        .frame(width: nil)
        .onAppear(){
            cityName = weatherMapViewModel.city;

        }
        
    }
}



struct WeatherNowView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherNowView().environmentObject(WeatherMapViewModel())
    }
}
