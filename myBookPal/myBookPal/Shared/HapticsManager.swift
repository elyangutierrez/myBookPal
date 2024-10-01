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
}
