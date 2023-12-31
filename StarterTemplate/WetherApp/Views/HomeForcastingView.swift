//
//  HomeForcastingView.swift
//  CWK2Template
//
//  Created by Janindu Pathirana on 2023-12-27.
//

import SwiftUI

struct HomeForcastingView: View {
    
    var text: String
    var temp: Double
    var image:String
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20)
            
                .fill(LinearGradient(
                    gradient: Gradient(colors: [
                        .white.opacity(0.1),
                        .white.opacity(0.3)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .padding([.top, .bottom, .trailing],15)
                .frame(minWidth: 150, maxWidth: 200)
            
            VStack{
                Text(text)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20.0)
                
                Spacer()
                
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(.all, 10.0)
                    .frame(minWidth: 50, maxWidth: 100, minHeight: 50, maxHeight:110,alignment:.center)
                
                
                Text("\(String(format: "%.1f", temp))°" )
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Spacer()
                
                
            }
            .padding(.vertical, 20.0)
            
        }
    }
}

#Preview {
    HomeForcastingView(text: "Today", temp: 24, image: "sun-cloud")
}
