//
//  YearlyGoalsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/19/24.
//

import Combine
import SwiftUI

struct YearlyGoalsView: View {
    var books: [Book]
    
    @AppStorage("setYearlyBooks") private var setYearlyBooks = 25
    
    @State private var showAlert = false
    
    @State private var bookCountLimit = 3
    
    @State private var timeRemaining2: TimeInterval = timeRemainingInYear()
    @State private var timerSubscription2: AnyCancellable?
    
    var body: some View {
        let goals = Goals(books: books)
        let getBooks = goals.checkCompletionStatus(books)
        let _ = print(getBooks)
        let percentage = Double(getBooks) / Double(setYearlyBooks)
        
        let dateString = timeString(from: timeRemaining2)
        
        let formattedDateString = dateString.removeIfZero(dateString)
        
        VStack {
            
            Text("Next Year Starts In")
                .font(.title3.bold())
            
            Spacer()
                .frame(height: 10)
            
            Text(formattedDateString)
            
            Spacer()
                .frame(height: 80)
            
            CircularProgressView(progress: CGFloat(min(percentage, 1.0)))
            
            Spacer()
                .frame(height: 65)
            
            let formattedPercentage = min(percentage * 100, 100.0)
            Text("\(formattedPercentage, specifier: "%.2f")%")
                .font(.title.bold())
                .foregroundStyle(.black)
                .offset(x: 4, y: -180)
        }
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timerSubscription2?.cancel()
        }
        
        VStack {
            Section("Enter Yearly Book Goal") {
                Capsule()
                    .fill(.clear)
                    .frame(width: 200, height: 40)
                    .overlay {
                        Capsule()
                            .stroke(.gray.opacity(0.3), lineWidth: 2)
                        TextField("Books", value: $setYearlyBooks, format: .number)
                            .offset(x: 10)
                            .keyboardType(.decimalPad)
                            .onReceive(Just(setYearlyBooks)) { _ in limitTextField(bookCountLimit)}
                    }
            }
        }
        Spacer()
            .frame(height: 80)
        .alert("Book Count Exceeded.", isPresented: $showAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("Please enter a valid book count.")
        }
    }
    
    func limitTextField(_ upper: Int) {
        if String(setYearlyBooks).count > upper {
            showAlert = true
        }
    }
    
    func startTimer() {
        timerSubscription2 = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                timeRemaining2 = timeRemainingInYear()
            }
    }
    
    func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval) % 60
        let minutes = (Int(timeInterval) / 60) % 60
        let hours = (Int(timeInterval) / 3600) % 24
        let days = (Int(timeInterval) / 86400)
        
        return String(format: "%02d Days %02d:%02d:%02d", days, hours, minutes, seconds)
    }
}

//#Preview {
//    YearlyGoalsView()
//}
