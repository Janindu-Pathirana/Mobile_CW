//
//  PlacesViewModel.swift
//  CWK2Template
//
//  Created by Janindu Pathirana on 2023-12-29.
//

import SwiftUI
import CoreLocation

class PlacesViewModel: ObservableObject {
    @Published var locations: [Location] = []

    init() {
        loadData()
    }

    func loadData() {
        if let url = Bundle.main.url(forResource: "places", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                locations = try decoder.decode([Location].self, from: data)
            } catch {
                print("Error loading places data: \(error)")
            }
        }
    }
}
