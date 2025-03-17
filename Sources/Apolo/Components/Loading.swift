//
//  Loading.swift
//  Apolo
//
//  Created by Luiz Parreira on 13/03/25.
//

import Foundation
import SwiftUI

struct LoadingModifier: ViewModifier {
    @Binding var isPresented: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ProgressView()
                        .progressViewStyle(LoadingProgressViewStyle())
                        .zIndex(2)
                        .transition(.opacity)
                } else {
                    EmptyView()
                }
            }
    }

    struct LoadingProgressViewStyle: ProgressViewStyle {
        func makeBody(configuration: Configuration) -> some View {
            ProgressView(configuration)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                        .foregroundStyle(.ultraThinMaterial)
                )
        }
    }
}

// MARK: - View extensions

public extension View {
    /// Presents a loading alert view
    /// - Parameters:
    ///   - isLoading: A binding to a Boolean value that determines whether to present the alert.
    ///
    func loading(isLoading: Binding<Bool>) -> some View {
        disabled(isLoading.wrappedValue)
            .modifier(LoadingModifier(isPresented: isLoading))
    }
}

// MARK: - Preview

struct CustomAlertPreview: View {
    @State private var isPresented = false

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Button("Show Alert") {
                    isPresented = true

                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        isPresented = false
                    }
                }
                Spacer()
            }
        }
        .loading(isLoading: $isPresented)
    }
}

#Preview {
    CustomAlertPreview()
}
