//
//  HapticFeedback.swift
//  Apolo
//
//  Created by Ramon Santos on 04/03/26.
//

import SwiftUI

#if os(watchOS)
import WatchKit

/// Cross-platform haptic feedback style matching UIImpactFeedbackGenerator.FeedbackStyle
public enum HapticStyle: Int, Sendable {
    case light, medium, heavy, soft, rigid
}

/// Triggers haptic feedback on watchOS
public func performHaptic(_ style: HapticStyle = .soft) {
    switch style {
    case .light, .soft:
        WKInterfaceDevice.current().play(.click)
    case .medium:
        WKInterfaceDevice.current().play(.directionUp)
    case .heavy, .rigid:
        WKInterfaceDevice.current().play(.success)
    }
}

#else
import UIKit

/// Cross-platform haptic feedback style (typealias to UIKit on iOS)
public typealias HapticStyle = UIImpactFeedbackGenerator.FeedbackStyle

/// Triggers haptic feedback on iOS
public func performHaptic(_ style: HapticStyle = .soft) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}

#endif
