//
//  LoadingView.swift
//  CWK2Template
//
//  Created by Janindu Pathirana on 2023-12-29.
//

import SwiftUI

struct LoadingView: View {
    
    var color:Color? = nil
    
    var body: some View {
        ZStack{
            Rectangle().opacity(0.0)
                .ignoresSafeArea()
            
            ProgressView("Loading...")
                .font(.headline)
                .progressViewStyle(CircularProgressViewStyle())
                .tint(color ?? .white)
        }.foregroundColor(color ?? .white)
    }
}

#Preview {
    LoadingView()
}
