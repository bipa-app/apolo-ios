import SwiftUI

public struct ConfirmationSlideView: View {
    
    public init(
        isConfirmed: Binding<Bool>,
        confirmedColor: Color = .green,
        isDisabled: Bool = false,
        confirmed: @escaping () -> Void
    ) {
        self._isConfirmed = isConfirmed
        self.confirmedColor = confirmedColor
        self.isDisabled = isDisabled
        self.confirmed = confirmed
    }
    
    @Binding private var isConfirmed: Bool
    private var confirmedColor: Color = .green
    private var isDisabled: Bool = false
    private var confirmed: () -> Void
    private var tintColor: Color = .black
    private var color: Color = .init(uiColor: .quaternaryLabel)
    
    @State private var rotationAngle: CGFloat = 0
    @State private var buttonOffset: CGFloat = 0
    @State private var opacity: CGFloat = 1
    @State private var confirmTextMinX: CGFloat = 0
    @State private var hintConfirmation = true
    
    public var body: some View {
        GeometryReader { geometry in
            HStack {
                Image(systemName: "arrow.right")
                    .font(.system(size: 32))
                    .rotationEffect(.degrees(rotationAngle))
                    .foregroundStyle(isDisabled ? color : isConfirmed ? confirmedColor : tintColor)
                    .padding(Tokens.Spacing.large)
                    .background(isDisabled ? color : .white)
                    .cornerRadius(Tokens.CornerRadius.small)
                    .offset(x: buttonOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                dragGestureChanged(gesture, geometry)
                            }
                            .onEnded { gesture in
                                dragGestureEnded(gesture, geometry)
                            }
                    )
                Spacer()
            }
            .onAppear {
                if !isDisabled {
                    Task { await initiateHintAnimation() }
                }
            }
            .padding(5)
            .background(
                isDisabled ? color.opacity(0.5) : isConfirmed ? confirmedColor : color
            )
            .cornerRadius(Tokens.CornerRadius.medium)
            .overlay(
                Text("Confirmar")
                    .title3(weight: .medium)
                    .foregroundStyle(isDisabled ? color : tintColor)
                    .opacity(opacity)
                    .backgroundGeometryProxy { proxy in
                        confirmTextMinX = proxy.frame(in: .global).minX - 100
                    },
                alignment: .center
            )
            .disabled(isDisabled)
        }
    }
        
    private func initiateHintAnimation() async {
        do {
            try await Task.sleep(seconds: 1)
            await animateHint()
        } catch {}
    }
    
    private func animateHint() async {
        do {
            if !hintConfirmation {
                return
            }
            withAnimation(.interpolatingSpring(stiffness: 170, damping: 15, initialVelocity: 10)) {
                opacity = 0.5
                buttonOffset = 20
            }
            try await Task.sleep(seconds: 1)
            await animateBack()
        } catch {}
    }
    
    private func animateBack() async {
        do {
            if !hintConfirmation {
                return
            }
            withAnimation(.interpolatingSpring(stiffness: 170, damping: 20, initialVelocity: 10)) {
                opacity = 1
                buttonOffset = 0
            }
            try await Task.sleep(seconds: 1)
            await animateHint()
        } catch {}
    }
    
    private func dragGestureChanged(_ gesture: DragGesture.Value, _ geometry: GeometryProxy) {
        hintConfirmation = false
        let threshold = geometry.size.width * 0.75
        
        opacity = 0.5
        
        buttonOffset = min(
            gesture.translation.width,
            threshold
        )
        
        if buttonOffset >= confirmTextMinX {
            opacity = 0
        }
        
        if buttonOffset >= threshold {
            withAnimation(.spring()) {
                isConfirmed = true
                rotationAngle = 270
            }
        } else {
            withAnimation(.spring()) {
                isConfirmed = false
                rotationAngle = 0
            }
        }
    }
    
    private func dragGestureEnded(_ gesture: DragGesture.Value, _ geometry: GeometryProxy) {
        let threshold = geometry.size.width * 0.75
        
        if gesture.translation.width >= threshold && isConfirmed {
            confirmed()
            Task {
                do {
                    try await Task.sleep(seconds: 1)
                    rotationAngle = 0
                    buttonOffset = 0
                    opacity = 1
                    confirmTextMinX = 0
                } catch {}
            }
            
        } else {
            hintConfirmation = true
            buttonOffset = 0
            opacity = 1
            Task { await initiateHintAnimation() }
        }
    }
}

#Preview {
    ConfirmationSlideView(
        isConfirmed: .constant(false),
        confirmed: { }
    )
    .padding()
}
