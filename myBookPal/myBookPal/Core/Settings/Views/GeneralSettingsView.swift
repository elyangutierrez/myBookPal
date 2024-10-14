//
//  GeneralSettingsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/13/24.
//

import ConfettiSwiftUI
import SwiftUI

struct Item: Hashable {
    var imageName: String
    var color: String
    var title: String
}

struct GeneralSettingsView: View {
    @State private var showSettings = false
    @State private var showStatistics = false
    @State private var showNotifications = false
    @State private var showSupport = false
    @State private var didAppear = false
    @State private var activateTipSheet = false
    @State private var tipPurchased = false
    @State private var confettiCounter = 0
    @State private var showThankYouView = false
    @State private var hapticManager = HapticsManager()
    @State private var showMailComposer = false
    
    let items = [Item(imageName: "gearshape", color: ".gray", title: "General"),
                 Item(imageName: "chart.bar.xaxis", color: ".blue", title: "Statistics")]
    
    var books: [Book]
    
    var getDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: Date.now)
    }
    
    var getTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        return dateFormatter.string(from: Date.now)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    List(items, id: \.self) { item in
                        NavigationLink(destination: destinationView(for: item.title)) {
                            HStack {
                                let properColor = getColor(colorString: item.color)
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(properColor)
                                    .frame(width: 30, height: 30)
                                    .overlay {
                                        Image(systemName: item.imageName)
                                            .foregroundStyle(.white)
                                    }
                                
                                Spacer()
                                    .frame(width: 15)
                                
                                Text(item.title)
                            }
                        }
                    }
                }
                
                Section {
                    
                    Button(action: {
                        if MailComposer.isAvaliable() {
                            showMailComposer.toggle()
                        }
                    }) {
                        HStack {
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(.red)
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "questionmark")
                                        .foregroundStyle(.white)
                                }
                            
                            Spacer()
                                .frame(width: 15)
                            
                            Text("Help")
                                .foregroundStyle(.black)
                        }
                    }
                    
                    
                    
                    Button(action: {
                        activateTipSheet.toggle()
                    }) {
                        HStack {
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(.green )
                                .frame(width: 30, height: 30)
                                .overlay {
                                    Image(systemName: "dollarsign")
                                        .foregroundStyle(.white)
                                }
                            
                            Spacer()
                                .frame(width: 15)
                            
                            Text("Donate")
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: confettiCounter) {
                if confettiCounter > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        confettiCounter = 0
                        let _ = print("Setting confetti counter to 0")
                    }
                }
            }
            .onChange(of: tipPurchased) {
                if tipPurchased {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.spring) {
                            showThankYouView.toggle()
                        }
                    }
                }
            }
            .overlay {
                if showThankYouView && !activateTipSheet {
                    VStack {
                        RoundedRectangle(cornerRadius: 15.0)
                            .stroke(.gray.opacity(0.20), lineWidth: 1.5)
                            .fill(.white)
                            .frame(width: 250, height: 170)
                            .shadow(color: .gray.opacity(0.20), radius: 5)
                            .overlay {
                                VStack {
                                    Text("Thank you! 🎉")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    
                                    Spacer()
                                        .frame(height: 15)
                                    
                                    Text("Thank you for tipping! Your support is appreciated.")
                                    
                                    Spacer()
                                        .frame(height: 15)
                                    
                                    HStack {
                                        Text("-")
                                        
                                        Text("Elyan")
                                            .fontWeight(.semibold)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                                    confettiCounter = 1
                                    hapticManager.playDonated()
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4.8) {
                                    withAnimation(.smooth(duration: 0.2)) {
                                        showThankYouView.toggle()
                                        tipPurchased.toggle()
                                    }
                                }
                            }
                    }
                    .transition(.move(edge: .bottom))
                    .confettiCannon(counter: $confettiCounter)
                }

            }
            .sheet(isPresented: $activateTipSheet) {
                TipSheetView(isPresented: $activateTipSheet, tipPurchased: $tipPurchased)
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showMailComposer) {
                MailComposer(dateCreated: getDate, timeCreated: getTime)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Settings")
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                }
            }
        }
    }
    
    func getColor(colorString: String) -> Color {
        switch colorString {
        case ".gray":
            return .gray
        case ".green":
            return .green
        case ".red":
            return .red
        case ".blue":
            return .blue
        default:
            return .clear
        }
    }
    
    // This function returns the appropriate view based on the item title
        @ViewBuilder
        func destinationView(for title: String) -> some View {
            switch title {
            case "General":
                SettingsView(books: books) // Replace with your actual Settings view
            case "Statistics":
                StatisticsView(books: books) // Replace with your actual Statistics view, passing data if needed
            case "Help":
                MailComposer(dateCreated: getDate, timeCreated: getTime)
            default:
                Text("Coming Soon") // Placeholder for unhandled cases
            }
        }
}

#Preview {
    GeneralSettingsView(books: [Book]())
}
