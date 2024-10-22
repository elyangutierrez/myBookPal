//
//  IndividualGroupView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/19/24.
//

import SwiftData
import SwiftUI
import SDWebImageSwiftUI

struct IndividualGroupView: View {
    @State private var searchText = ""
    @State private var selectedBookToDelete: Book?
    @State private var showDeleteAlert = false
    @State private var selectedGroup: Group?
    @State private var addBookSheet = false
    var group: Group
    var groupManager: GroupManager
    var books: [Book]
    
    var searchResults: [Book] {
        
        guard let books = group.books else { return [] }
        
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { $0.title.contains(searchText) }
        }
    }
    
    var body: some View {
        List {
            // image here..
            if group.books?.count ?? 0 != 0 {
                VStack {
                    if group.imageData == nil {
                        VStack {
                            RoundedRectangle(cornerRadius: 5.0)
                                .fill(.gray)
                                .frame(width: 250, height: 250)
                                .overlay {
                                    Image(systemName: "book")
                                        .resizable()
                                        .frame(width: 50, height: 40)
                                        .foregroundStyle(.starGrey)
                                }
                                .listRowSeparator(.hidden, edges: .all)
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    } else {
                        if let data = group.imageData, let uiImage = UIImage(data: data) {
                            let image = Image(uiImage: uiImage)
                            
                            image
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                                .frame(width: 250, height: 250)
                                .scaledToFit()
                                .listRowSeparator(.hidden, edges: .all)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    
                    // title here..
                    
                    Text(group.name)
                        .foregroundStyle(.complement)
                        .fontWeight(.semibold)
                        .padding(3)
                    
                    // date here
                    
                    Text(group.formattedDate)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
                .listRowSeparator(.hidden, edges: .all)
                .offset(y: -10)
            }
                
                // books here..
                
            if group.books != nil {
                ForEach(searchResults, id: \.self) { book in
                    VStack(alignment: .leading) {
                        HStack {
                            let imageString = book.coverImage
                            
                            if imageString.contains("https") {
                                WebImage(url: URL(string: imageString)) { image in
                                    image
                                        .image?.resizable()
                                        .frame(width: 60, height: 110)
                                        .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 2.0)
                                                .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                .fill(.clear)
                                                .frame(width: 60, height: 110)
                                        }
                                        
                                }
                                .onSuccess { image, data, cacheType in
                                    if let someDataTwo = image.pngData() {
                                        book.sharedImageData = someDataTwo
                                    }
                                    
                                }
                            } else {
                                let image = imageString.toImage()
                                
                                image?
                                    .resizable()
                                    .frame(width: 60, height: 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 2.0)
                                            .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                            .fill(.clear)
                                            .frame(width: 60, height: 110)
                                    }
                            }
                            
                            VStack(alignment: .leading) {
                                
                                Text(book.title)
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                
                                Text(book.author)
                                    .font(.caption)
                                    .lineLimit(1)
                                
                                Text("\(book.pages) pages")
                                    .font(.caption)
                                
                                VStack(alignment: .leading) {
                                    StarRatingView(rating: book.starRatingSystem?.rating ?? 0.0)
                                        .font(.subheadline)
                                }
                                .offset(y: 3)
                                
                                VStack(alignment: .leading) {
                                    Text("\(book.getLogCount ?? 0 > 0 ? "\(book.getLogCount ?? 0)" : "0")")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .background {
                                            RoundedRectangle(cornerRadius: 5.0)
                                                .fill(.complement.opacity(0.70))
                                                .padding(.horizontal, -5)
                                                .padding(.vertical, -3)
                                        }
                                }
                                .offset(x: 3, y: 28)
                            }
                            .frame(maxHeight: .infinity, alignment: .top)
                            .padding(.vertical, -3)
                        }
                        .frame(height: 110)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .swipeActions(edge: .leading) {
                        
                        if let dataToBeShared = book.sharedImageData, let uiImage = UIImage(data: dataToBeShared) {
                            let swiftImage = Image(uiImage: uiImage)
                            ShareLink(item: swiftImage, message: Text("I'm currently reading this book. You should check it out!"), preview: SharePreview(book.title, image: swiftImage), label: {
                                Label("", systemImage: "square.and.arrow.up")
                                
                            })
                            .tint(.gray)
                        }
                        
                        Button(action: {
                            
                        }) {
                            let formatted = String(format: "%.0f", (book.completionStatus) * 100)
                            Label("\(formatted == "0.0" ? "0" : formatted)%", systemImage: book.completionStatus == 1 ? "checkmark.circle" : "progress.indicator")
                        }
                        .tint(book.completionStatus == 1 ? Color.green : Color.blue)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            selectedBookToDelete = book
                            showDeleteAlert.toggle()
                        }) {
                            Label("", systemImage: "trash")
                        }
                        .tint(.red)
                        
                        NavigationLink(destination: LogView(book: book)) {
                            Label("", systemImage: "list.dash.header.rectangle")
                        }
                        .tint(.complement)
                    }
                    .background {
                        NavigationLink("", destination: LogView(book: book))
                            .opacity(0)
                    }
                }
            }
        }
        .alert("Delete Book", isPresented: $showDeleteAlert) {
            Button("Yes", role: .destructive, action: {
                groupManager.removeBookFromGroup(group, selectedBookToDelete!)
            })
            Button("Cancel", role: .cancel, action: {
                selectedBookToDelete = nil
                showDeleteAlert.toggle()
            })
        } message: {
            Text("Are you sure you want to delete this book from the group?")
        }
        .scrollContentBackground(.hidden)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .listStyle(.grouped)
        .overlay {
            if group.books?.count ?? 0 == 0 {
                VStack {
                    ContentUnavailableView {
                        Label("No Books In Group", systemImage: "books.vertical.fill")
                    } description: {
                        Text("Swipe to the left of group to add a book!")
                    }
                }
            } 
        }
        .onAppear {
            print(group.books?.count ?? 0)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    addBookSheet.toggle()
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $addBookSheet) {
            NavigationStack {
                // list over books
                List {
                    ForEach(books, id: \.self) { book in
                        VStack {
                            HStack {
                                let imageString = book.coverImage
                                
                                if imageString.contains("https") {
                                    WebImage(url: URL(string: imageString)) { image in
                                        image
                                            .image?.resizable()
                                            .frame(width: 60, height: 110)
                                            .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 2.0)
                                                    .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                    .fill(.clear)
                                                    .frame(width: 60, height: 110)
                                            }
                                    }
                                    .onSuccess { image, data, cacheType in
                                        if let someDataTwo = image.pngData() {
                                            book.sharedImageData = someDataTwo
                                        }
                                        
                                    }
                                    
                                } else {
                                    let image = imageString.toImage()
                                    
                                    image?
                                        .resizable()
                                        .frame(width: 60, height: 110)
                                        .clipShape(RoundedRectangle(cornerRadius: 2.0))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 2.0)
                                                .stroke(Color.black.opacity(0.20), lineWidth: 1)
                                                .fill(.clear)
                                                .frame(width: 60, height: 110)
                                        }
                                }
                                
                                VStack {
                                    Text(book.title)
                                }
                            }
                            .frame(height: 110)
                        }
                        .simultaneousGesture(
                            TapGesture()
                                .onEnded {
                                    selectedBookToDelete = book
                                    groupManager.addBookToGroup(group, selectedBookToDelete!)
                                    
                                    if groupManager.bookSuccessfullyAdded {
                                        groupManager.bookAddedToGroup = true
                                    }
                                }
                        )
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Books in Collection")
                            .fontWeight(.semibold)
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: {
                            addBookSheet = false
                        }) {
                            Text("Cancel")
                        }
                    }
                }
                .overlay {
                    if groupManager.bookAlreadyInGroup {
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(.regularMaterial)
                            .frame(width: 200, height: 100)
                            .overlay {
                                VStack {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text("Book Already In Group")
                                        .font(.subheadline)
                                }
                            }
                    }
                    
                    if groupManager.bookAddedToGroup {
                        RoundedRectangle(cornerRadius: 5.0)
                            .fill(.regularMaterial)
                            .frame(width: 180, height: 100)
                            .overlay {
                                VStack {
                                    Image(systemName: "checkmark.circle.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    
                                    Spacer()
                                        .frame(height: 10)
                                    
                                    Text("Book Added To Group!")
                                        .font(.subheadline)
                                }
                            }
                    }
                }
            }
        }
        .onChange(of: groupManager.bookAddedToGroup) {
            if groupManager.bookAddedToGroup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        groupManager.bookAddedToGroup = false
                        groupManager.bookSuccessfullyAdded = false
                        addBookSheet = false
                    }
                    
                }
            }
        }
        .onChange(of: groupManager.bookAlreadyInGroup) {
            if groupManager.bookAlreadyInGroup {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        groupManager.bookAlreadyInGroup = false
                    }
                }
            }
        }
    }
}

//#Preview {
//    IndividualGroupView(group: Group(name: "Dune", creationDate: Date.now, imageData: nil), books: [Book]())
//}