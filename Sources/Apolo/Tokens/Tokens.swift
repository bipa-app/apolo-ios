//
//  Tokens.swift
//  Apolo
//
//  Created by Eric on 04/12/24.
//

import SwiftUI

public enum Tokens {
    // MARK: - Spacing

    public enum Spacing {
        /// No spacing (0)
        public static let zero: CGFloat = 0

        /// Extra extra small spacing (4)
        public static let extraExtraSmall: CGFloat = 4

        /// Extra small spacing (8)
        public static let extraSmall: CGFloat = 8

        /// Small spacing (12)
        public static let small: CGFloat = 12

        /// Medium spacing (16)
        public static let medium: CGFloat = 16

        /// Large spacing (20)
        public static let large: CGFloat = 20

        /// Extra large spacing (32)
        public static let extraLarge: CGFloat = 32

        /// Extra extra large spacing (40)
        public static let extraExtraLarge: CGFloat = 40
    }

    // MARK: - Corner Radius

    public enum CornerRadius {
        /// No corner radius (0)
        public static let zero: CGFloat = 0

        /// Small corner radius (8)
        public static let small: CGFloat = 8

        /// Medium corner radius (12)
        public static let medium: CGFloat = 12

        /// Large corner radius (20)
        public static let large: CGFloat = 20
    }

    // MARK: - Shadow

    public enum Shadow {
        case none
        case small
        case medium
        case large

        public var radius: CGFloat {
            switch self {
            case .none: return 0
            case .small: return 4
            case .medium: return 8
            case .large: return 16
            }
        }

        public var y: CGFloat {
            switch self {
            case .none: return 0
            case .small: return 2
            case .medium: return 4
            case .large: return 8
            }
        }

        public var opacity: Double {
            switch self {
            case .none: return 0
            case .small: return 0.08
            case .medium: return 0.12
            case .large: return 0.16
            }
        }
    }

    // MARK: - Animation

    public enum Animation {
        /// Fast animation duration (0.15s)
        public static let fast: Double = 0.15

        /// Normal animation duration (0.25s)
        public static let normal: Double = 0.25

        /// Slow animation duration (0.4s)
        public static let slow: Double = 0.4

        /// Spring response for bouncy animations
        public static let springResponse: Double = 0.5

        /// Spring damping for bouncy animations
        public static let springDamping: Double = 0.8

        /// Standard spring animation
        public static var spring: SwiftUI.Animation {
            .spring(response: springResponse, dampingFraction: springDamping)
        }

        /// Bouncy spring animation
        public static var bouncy: SwiftUI.Animation {
            .spring(response: 0.4, dampingFraction: 0.6)
        }

        /// Smooth ease-out animation
        public static var smooth: SwiftUI.Animation {
            .easeOut(duration: normal)
        }
    }

    // MARK: - Z-Index

    public enum ZIndex {
        /// Base layer (0)
        public static let base: Double = 0

        /// Elevated content like cards (10)
        public static let elevated: Double = 10

        /// Dropdown menus and popovers (100)
        public static let dropdown: Double = 100

        /// Sticky headers and navigation (200)
        public static let sticky: Double = 200

        /// Modal overlays and sheets (300)
        public static let modal: Double = 300

        /// Toast notifications (400)
        public static let toast: Double = 400

        /// Top-most layer for critical UI (500)
        public static let top: Double = 500
    }
}

