//
//  LogView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 5/12/24.
//

import SwiftData
import SwiftUI

struct LogView: View {
    @State private var showSheet = false
    @State private var activateReviewSheet = false
    @State private var isStarRatingAlertOn = false
    @State private var inputRating: Double?
    @State private var currentNoteInEdit: Bool = false
    @State private var dateTracker = DateTracker()
    @State private var showDeletionAlert = false
    @State private var currentLog: Log?
    @State private var lastPageNumber: Int?
    @State private var noteVisibility = NoteVisibility()
    @State private var currentNote: QuickNote?
    @State private var hapticsManager = HapticsManager()
    @State private var invalidRating = false
    @State private var validRating = false
    
    var book: Book
    
    var getLogCompletionDate: String {
        let logs = book.logs
        let lastLog = logs?.last
        
        if Int(book.pages) == lastLog?.totalPagesRead {
            return lastLog!.getFullDate
        }
        
        return ""
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    if book.getLogCount == nil || book.logs?.count == 0  {
                        ContentUnavailableView("No Logs Avaliable",
                                               systemImage: "book.pages",
                                               description: Text("Click the '+' to add a log!"))
                    } else {
                        ScrollView(showsIndicators: true) {
                            Spacer()
                                .frame(height: 25)
                            VStack(alignment: .leading) {
                                if book.logs?.count != 0 {
                                    HStack {
                                        Circle()
                                            .fill(.gray.opacity(0.20))
                                            .frame(width: 25, height: 25)
                                            .overlay {
                                                Circle()
                                                    .fill(.black.opacity(0.70))
                                                    .frame(width: 12, height: 12)
                                            }
                                            .padding(.horizontal, 2.5)
                                        
                                        Text("Created on \(book.getLogCreationDate)")
                                            .foregroundStyle(.longDate)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 4)
                                    }
                                }
                                
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: 30, height: 30)
                                    .overlay {
                                        VStack {
                                            Rectangle()
                                                .frame(width: 1, height: 25)
                                        }
                                    }
                                    .padding(.vertical, -3)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 25)
                            
                            VStack(alignment: .leading) {
                                ForEach(book.logs ?? [Log](), id: \.self) { log in
                                    HStack {
                                        // Left most side of log
                                        VStack {
                                            Text(log.getTime)
                                                .font(.system(size: 11))
                                                .foregroundStyle(.time)
                                                .fontWeight(.bold)
                                            Circle()
                                                .fill(.complement.opacity(0.70))
                                                .frame(width: 50, height: 50)
                                                .overlay {
                                                    Image(systemName: "book.pages.fill")
                                                        .BookPagesFillImageExtension()
                                                }
                                            Rectangle()
                                                .fill(.clear)
                                                .frame(width: 30, height: 50)
                                                .overlay {
                                                    VStack {
                                                        Rectangle()
                                                            .frame(width: 1, height: 35)
                                                    }
                                                }
                                                .padding(.vertical, -8)
                                        }
                                        
                                        Spacer()
                                            .frame(width: 15)
                                        
                                        // Date and Time
                                        VStack(alignment: .leading) {
                                            
                                            Text(log.getMonthAndDay)
                                                .font(.system(size: 13))
                                                .fontWeight(.bold)
                                            
                                            Text(log.getYear)
                                                .font(.title3)
                                                .foregroundStyle(.gray)
                                                .fontWeight(.bold)
                                        }
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .padding(.vertical, 24)
                                        
                                        Spacer()
                                            .frame(width: 15)
                                        
                                        VStack {
                                            RoundedRectangle(cornerRadius: 15.0)
                                                .fill(.gray.opacity(0.10))
                                                .frame(width: geometry.size.width * 0.55, height: 60)
                                                .overlay {
                                                    VStack(alignment: .leading) {
                                                        Spacer()
                                                            .frame(height: 15)
                                                        VStack {
                                                            HStack {
                                                                VStack {
                                                                    Image(systemName: "book.circle")
                                                                        .resizable()
                                                                        .frame(width: 30, height: 30)
                                                                }
                                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                                
                                                                if log.quickNote?.noteText != nil {
                                                                    
                                                                    // TODO: Fix padding
                                                                    
                                                                    VStack {
                                                                        Text("\(String(log.totalPagesRead)) / \(book.pages)")
                                                                            .font(.system(size: 12.5))
                                                                            .fontWeight(.bold)
                                                                            .fixedSize(horizontal: true, vertical: false)
                                                                    }
                                                                    .frame(maxWidth: geometry.size.width, alignment: .leading)
                                                                    //                                                                        .offset(x: -25)
                                                                } else {
                                                                    
                                                                    // TODO: Fix padding
                                                                    
                                                                    VStack {
                                                                        Text("\(String(log.totalPagesRead)) / \(book.pages)")
                                                                            .font(.system(size: 12.5))
                                                                            .fontWeight(.bold)
                                                                            .fixedSize(horizontal: true, vertical: false)
                                                                    }
                                                                    .frame(maxWidth: geometry.size.width, alignment: .leading)
                                                                    //                                                                        .offset(x: -25)
                                                                }
                                                                
                                                                if log.quickNote?.noteText != nil {
                                                                    VStack {
                                                                        Image(systemName: "note.text")
                                                                            .onTapGesture {
                                                                                guard let noteText = log.quickNote?.noteText else {
                                                                                    print("Error printing note")
                                                                                    return
                                                                                }
                                                                                print(noteText)
                                                                                
                                                                                let currentDate = Date.now
                                                                                
                                                                                currentNote = QuickNote(noteText: noteText, date: currentDate)
                                                                                
                                                                                currentLog = log
                                                                            }
                                                                    }
                                                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                                                    //                                                                        .padding(.horizontal, -23)
                                                                }
                                                                
                                                                VStack {
                                                                    Menu {
                                                                        Button("Delete",
                                                                               role: .destructive,
                                                                               action: {
                                                                            currentLog = log
                                                                            showDeletionAlert.toggle()
                                                                        })
                                                                        .tint(.red)
                                                                        .accessibilityLabel("Delete log")
                                                                    } label: {
                                                                        Circle()
                                                                            .fill(.clear)
                                                                            .frame(width: 30, height: 30)
                                                                            .overlay {
                                                                                Image(systemName: "ellipsis")
                                                                            }
                                                                    }
                                                                }
                                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                                                .accessibilityAddTraits(.isButton)
                                                            }
                                                        }
                                                        .frame(maxHeight: .infinity, alignment: .top)
                                                    }
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                    .padding(.horizontal, 15)
                                                }
                                                .allowsHitTesting(true) // lets user tap through overlay
                                        }
                                        .frame(maxHeight: .infinity, alignment: .top)
                                        .padding(.vertical, 12)
                                    }
                                }
                                
                                Spacer()
                                    .frame(height: 20)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 15)
                            
                            if getLogCompletionDate != "" {
                                //                            Text("Completed on \(getLogCompletionDate)")
                                VStack(alignment: .leading) {
                                    HStack {
                                        Circle()
                                            .fill(.gray.opacity(0.20))
                                            .frame(width: 25, height: 25)
                                            .overlay {
                                                Circle()
                                                    .fill(.black.opacity(0.70))
                                                    .frame(width: 12, height: 12)
                                            }
                                            .padding(.horizontal, 2.5)
                                        
                                        Text("Completed on \(getLogCompletionDate)")
                                            .foregroundStyle(.longDate)
                                            .fontWeight(.semibold)
                                            .padding(.horizontal, 4)
                                    }
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 25)
                                .padding(.vertical, -10)
                                
                            }
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
            .navigationTitle("Logs")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $currentNote) { note in
                NoteTextView(note: note)
                    .presentationDetents([.height(325)])
                    .presentationCornerRadius(25.0)
                    .presentationBackground(.white)
            }
            .onChange(of: book.logs) {
                if Int(book.pages) == book.currentPage {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isStarRatingAlertOn = true
                    }
                }
            }
            .onAppear {
                let logsArray = book.logs
                let lastLog = logsArray?.last
                
                if lastPageNumber == nil {
                    lastPageNumber = lastLog?.totalPagesRead
                }
            }
            .onChange(of: lastPageNumber) {
                let logs = book.logs
                let lastLog = logs?.last
                
                if lastPageNumber == nil {
                    lastPageNumber = lastLog?.totalPagesRead
                }
            }
            .overlay(alignment: .bottom) {
                
            }
            .toolbar {
                
                if book.getLogCount != nil {
                    ToolbarItem(placement: .topBarTrailing) {
                        
                        Button(action: {
                            isStarRatingAlertOn.toggle()
                        }) {
                            Image(systemName: "star")
                        }
                        .padding(.horizontal, -10)
                        .accessibilityLabel("Rate Book")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button(action: {
                        showSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add Log")
                }
            }
            .sheet(isPresented: $showSheet) {
                AddLogEntryView(book: book, lastPageNumber: lastPageNumber ?? 0)
            }
            .alert("Rate Book", isPresented: $isStarRatingAlertOn) {
                TextField("Enter Rating", value: $inputRating, format: .number)
                    .accessibilityLabel("Enter Rating")
                
//                guard let rating = inputRating else { return }
                
                Button("Add", role: .cancel, action: addRatingToBook)
                    .accessibilityAddTraits(.isButton)
                Button("Cancel") { }
                    .accessibilityLabel("Cancel rating")
                    .accessibilityAddTraits(.isButton)
            } message: {
                Text("Enter a rating from 0 to 5.")
            }
            .alert("Delete Log", isPresented: $showDeletionAlert) {
                Button("Yes", role: .destructive, action: deleteLog)
                    .accessibilityLabel("Confirm deletion")
                    .accessibilityAddTraits(.isButton)
                Button("Cancel", role: .cancel) { }
                    .accessibilityLabel("Cancel deletion")
                    .accessibilityAddTraits(.isButton)
            } message: {
                Text("Are you sure you want to delete this log entry?")
            }
            .alert("Invalid Rating", isPresented: $invalidRating) {
                Button("OK", action: {
                    invalidRating.toggle()
                    inputRating = nil
                })
            } message: {
                Text("You enter an invalid rating. Try again.")
            }
            .alert("Book Rated", isPresented: $validRating) {
                Button("OK", action: {
                    validRating.toggle()
                    inputRating = nil
                })
            } message: {
                Text("You've successfully rated this book!")
            }
        }
    }
    
    func addRatingToBook() {
        guard let inputRating else { return }
        
        if inputRating < 0 || inputRating > 5 {
            isStarRatingAlertOn = false
            invalidRating.toggle()
        } else {
            let starRating = StarRating(rating: inputRating)
            isStarRatingAlertOn = false
            book.starRatingSystem = starRating
            validRating.toggle()
        }
    }
    
    func deleteLog() {
        let logIndex = book.logs!.firstIndex(of: currentLog!) ?? 0
        
        book.logs?.remove(at: logIndex)
        hapticsManager.playDeleteBookLog()
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Book.self, configurations: config)
        let example = Book(coverImage: "AAAA", title: "Dune", author: "Frank Herbert", catagory: "Fiction", pages: "706")
        return LogView(book: example)
            .modelContainer(container)
    } catch {
        return Text("Sorry, couldn't preview.")
    }
}
