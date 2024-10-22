//
//  GroupsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/19/24.
//

import SDWebImageSwiftUI
import SwiftUI
import SwiftData

struct GroupsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var groupManager: GroupManager
    @State private var searchText = ""
    @State private var showAddSheet = false
    @State private var selectedSortingOptions = "Title"
    @State private var addBookSheet = false
    @State private var selectedGroup: Group?
    @State private var bookAddedToGroup = false
    @State private var bookNotAddedToGroup = false
    
    let sortingOptions = ["Title", "Date Added"]
    
    var books: [Book]
    
    var searchResults: [Group] {
        if searchText == "" {
            if selectedSortingOptions == "Title" {
                return groupManager.groups.sorted(by: { $0.name < $1.name })
            } else {
                return groupManager.groups.sorted(by: { $0.creationDate > $1.creationDate })
            }
        } else {
            let filtered = groupManager.groups.filter { $0.name.contains(searchText)}
            
            if selectedSortingOptions == "Title" {
                return filtered.sorted(by: { $0.name < $1.name })
            } else {
                return filtered.sorted(by: { $0.creationDate > $1.creationDate })
            }
        }
    }
    
    init(modelContext: ModelContext, books: [Book]) {
        let groupManager = GroupManager(modelContext: modelContext)
        _groupManager = State(initialValue: groupManager)
        self.books = books
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { group in
                    VStack(alignment: .leading) {
                        HStack {
                            if group.imageData == nil {
//                                let _ = print("imageData is nil")
                                RoundedRectangle(cornerRadius: 5.0)
                                    .fill(.gray)
                                    .frame(width: 60, height: 60)
                                    .overlay {
                                        Image(systemName: "book")
                                            .foregroundStyle(.starGrey)
                                    }
                            } else {
//                                let _ = print("imageData is not nil")
                                if let data = group.imageData, let uiImage = UIImage(data: data) {
                                    let image = Image(uiImage: uiImage)
                                    
                                    image
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                                        .frame(width: 60, height: 60)
//                                        .aspectRatio(contentMode: .fit)
                                        .scaledToFit()
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                Text(group.name)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 60)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            groupManager.removeGroup(group)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                        
                        Button(action: {
                            selectedGroup = group
                            addBookSheet.toggle()
                        }) {
                            Image(systemName: "plus")
                        }
                        .tint(.complement)
                    }
                    .background {
                        NavigationLink("", destination: IndividualGroupView(group: group))
                            .opacity(0)
                    }
                }
            }
            .listStyle(.grouped)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button("Sample", action: groupManager.addSampleGroup)
//                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Sort", selection: $selectedSortingOptions) {
                            ForEach(sortingOptions, id: \.self) { sort in
                                Text(sort)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Groups")
                        .fontWeight(.semibold)
                }
            }
            .searchable(text: $searchText)
            .scrollContentBackground(.hidden)
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
                                        groupManager.addBookToGroup(selectedGroup!, book)
                                        
                                        if groupManager.bookSuccessfullyAdded {
                                            bookAddedToGroup.toggle()
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
                        
                        if bookAddedToGroup {
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
            .sheet(isPresented: $showAddSheet) {
                // Sheet here...
                AddGroupView(groupManager: groupManager)
            }
            .overlay {
                if groupManager.groups.isEmpty {
                    VStack {
                        ContentUnavailableView {
                            Label("No Groups Available", systemImage: "rectangle.3.group.fill")
                        } description: {
                            Text("Add a group to get started!")
                        }
                    }
                }
            }
            .onChange(of: bookAddedToGroup) {
                if bookAddedToGroup {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            bookAddedToGroup = false
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
}

//#Preview {
//    GroupsView(modelContext: )
//}
