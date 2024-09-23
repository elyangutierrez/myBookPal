//
//  CurrentGoalsView.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/22/24.
//

import SwiftUI
import SwiftData

struct CurrentGoalsView: View {
    
    @State private var goalManager: GoalManager
    @State private var goalToDelete: Goal?
    
    var body: some View {
        NavigationStack {
            List(goalManager.goals) { goal in
                VStack {
                    Text(goal.text)
                    Text(goal.createdOnString)
                }
            }
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        goalManager.addGoal()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    init(modelContext: ModelContext) {
        let goalManager = GoalManager(modelContext: modelContext)
        _goalManager = State(initialValue: goalManager)
    }
}

//#Preview {
//    CurrentGoalsView()
//}
