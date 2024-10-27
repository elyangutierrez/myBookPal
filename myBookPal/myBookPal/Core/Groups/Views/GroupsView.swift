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
    @State private var selectedGroup: Group?
    
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
                        VStack {
                            VStack(alignment: .leading) {
                                Text(group.name)
                                    .font(.headline)
                                    .foregroundStyle(.accent)
                                    .lineLimit(1)
                                
                                Spacer()
                                    .frame(height: 7)
                                
                                HStack {
                                    Text("\(group.books?.count ?? 0)")
                                        .font(.caption)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.white)
                                        .background {
                                            RoundedRectangle(cornerRadius: 5.0)
                                                .fill(.complement.opacity(0.70))
                                                .padding(.horizontal, -5)
                                                .padding(.vertical, -3)
                                        }
                                        .offset(x: 3)
                                    
                                    Text(group.books?.count ?? 0 == 1 ? "Book" : "Books")
                                        .font(.caption)
                                        .offset(x: 3)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .frame(height: 50)
                    }
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            selectedGroup = group
                            groupManager.deleteGroupAlert.toggle()
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                    .background {
                        NavigationLink("", destination: IndividualGroupView(group: group, groupManager: groupManager, books: books))
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
                        groupManager.addGroupAlert.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                if groupManager.groups.count > 0 {
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker("Sort", selection: $selectedSortingOptions) {
                                ForEach(sortingOptions, id: \.self) { sort in
                                    Text(sort)
                                }
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down")
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Groups")
                        .fontWeight(.semibold)
                }
            }
            .searchable(text: $searchText)
            .scrollContentBackground(.hidden)
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
            .alert("Delete Group", isPresented: $groupManager.deleteGroupAlert) {
                Button("Cancel", role: .cancel, action: {
                    groupManager.deleteGroupAlert = false
                })
                Button("Yes", role: .destructive, action: {
                    guard let selectedGroup else { return }
                    groupManager.removeGroup(selectedGroup)
                    groupManager.deleteGroupAlert = false
                })
            } message: {
                Text("Are you sure you want to delete this group?")
            }
            .alert("Add Group", isPresented: $groupManager.addGroupAlert) {
                TextField("Group Name", text: $groupManager.groupTitle)
                
                Button("Add", action: {
                    let group = Group(name: groupManager.groupTitle, creationDate: Date.now)
                    groupManager.addGroup(group)
                    groupManager.addGroupAlert = false
                    groupManager.groupTitle = ""
                }).disabled(groupManager.groupTitle == "")
                
                Button("Cancel", role: .cancel, action: {
                    groupManager.addGroupAlert = false
                    groupManager.groupTitle = ""
                })
            } message: {
                Text("Enter a group name in the text field to add a group.")
            }
        }
    }
}

//#Preview {
//    GroupsView(modelContext: )
//}
