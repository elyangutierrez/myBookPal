//
//  GoalManager.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/22/24.
//

import Foundation
import SwiftData

@Observable
class GoalManager {
    var modelContext: ModelContext
    var goals = [Goal]()
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        fetchGoals()
    }
    
    func fetchGoals() {
        do {
            let descriptor = FetchDescriptor<Goal>(sortBy: [SortDescriptor(\.createdOn)])
            goals = try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch goals.")
        }
    }
    
    func addGoal() {
        
        // Example Model
        
        let exampleGoal = Goal(text: "Testing", createdOn: Date.now, timeFrame: DateInterval(start: Date.now, end: .now.addingTimeInterval(24.0 * 365)), target: 14, status: "In Progress", reminderOn: false, priority: "Important")
        
        print("Got example goal")
        
        modelContext.insert(exampleGoal)
        
        print("Inserted goal into context.")
        
        fetchGoals()
    }
    
    func removeGoal(_ goal: Goal) {
        modelContext.delete(goal)
    }
    
    func modifyGoal(_ goal: Goal) {
        // WIP...
    }
}
