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
    @State private var tagsTextArray = [Tag]()
    
    let today = Date.now
    let endOfToday = Date.now
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Enter Current Page", text: $page)
                    
                    DatePicker("Datetime", selection: $date, in: today...endOfToday)
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
                
                Section {
                    Button(action: {
                        addEntry()
                    }) {
                        Text("Add")
                    }
                    .disabled(checkFields)
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
    }
    
    func addEntry() {
        if let intPage = Int(page), let intBookPages = Int(book.pages) {
            if intPage > intBookPages {
                invalidPageCount = true
            } else {
                let entry = Log(currentPage: page, dateLogged: date, tags: tagsTextArray)
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
