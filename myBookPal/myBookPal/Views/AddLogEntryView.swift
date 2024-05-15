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
    }
    
    func addEntry() {
        let entry = Log(currentPage: page, dateLogged: date)
        book.addLogEntry(entry)
        
        print("The entry was added to: \(book.title)")
        print("The amount of logs in \(book.title) is \(book.logs)")
        page = ""
        dismiss()
    }
}

//#Preview {
//    AddLogEntryView(book: <#T##Book#>)
//}
