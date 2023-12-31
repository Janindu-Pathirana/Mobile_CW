//
//  CustomTabView.swift
//  CWK2Template
//
//  Created by Janindu Pathirana on 2023-12-29.
//

import SwiftUI

struct CustomTabView: View {
    
    @Binding var tabSelection: Int
    @Namespace private var animationNamespace
    
    @State private var selectedItem = 1
    
    private let tabBarItems:
    [(title: String, image: String)] = [
        ("City", "magnifyingglass"),
        ("Forecast", "calendar"),
        ("Place Map", "map"),
    ]
    
    var body: some View {
        ZStack{
            
            Capsule()
                .frame(height: 80)
                . foregroundColor(.blue)
                .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                .blur(radius: 2)
            Capsule()
                .frame(height: 80)
                . foregroundColor(.blue)
                .opacity(0.8)
            
            let indices = Array(0..<3)
            
            HStack(spacing: 50){
                ForEach (indices,id:\.self){
                    itemIndex in
                    
                    
                    Button(action: {
                        
                        tabSelection = itemIndex+1;
                        selectedItem = itemIndex+1;
                        
                    }, label: {
                        ZStack{
                            VStack(spacing: 8){
                                
                                Image(systemName:tabBarItems[itemIndex].image )
                                Text("\(tabBarItems[itemIndex].title)")
                                
                            }
                            if(itemIndex+1 == selectedItem){
                                
                                Capsule()
                                    .frame(width: 50, height:5)
                                    .offset(y:32)
                                    .matchedGeometryEffect(id: "SelecedTabId", in: animationNamespace )
                            } else{
                                Capsule()
                                    .frame(width: 50, height:5)
                                    .offset(y:32)
                                    .opacity(0)
                            }
                        }
                        
                    }).foregroundColor(.white)
                    
                }
            }
            .padding()
            
        }
        .padding(.horizontal, 8.0)
    }
}

#Preview {
    CustomTabView(tabSelection: .constant(0))
}
