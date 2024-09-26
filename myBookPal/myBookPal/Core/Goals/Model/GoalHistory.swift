//
//  GoalHistory.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 9/26/24.
//

import Foundation
import SwiftData

@Model
class GoalHistory {
    var goals: [Goal]
    
    init(goals: [Goal]) {
        self.goals = goals
    }
}
