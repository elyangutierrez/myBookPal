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
    @State private var dateManager = DateManager()
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack {
                    VStack {
                        // current month text
                    }
                    
                    VStack {
                        HStack {
                            // list of days
                        }
                    }
                    
                    VStack {
                        // add goal card
                    }
                    
                    VStack {
                        // current goals text
                    }
                    
                    VStack {
                        // date goal was added
                        
                        HStack {
                            VStack {
                                // time and line
                            }
                            
                            VStack {
                                // goal card
                            }
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Goals")
                        .fontWeight(.semibold)
                }
            }
            .onAppear {
                dateManager.getCurrentMonth()
                dateManager.getWeekDayNames()
                dateManager.getWeekDayNumbers()
                dateManager.getCurrentDay()
                dateManager.setSelectedDay()
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
