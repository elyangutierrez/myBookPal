//
//  SettingsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/9/24.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    let numbersArray = Array(1...80)
    
    var getNumbers: [Int] {
        var numbersHolder = [Int]()
        for number in numbersArray {
            if number % 5 == 0 {
                numbersHolder.append(number)
            }
        }
        return numbersHolder
    }
    
    @State private var deletedBooksAlert = false
    @Binding var setBookTotal: Int
    
    @Binding var getBookTotal: Int
    
    var body: some View {
        NavigationStack {
            Form {
//                Section("Set Book Goal") {
//                    TextField("Enter Goal", value: $setBookTotal, format: .number)
//                }
                Section {
                    Picker("Annual Book Goal", selection: $setBookTotal) {
                        ForEach(getNumbers, id: \.self) { number in
                            Text("\(number)")
                        }
                    }
                    HStack {
                        let percentage = Double(getBookTotal) / Double(setBookTotal)
                        
                        let formattedPercentage = Int(percentage * 100)
                        
                        ProgressView(value: percentage)
                            .tint(getBookTotal >= setBookTotal ? .green : .blue)
                        if getBookTotal >= setBookTotal {
                            Text("100%")
                                .font(.subheadline)
                                .foregroundStyle(.black)
                        } else {
                            Text("\(formattedPercentage)")
                                .font(.subheadline)
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(.bottom, 10)
                }
                .listRowSeparator(.hidden)
                
                Button(action: {
                    deleteAllBooks()
                }) {
                    Text("Delete All Books")
                        .foregroundStyle(.red)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Exit")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .alert(isPresented: $deletedBooksAlert) {
            Alert(title: Text("Are you sure you want to delete all books?"), message: Text("Once deleted, you can't get your books and logs back."), primaryButton: .destructive(Text("Delete")), secondaryButton: .cancel())
        }
    }
    
    func deleteAllBooks() {
        do {
            try modelContext.delete(model: Book.self)
            deletedBooksAlert = true
        } catch {
            print("Failed to delete books")
        }
    }
    
    func resetAlert() {
        deletedBooksAlert = false
    }
}

#Preview {
    SettingsView(setBookTotal: .constant(10), getBookTotal: .constant(15))
}
