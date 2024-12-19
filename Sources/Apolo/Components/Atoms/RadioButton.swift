//
//  RadioButton.swift
//  Apolo
//
//  Created by Eric on 19/12/24.
//

import SwiftUI

public struct RadioButton: View {
    // MARK: - Properties

    public var label: String?
    public var description: String?
    public var isActive: Bool
    @State private var isPressed: Bool = false
    
    init(label: String? = nil, description: String? = nil, isActive: Bool) {
        self.label = label
        self.description = description
        self.isActive = isActive
    }
    
    // MARK: - Body

    public var body: some View {
        HStack {
            radioCircle
            labelStack
            Spacer()
        }
    }
    
    // MARK: - UI Components

    private var radioCircle: some View {
        ZStack {
            Circle()
                .fill(isActive ? Color.primary : Color.clear)
                .frame(width: 10, height: 10)
            Circle()
                .stroke(Color.secondary, lineWidth: 1)
                .frame(width: 24, height: 24)
        }
        .scaleEffect(x: isPressed ? 0.95 : 1, y: isPressed ? 0.95 : 1)
        .animation(.bouncy(duration: 0.3), value: isPressed)
        .simultaneousGesture(pressGesture)
    }
    
    private var labelStack: some View {
        Group {
            if let label = label {
                VStack(alignment: .leading) {
                    Text(label)
                        .body()
                    
                    if let description = description {
                        Text(description)
                            .footnote()
                            .foregroundStyle(Color.secondary)
                    }
                }
            }
        }
    }
    
    // MARK: - Gestures

    private var pressGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in isPressed = true }
            .onEnded { _ in isPressed = false }
    }
}

#Preview {
    VStack {
        RadioButton(label: "Testando", isActive: false)
        RadioButton(label: "Testing", description: "Description", isActive: false)
    }
    .padding()
}
