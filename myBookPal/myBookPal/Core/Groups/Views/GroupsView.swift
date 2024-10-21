//
//  GroupsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/19/24.
//

import SwiftUI
import SwiftData

struct GroupsView: View {
    
    @State private var groupManager: GroupManager
    @State private var searchText = ""
    @State private var showAddSheet = false
    @State private var selectedViewingOptions = "List"
    @State private var selectedSortingOptions = "Title"
    
    let viewingOptions = ["List", "Grid"]
    let sortingOptions = ["Title", "Date Added"]
    
    init(modelContext: ModelContext) {
        let groupManager = GroupManager(modelContext: modelContext)
        _groupManager = State(initialValue: groupManager)
    }
    
    var searchResults: [Group] {
        if searchText == "" {
            return groupManager.groups
        } else {
            return groupManager.groups.filter { $0.name.contains(searchText)}
        }
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
                        Picker("View", selection: $selectedViewingOptions) {
                            ForEach(viewingOptions, id: \.self) { option in
                                Text(option)
                            }
                        }
                        
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
        }
    }
}

//#Preview {
//    GroupsView(modelContext: )
//}
