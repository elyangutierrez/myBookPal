//
//  HapticsManager.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/1/24.
//

import Foundation

@Observable
class HapticsManager {
    var haptics = Haptics()
    
    @MainActor func playAddedBookToCollectionHaptic() {
        haptics.notify(.success)
    }
    
    @MainActor func playRemovedBookHaptic() {
        haptics.notify(.error)
    }
    
    @MainActor func playFoundISBNHaptic() {
        haptics.play(.heavy)
    }
    
    @MainActor func playAddedGoal() {
        haptics.notify(.success)
    }
    
    @MainActor func playRemovedGoal() {
        haptics.play(.medium)
    }
    
    @MainActor func playAddBookLog() {
        haptics.play(.light)
    }
    
    @MainActor func playDeleteBookLog() {
        haptics.play(.medium)
    }
}
