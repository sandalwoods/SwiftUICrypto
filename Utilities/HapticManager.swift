//
//  HapticManager.swift
//  SwiftuiCrypto
//
//  Created by kevin on 2022/10/20.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
