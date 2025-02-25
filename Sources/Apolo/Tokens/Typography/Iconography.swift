//
//  Iconography.swift
//  Apolo
//
//  Created by Eric on 25/02/25.
//

import SwiftUI

public extension View {
    /// Extra small SF Symbol (10)
    func extraSmall() -> some View {
        self
            .font(.system(size: 10))
    }
    
    /// Small SF Symbol (15)
    func small() -> some View {
        self
            .font(.system(size: 15))
    }
    
    /// Regular SF Symbol (17)
    func regular() -> some View {
        self
            .font(.system(size: 17))
    }
    
    /// Large SF Symbol (22)
    func large() -> some View {
        self
            .font(.system(size: 22))
    }
}

// Example usage:
#Preview {
    VStack(spacing: 20) {
        Image(systemName: "bitcoinsign.gauge.chart.leftthird.topthird.rightthird")
            .extraSmall()
        
        Image(systemName: "bitcoinsign.gauge.chart.leftthird.topthird.rightthird")
            .small()
        
        Image(systemName: "bitcoinsign.gauge.chart.leftthird.topthird.rightthird")
            .regular()
        
        Image(systemName: "bitcoinsign.gauge.chart.leftthird.topthird.rightthird")
            .large()
    }
}
