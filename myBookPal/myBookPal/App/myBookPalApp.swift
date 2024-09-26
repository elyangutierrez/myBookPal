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
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .black
    }
    
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .environment(networkMonitor)
        }
        .modelContainer(for: [Book.self, QuickNote.self, Log.self, Goal.self])
    }
}
