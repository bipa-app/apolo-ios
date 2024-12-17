//
//  Color+Ext.swift
//  Apolo
//
//  Created by Ramon Santos on 17/12/24.
//

import SwiftUI

public extension Color {
    
    /// `inverted()`
    ///  Returns the opposite color to the color that call this function
    ///  Example: let white: Color = Color.black.inverted()
    func inverted() -> Color {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return Color(red: 1.0 - red, green: 1.0 - green, blue: 1.0 - blue, opacity: Double(alpha))
    }
}
