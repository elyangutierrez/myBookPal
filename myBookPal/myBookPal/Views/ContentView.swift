//
//  ContentView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/8/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var toggleSettingsView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("This is the content view!")
            }
            .navigationTitle("myBookPal")
            .searchable(text: $searchText)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        toggleSettingsView.toggle()
                    }) {
                        Image(systemName: "gearshape")
                            .tint(.black)
                    }
                }
            }
            .fullScreenCover(isPresented: $toggleSettingsView) {
                SettingsView()
            }
        }
    }
    
    func fetchData() {
        print("This has been called!")
    }
}

#Preview {
    ContentView()
}
