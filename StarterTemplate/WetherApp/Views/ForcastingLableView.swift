//
//  ForcastingLableView.swift
//  CWK2Template
//
//  Created by Janindu Pathirana on 2023-12-27.
//

import SwiftUI

struct ForcastingLableView: View {
    
    var lable:String
    var dateTime: String
    var temp:Double
    var image:String
    
    var body: some View {
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
                .frame(height: 100.0)
                
            
            HStack(alignment: .center){
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    
                    .padding(.leading, 15.0)
                    .frame(width: 90, height: 90)
                Spacer()
                
                Text("\(String(format: "%.1f", temp))°" )
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                Spacer()
                
                VStack{
                    Text("\(lable)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    Text("\(dateTime)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
                .padding(.trailing, 15.0)
                    
            }
        }.padding([.top, .leading, .trailing], 10.0)
        
    }
}

#Preview {
    ForcastingLableView(lable:"Date", dateTime: "Today", temp: 24, image: "sun-cloud")
}
