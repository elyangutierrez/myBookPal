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
            print("Fetched goals.")
        } catch {
            print("Failed to fetch goals.")
        }
    }
    
//    func addGoal() {
//        
//        // Example Model
//        
//        let gen = Int.random(in: 1...2)
//        
//        let exampleGoal = Goal(text: "Testing", createdOn: Date.now, deadline: Date.now.addingTimeInterval(24.0 * 180) ,target: 14.0, status: "In Progress", reminderOn: false, priority: "High", selectedNumber: gen)
//        
//        print("Got example goal")
//        
//        modelContext.insert(exampleGoal)
//        
//        print("Inserted goal into context.")
//        
//        fetchGoals()
//    }
    
    func removeGoal(_ goal: Goal) {
        modelContext.delete(goal)
        goals.remove(at: goals.firstIndex(of: goal)!)
        print("DEBUG: removed goal from context")
    }
    
    func modifyGoal(_ goal: Goal) {
        // WIP...
    }
}
