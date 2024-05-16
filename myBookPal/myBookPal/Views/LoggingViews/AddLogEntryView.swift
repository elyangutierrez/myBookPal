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
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Enter Current Page", text: $page)
                
                DatePicker("Datetime", selection: $date)
                
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
        if page > book.pages {
            invalidPageCount = true
        } else {
            let entry = Log(currentPage: page, dateLogged: date)
            book.addLogEntry(entry)
            
            print("The entry was added to: \(book.title)")
            print("The amount of logs in \(book.title) is \(book.logs)")
            page = ""
            dismiss()
        }
    }
    
    func resetFields() {
        invalidPageCount = false
    }
}

//#Preview {
//    AddLogEntryView(book: <#T##Book#>)
//}
