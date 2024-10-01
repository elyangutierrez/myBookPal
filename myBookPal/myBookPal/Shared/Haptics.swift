//
//  Haptics.swift
//  myBookPal
//
//  Created by Elyan Gutierrez on 10/1/24.
//

import Foundation
import UIKit

final class Haptics: Sendable {
    static let haptics = Haptics()
    
    init() { }
    
    @MainActor func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }
        
    @MainActor func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}
