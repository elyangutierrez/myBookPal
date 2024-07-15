//
//  myBookPalApp.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/8/24.
//

import SwiftData
import SwiftUI
import Observation

@main
struct myBookPalApp: App {
    @State private var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(networkMonitor)
        }
        .modelContainer(for: Book.self)
    }
}
