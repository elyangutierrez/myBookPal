//
//  MonthlyGoalsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/19/24.
//

import Combine
import SwiftUI

struct MonthlyGoalsView: View {
    var books: [Book]
    
    @AppStorage("setMonthlyBooks") private var setMonthlyBooks = 2
    
    @State private var showAlert = false
    
    @State private var bookCountLimit = 2
    
    var body: some View {
        let goals = Goals(books: books)
//        let getBooks = goals.getTotalBookCount(books)
        let getBooks = goals.checkCompletionStatus(books)
        let _ = print(getBooks)
        
        let percentage = Double(getBooks) / Double(setMonthlyBooks)
        
        VStack {
            CircularProgressView(progress: CGFloat(min(percentage, 1.0)))
            
            Spacer()
                .frame(height: 75)
            
            let formattedPercentage = min(percentage * 100, 100.0)
            Text("\(formattedPercentage, specifier: "%.2f")%")
                .font(.title.bold())
                .foregroundStyle(.black)
                .offset(x: 4, y: -190)
        }
        
        VStack {
            Section("Enter Monthly Book Goal") {
                Capsule()
                    .fill(.clear)
                    .frame(width: 200, height: 40)
                    .overlay {
                        Capsule()
                            .stroke(.gray.opacity(0.3), lineWidth: 2)
                        TextField("Books", value: $setMonthlyBooks, format: .number)
                            .offset(x: 10)
                            .onReceive(Just(setMonthlyBooks)) { _ in limitTextField(bookCountLimit)}
                    }
            }
        }
        Spacer()
        
        .alert("Book Count Exceeded.", isPresented: $showAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("Please enter a valid book count.")
        }
    }
    
    func limitTextField(_ upper: Int) {
        if String(setMonthlyBooks).count > upper {
            showAlert = true
        }
    }
}


//#Preview {
//    MonthlyGoalsView()
//}
