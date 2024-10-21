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
    var modelContext: ModelContext
    
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
        let group = Group(name: "Dune Collection", creationDate: Date.now, imageData: nil)
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
    
    // TODO: figure a way to add the books..
}
