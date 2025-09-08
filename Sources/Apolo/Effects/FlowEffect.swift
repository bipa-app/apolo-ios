//
//  FlowEffect.swift
//  Apolo
//
//  Created by Ramon Santos on 08/09/25.
//

import SwiftUI

// MARK: Animation

public struct FlowEffect: GeometryEffect {
    public var phase: CGFloat

    public var animatableData: CGFloat {
        get { phase }
        set { phase = newValue }
    }

    public func effectValue(size: CGSize) -> ProjectionTransform {
        let transform = CGAffineTransform(
            a: 1 + sin(phase) * 0.3,
            b: cos(phase * 2) * 0.1,
            c: sin(phase * 2) * 0.1,
            d: 1 + cos(phase) * 0.2,
            tx: sin(phase) * 5,
            ty: cos(phase) * 5
        )
        return ProjectionTransform(transform)
    }
}
