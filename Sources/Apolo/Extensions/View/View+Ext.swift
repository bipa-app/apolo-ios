//
//  View+Ext.swift
//  Apolo
//
//  Created by Ramon Santos on 07/01/26.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func `if`<T>(condition: (()  -> Bool), transform: (Self) -> T) -> some View where T : View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

