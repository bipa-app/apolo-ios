//
//  AnimatedRadialGradientModifier.swift
//  Apolo
//
//  Created by Ramon Santos on 19/12/24.
//

import SwiftUI

// MARK: - View Extension

public extension View {
    func animatedRadialGradient(
        animate: Binding<Bool>,
        cornerRadius: CGFloat = 30,
        blurRadius: CGFloat = 4
    ) -> some View {
        self.modifier(
            AnimatedRadialGradientModifier(
                animate: animate,
                cornerRadius: cornerRadius,
                blurRadius: blurRadius
            )
        )
    }
}

// MARK: - AnimatedRadialGradientModifier

struct AnimatedRadialGradientModifier: ViewModifier {
    
    init(
        animate: Binding<Bool>,
        cornerRadius: CGFloat = 30,
        blurRadius: CGFloat = 4
    ) {
        self._animate = animate
        self.cornerRadius = cornerRadius
        self.blurRadius = blurRadius
    }
    
    @Binding private var animate: Bool
    private let cornerRadius: CGFloat
    private let blurRadius: CGFloat
    @State private var animationAngle: Double = .zero

    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                .linearGradient(
                    colors: [],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .shadow(.inner(color: .white.opacity(animate ? 0.2 : 0), radius: 0, x: 1, y: 1))
                .shadow(.inner(color: .white.opacity(animate ? 0.05 : 0), radius: 4, x: 0, y: -4))
                .shadow(.drop(color: .black.opacity(animate ? 0.5 : 0), radius: 30, y: 30))
            )
            .background(
                ZStack {
                    if animate {
                        AngularGradient(
                            colors: [.red, .blue, .teal, .red],
                            center: .center,
                            angle: .degrees(animationAngle)
                        )
                        .cornerRadius(cornerRadius)
                        .blur(radius: blurRadius)

                        AngularGradient(
                            colors: [.white, .blue, .teal, .white],
                            center: .center,
                            angle: .degrees(animationAngle)
                        )
                        .cornerRadius(cornerRadius)
                        .blur(radius: blurRadius)
                    }
                }
            )
            .onAppear { startAnimation() }
            .onDisappear { resetAnimationAngle() }
            .onChange(of: animate) { newValue in
                if newValue {
                    startAnimation()
                } else {
                    resetAnimationAngle()
                }
            }
    }

    private func startAnimation() {
        guard animate else { return }

        withAnimation(Animation.linear(duration: 2).repeatForever(autoreverses: false)) {
            animationAngle = 360
        }
    }

    private func resetAnimationAngle() {
        animationAngle = .zero
    }
}

// MARK: - Preview

#Preview {
    Button(
        action: {},
        label: {
            Text("Animated Radial Gradient")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
        }
    )
    .borderedProminentStyle(color: .black, size: .large)
    .animatedRadialGradient(animate: .constant(true))
    .padding()
}
