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
    
    var body: some View {
        let goals = Goals(books: books)
        //        let getBooks = goals.getTotalBookCount(books)
        let getBooks = goals.checkCompletionStatus(books)
        let _ = print(getBooks)
        
        let percentage = Double(getBooks) / Double(setYearlyBooks)
        
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
            Section("Enter Yearly Book Goal") {
                Capsule()
                    .fill(.clear)
                    .frame(width: 200, height: 40)
                    .overlay {
                        Capsule()
                            .stroke(.gray.opacity(0.3), lineWidth: 2)
                        TextField("Books", value: $setYearlyBooks, format: .number)
                            .offset(x: 10)
                            .onReceive(Just(setYearlyBooks)) { _ in limitTextField(bookCountLimit)}
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
        if String(setYearlyBooks).count > upper {
            showAlert = true
        }
    }
}

//#Preview {
//    YearlyGoalsView()
//}
