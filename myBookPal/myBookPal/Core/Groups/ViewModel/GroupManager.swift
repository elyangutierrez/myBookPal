//
//  GroupManager.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/19/24.
//

import Foundation
import SwiftData

@Observable
class GroupManager {
    var groups = [Group]()
    var hapticsManager = HapticsManager()
    var bookAlreadyInGroup = false
    var bookSuccessfullyAdded = false
    var bookDeletedFromGroup = false
    var bookAddedToGroup = false
    var bookFailedToAdd = false
    var modelContext: ModelContext
    var addGroupAlert = false
    var deleteGroupAlert = false
    var groupAddedAlert = false
    var groupTitle = ""
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchData()
    }
    
    func fetchData() {
        do {
            let descriptor = FetchDescriptor<Group>(sortBy: [SortDescriptor(\.name)])
            groups = try modelContext.fetch(descriptor)
        } catch {
            print("Error fetching groups: \(error.localizedDescription)")
        }
    }
    
    @MainActor func addSampleGroup() {
        let group = Group(name: "Dune Collection", creationDate: Date.now)
        modelContext.insert(group)
        hapticsManager.playAddedGoal()
        fetchData()
    }
    
    @MainActor func addGroup(_ group: Group) {
        modelContext.insert(group)
        hapticsManager.playAddedGoal()
        fetchData()
    }
    
    @MainActor func removeGroup(_ group: Group) {
        let index = groups.firstIndex(of: group)!
        modelContext.delete(group)
        groups.remove(at: index)
        hapticsManager.playRemovedBookHaptic()
        fetchData()
    }
    
    @MainActor func addBookToGroup(_ group: Group, _ book: Book) {
        let books = group.books ?? []
        if books.contains(book) {
            bookAlreadyInGroup.toggle()
            hapticsManager.playFailedToDeleteAllBooks()
        } else {
            group.books?.append(book)
            hapticsManager.playAddedGoal()
            bookSuccessfullyAdded.toggle()
        }
    }
    
    @MainActor func removeBookFromGroup(_ group: Group, _ book: Book) {
        print("Running 'removeBookFromGroup' method")
        let index = group.books?.firstIndex(of: book)
        guard let index else { return }
        group.books?.remove(at: index)
        bookDeletedFromGroup.toggle()
        hapticsManager.playRemovedBookHaptic()
    }
    
    func fetchUpdatedCollection(_ group: Group, _ collectionBooks: [Book]) {
        do {
            let descriptor = FetchDescriptor<Book>(sortBy: [SortDescriptor(\.title)])
            let books = try modelContext.fetch(descriptor)
            
            for book in collectionBooks {
                print(book.title)
                if books.contains(book) {
                    print("\(book.title) is in modelContext.")
                } else {
                    print("\(book.title) is not in modelContext.")
                    
                    let bookCount = group.books?.count ?? 0
                    
                    if bookCount == 1 {
                        let index = 0
                        group.books?.remove(at: index)
                    } else {
                        let index = collectionBooks.firstIndex(of: book)
                        guard let index else { return }
                        group.books?.remove(at: index)
                    }
                }
            }
        } catch {
            print("Error fetching updated collection: \(error.localizedDescription)")
        }
        
    }
}
