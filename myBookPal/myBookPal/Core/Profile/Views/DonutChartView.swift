//
//  DonutChartView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/11/24.
//

import Charts
import SwiftUI

struct DonutChartView: View {
    
    var totalBooksCount: Int
    var booksRead: Int
    var booksInProgress: Int
    
    var data: [(type: String, amount: Int, color: Color)] {
        [(type: "Books Read", amount: booksRead, color: Color.accent),
         (type: "In Progress", amount: booksInProgress, color: Color.complement)
        ]
    }
    
    var body: some View {
        VStack {
            Chart(data, id: \.type) { dataItem in
                SectorMark(angle: .value("Type", dataItem.amount), innerRadius: .inset(17.0), angularInset: 1.5)
                    .cornerRadius(5.0)
                    .foregroundStyle(dataItem.color)
            }
            .overlay {
                VStack {
                    Spacer()
                        .frame(height: 10)
                    Text("Total Books")
                    Text("\(totalBooksCount)")
                        .font(.system(size: 50))
                        .padding(.top, -10)
                }
            }
            .frame(height: 200)
            
            Spacer()
                .frame(height: 20)
            
            HStack {
                
                Circle()
                    .fill(Color.complement)
                    .frame(width: 25)
                
                Text("In Progress")
                
                Spacer()
                    .frame(width: 30)
                
                Circle()
                    .fill(Color.accent)
                    .frame(width: 25)
                
                Text("Books Read")
                
            }
        }
    }
}

#Preview {
    DonutChartView(totalBooksCount: 12, booksRead: 3, booksInProgress: 6)
}
