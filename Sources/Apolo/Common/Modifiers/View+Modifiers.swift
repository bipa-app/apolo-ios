//
//  BackgroundViewModifier.swift
//  Bipa
//
//  Created by Luiz Parreira on 27/03/23.
//  Copyright © 2023 Bipa. All rights reserved.
//

import SwiftUI

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = value + nextValue()
    }
}

struct ViewHeightBackgroundModifier<B: View>: ViewModifier {
    var background: B
    var height: (CGFloat) -> Void

    func body(content: Content) -> some View {
        content.background(
            background
                .padding(.top, 1)
                .padding(.bottom, -1)
                .background(GeometryReader { proxy in
                    Color.clear.preference(key: ViewHeightKey.self, value: proxy.size.height)
                })
        )
        .onPreferenceChange(ViewHeightKey.self) { h in
            height(h)
        }
    }
}

struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct ViewSizeBackgroundModifier<B: View>: ViewModifier {
    var background: B
    var size: (CGSize) -> Void

    func body(content: Content) -> some View {
        content.background(
            background
                .background(GeometryReader { proxy in
                    Color.clear
                        .onChange(of: proxy.size) {
                            size($0)
                        }
                })
        )
    }
}

struct BackgroundViewModifier<B: View>: ViewModifier {
    var background: B
    var geometry: (GeometryProxy) -> Void

    func body(content: Content) -> some View {
        content.background(
            GeometryReader { proxy in
                background.onAppear {
                    geometry(proxy)
                }
            },
            alignment: .center
        )
    }
}

extension View {
    func backgroundGeometryProxy<B: View>(
        background: B = Color.clear,
        _ geometry: @escaping (GeometryProxy) -> Void
    ) -> some View {
        modifier(BackgroundViewModifier(background: background, geometry: geometry))
    }

    func backgroundGeometryProxy(
        color: Color = Color.clear,
        _ geometry: @escaping (GeometryProxy) -> Void
    ) -> some View {
        backgroundGeometryProxy(background: color, geometry)
    }

    func viewHeightBackground(
        color: Color = Color.clear,
        _ height: @escaping (CGFloat) -> Void
    ) -> some View {
        modifier(ViewHeightBackgroundModifier(background: color, height: height))
    }

    func backgroundSize(
        color: Color = .clear,
        _ size: @escaping (CGSize) -> Void
    ) -> some View {
        modifier(ViewSizeBackgroundModifier(background: color, size: size))
    }
}
