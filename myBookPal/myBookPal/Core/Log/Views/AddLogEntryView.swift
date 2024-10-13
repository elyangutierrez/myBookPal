//
//  AddLogEntryView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/13/24.
//

import SwiftUI

struct AddLogEntryView: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var page = ""
    @State private var date = Date.now
    @State private var invalidPageCount = false
    @State private var pageLessThanLastPage = false
    @State private var invalidCharacters = false
    @State private var quickNoteText = ""
    @State private var hapticsManager = HapticsManager()
    
    var checkFields: Bool {
        if page.isEmpty {
            return true
        }
        return false
    }
    
    var book: Book
    var lastPageNumber: Int?
    
    let today = Date.now
    let endOfToday = Date.now
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Log Infomation") {
                    TextField("Enter Current Page", text: $page)
                        .accessibilityLabel("Enter current page number")
                    
                    DatePicker("Datetime", selection: $date, in: today...endOfToday)
                        .accessibilityLabel("Select the date and time read")
                }
                
                Section("Quick Note (Optional)") {
                    TextField("", text: $quickNoteText, prompt: Text("Enter ideas, themes, or thoughts here..."), axis: .vertical)
//                        .lineLimit(1...5, reservesSpace: true)
                        .lineLimit(1...5)
                        .accessibilityLabel("Add a optional quick note")
                }
                
                Section {
                    Button(action: {
                        addEntry()
                    }) {
                        Text("Add")
                            .accessibilityLabel("Add Log Entry")
                    }
                    .disabled(checkFields)
                    .accessibilityAddTraits(.isButton)
                }
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
        .alert("Invalid characters", isPresented: $invalidCharacters) {
            Button("OK", action: resetFields)
        } message: {
            Text("You've entered invalid characters. Please re-enter your current page number.")
        }
        .alert("Exceeded Page Count", isPresented: $invalidPageCount) {
            Button("Ok", action: resetFields)
        } message: {
            Text("Please re-enter your current page number.")
        }
        .alert("Invalid Page Count", isPresented: $pageLessThanLastPage) {
            Button("Ok", action: resetFields)
        } message: {
            Text("You can't enter a page that is less than the last page number.")
        }
    }
    
    func addEntry() {
        
        guard page.rangeOfCharacter(from: .decimalDigits) != nil else {
            invalidCharacters.toggle()
            return
        }
        
        if let intPage = Int(page), let intBookPages = Int(book.pages) {
            
            guard let lastPage = lastPageNumber else {
                return
            }
            
            print("DEBUG: value of intPage: \(intPage)")
            print("DEBUG: value of lastPageNumber: \(lastPage)")
            
            if intPage > intBookPages {
                invalidPageCount.toggle()
                print("Ran exceed")
            } else if intPage < lastPage {
                pageLessThanLastPage.toggle()
                print("Ran less than")
            } else if quickNoteText == "" {
                let entry = Log(currentPage: page, dateLogged: date, showingNote: false)
                modelContext.insert(entry)
                hapticsManager.playAddBookLog()
                book.addLogEntry(entry)
                page = ""
                quickNoteText = ""
                dismiss()
            } else {
                let note = QuickNote(noteText: quickNoteText, date: .now)
                let entry = Log(currentPage: page, dateLogged: date, quickNote: note, showingNote: false)
                modelContext.insert(entry)
                hapticsManager.playAddBookLog()
                book.addLogEntry(entry)
                page = ""
                quickNoteText = ""
                dismiss()
            }
        } else {
            invalidPageCount = true
        }
    }
    
    func resetFields() {
        page = ""
        invalidPageCount = false
        invalidCharacters = false
        pageLessThanLastPage = false
    }
}

//#Preview {
//    AddLogEntryView(book: <#T##Book#>)
//}
