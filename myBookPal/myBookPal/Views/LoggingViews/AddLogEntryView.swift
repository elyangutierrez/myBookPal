//
//  AddLogEntryView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/13/24.
//

import SwiftUI

struct AddLogEntryView: View {
    @State private var page = ""
    @State private var date = Date.now
    
    var checkFields: Bool {
        if page.isEmpty {
            return true
        }
        return false
    }
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var book: Book
    
    @State private var invalidPageCount = false
    
    let today = Date.now
    let endOfToday = Date.now
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter Current Page", text: $page)
                
                DatePicker("Datetime", selection: $date, in: today...endOfToday)
                
                Button(action: {
                    addEntry()
                }) {
                    Text("Add")
                }
                .disabled(checkFields)
            }
            .navigationTitle("Add Log Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
        .alert("Exceeded Page Count", isPresented: $invalidPageCount) {
            Button("Ok", action: resetFields)
        } message: {
            Text("Please re-enter your current page number.")
        }
    }
    
    func addEntry() {
        if let intPage = Int(page), let intBookPages = Int(book.pages) {
            if intPage > intBookPages {
                invalidPageCount = true
            } else {
                let entry = Log(currentPage: page, dateLogged: date)
                book.addLogEntry(entry)
                page = ""
                dismiss()
            }
        } else {
            invalidPageCount = true
        }
    }
    
    func resetFields() {
        invalidPageCount = false
    }
}

//#Preview {
//    AddLogEntryView(book: <#T##Book#>)
//}
