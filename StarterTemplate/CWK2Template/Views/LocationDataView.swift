//
//  LocationDataView.swift
//  CWK2Template
//
//  Created by Janindu Pathirana on 2023-12-29.
//

import SwiftUI

struct LocationDataView: View {
    
    var locationData:Location
    
    @State var selectedImageIndex = 0;
    
    
    private func nextImage(){
        
        if selectedImageIndex < locationData.imageNames.count-1{
            selectedImageIndex+=1
        }
        
    }
    
    private func preImage(){
        
        if selectedImageIndex>0{
            selectedImageIndex-=1;
        }
        
    }
    
    var body: some View {
        ZStack{
            
            
            //background
            RoundedRectangle(cornerRadius: 30)
            
                .fill(.blue.opacity(0.6))
                .blur(radius: 6)
                .frame( minHeight:200, maxHeight: 500 )
            
            VStack{
                

                HStack{
                    //navigation
                    Label("", systemImage: "arrow.backward.circle")
                        .foregroundColor(.white)
                        .font(.largeTitle).onTapGesture {
                            preImage()
                        }
                    
                    Image(locationData.imageNames[selectedImageIndex])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(.all, 8.0)
                        .frame(minWidth: 50, maxWidth: .infinity, minHeight: 50)
                    
                    //navigation
                    Label("", systemImage: "arrow.forward.circle")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .onTapGesture {
                            nextImage()
                        }
                    
                } .padding(.horizontal, 10.0)
                
                
                
                Text("\(locationData.name)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                Text("\(locationData.cityName)")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                
                
                
                Text("\(locationData.description)")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(Color.white)
                    .padding()
                    .multilineTextAlignment(.center)
                    
                
                Spacer()
                
                //link
                Link("More Info", destination: URL(string: "\(locationData.link)")!)
                    .tint(.white)
                    .underline(true)
                    .padding()

            }
            .frame( minHeight:200, maxHeight: 500 )

        }.onAppear(){
            print("hi")
        }
    }
}

