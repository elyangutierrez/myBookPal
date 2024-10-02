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
    @State private var tagsTextArray = [Tag]()
    @State private var pageLessThanLastPage = false
    @State private var quickNoteText = ""
    @State private var maxCharacterCount = 125
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
                
                Section {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15.0)
                            .fill(.white)
                            .frame(width: 360, height: 250)
                        VStack {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text("Tags")
                                        .font(.system(size: 15))
                                        .fontWeight(.bold)
                                    Spacer()
                                        .frame(width: 5)
                                    Text("(Optional)")
                                        .font(.system(size: 15))
                                        .foregroundStyle(.gray)
                                        .fontWeight(.semibold)
                                }
                                
                                if !tagsTextArray.isEmpty {
                                    VStack(alignment: .leading) {
                                        Spacer()
                                            .frame(height: 10)
                                        
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack {
                                                ForEach(tagsTextArray, id: \.self) { tag in
                                                    HStack {
                                                        Text("\(tag.text)")
                                                            .font(.system(size: 13))
                                                            .fontWeight(.bold)
                                                            .foregroundStyle(.white)
                                                            .padding(.vertical, 5)
                                                            .padding(.horizontal, 7)
                                                            .onTapGesture {
                                                                withAnimation(.bouncy(duration: 0.2, extraBounce: 0.05)) {
                                                                    if let index = tagsTextArray.firstIndex(of: tag) {
                                                                        tagsTextArray.remove(at: index)
                                                                    }
                                                                }
                                                            }
                                                        
                                                        Circle()
                                                            .fill(.white)
                                                            .frame(width: 15, height: 15)
                                                            .overlay {
                                                                Image(systemName: "xmark")
                                                                    .resizable()
                                                                    .foregroundStyle(.black)
                                                                    .frame(width: 7, height: 7)
                                                            }
                                                            .offset(x: -7)
                                                        
                                                    }
                                                    .background(
                                                        RoundedRectangle(cornerRadius: 15.0)
                                                            .fill(Color.accent)
                                                    )
                                                    
                                                    Spacer()
                                                        .frame(width: 10)
                                                }
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .padding(.horizontal, 5)
                                }
                                
                                Spacer()
                                    .frame(height: 5)
                                
                                Text("Max: 3")
                                    .font(.system(size: 15))
                                    .fontWeight(.bold)
                                    .foregroundStyle(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .accessibilityHint("Select up to 3 optional tags to express the emotions that the story evokes.")
                            .padding(.horizontal, 25)
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15.0)
                                    .fill(.gray.opacity(0.20))
                                    .frame(width: 330, height: 200)
                                
                                VStack {
                                    VStack {
                                        RowOneView(textOne: "Unexpected", textTwo: "Cliffhanger", textThree: "Revelation", textFour: "Dramatic", tagArray: $tagsTextArray)
                                    }
                                    
                                    Spacer()
                                        .frame(height: 15)
                                    
                                    VStack {
                                        RowTwoView(textOne: "Suspenseful", textTwo: "Intense", textThree: "Controversial", textFour: "Heartwarming", tagArray: $tagsTextArray)
                                    }
                                    
                                    Spacer()
                                        .frame(height: 15)
                                    
                                    VStack {
                                        RowThreeView(textOne: "Mysterious", textTwo: "Action-Packed", textThree: "Heartbreaking", tagArray: $tagsTextArray)
                                    }
                                    
                                    Spacer()
                                        .frame(height: 15)
                                    
                                    VStack {
                                        RowFourView(textOne: "Thought-Provoking", textTwo: "Plot-Twist", tagArray: $tagsTextArray)
                                    }
                                }
                                .padding(.horizontal, 25)
                            }
                        }
                    }
                }
                
                Section("Quick Note") {
                    TextField("", text: $quickNoteText, prompt: Text("Enter ideas, themes, or thoughts here..."), axis: .vertical)
                        .lineLimit(2, reservesSpace: true)
                        .onChange(of: quickNoteText) {
                            quickNoteText = String(quickNoteText.prefix(maxCharacterCount))
                        }
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
        if let intPage = Int(page), let intBookPages = Int(book.pages) {
            
            guard let lastPage = lastPageNumber else {
                return
            }
            
            print("DEBUG: value of intPage: \(intPage)")
            print("DEBUG: value of lastPageNumber: \(lastPage)")
            
            if intPage > intBookPages {
                invalidPageCount = true
            } else if intPage < lastPage {
                pageLessThanLastPage = true
            } else if quickNoteText == "" {
                let entry = Log(currentPage: page, dateLogged: date, tags: tagsTextArray, showingNote: false)
                modelContext.insert(entry)
                hapticsManager.playAddBookLog()
                book.addLogEntry(entry)
                page = ""
                quickNoteText = ""
                dismiss()
            } else {
                let note = QuickNote(noteText: quickNoteText, date: .now)
                let entry = Log(currentPage: page, dateLogged: date, tags: tagsTextArray, quickNote: note, showingNote: false)
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
        invalidPageCount = false
    }
}

//#Preview {
//    AddLogEntryView(book: <#T##Book#>)
//}
