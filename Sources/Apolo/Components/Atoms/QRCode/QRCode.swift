//
//  QRCode.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

// MARK: - QRCodeView

public struct QRCodeView: View {
    let data: String
    let size: CGFloat
    let foregroundColor: Color
    let backgroundColor: Color
    let logo: Image?
    let logoSize: CGFloat

    @State private var qrImage: UIImage?

    public init(
        data: String,
        size: CGFloat = 200,
        foregroundColor: Color = .black,
        backgroundColor: Color = .white,
        logo: Image? = nil,
        logoSize: CGFloat = 40
    ) {
        self.data = data
        self.size = size
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.logo = logo
        self.logoSize = logoSize
    }

    public var body: some View {
        ZStack {
            if let qrImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .frame(width: size, height: size)
            } else {
                Rectangle()
                    .fill(backgroundColor)
                    .frame(width: size, height: size)
                    .overlay(
                        Spinner(size: 30)
                    )
            }

            if let logo {
                logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: logoSize, height: logoSize)
                    .background(backgroundColor)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))
        .onAppear {
            generateQRCode()
        }
        .onChange(of: data) { _ in
            generateQRCode()
        }
    }

    private func generateQRCode() {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        filter.message = Data(data.utf8)
        filter.correctionLevel = "H"

        guard let ciImage = filter.outputImage else { return }

        let scale = size / ciImage.extent.width
        let scaledImage = ciImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

        // Apply colors
        let colorFilter = CIFilter.falseColor()
        colorFilter.inputImage = scaledImage
        colorFilter.color0 = CIColor(color: UIColor(foregroundColor))
        colorFilter.color1 = CIColor(color: UIColor(backgroundColor))

        guard let coloredImage = colorFilter.outputImage,
              let cgImage = context.createCGImage(coloredImage, from: coloredImage.extent) else {
            return
        }

        qrImage = UIImage(cgImage: cgImage)
    }
}

// MARK: - QRCodeCard

public struct QRCodeCard: View {
    let title: String
    let subtitle: String?
    let data: String
    let showCopyButton: Bool
    let showShareButton: Bool
    let onCopy: (() -> Void)?
    let onShare: (() -> Void)?

    @State private var copied = false

    public init(
        title: String,
        subtitle: String? = nil,
        data: String,
        showCopyButton: Bool = true,
        showShareButton: Bool = true,
        onCopy: (() -> Void)? = nil,
        onShare: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.data = data
        self.showCopyButton = showCopyButton
        self.showShareButton = showShareButton
        self.onCopy = onCopy
        self.onShare = onShare
    }

    public var body: some View {
        VStack(spacing: Tokens.Spacing.large) {
            VStack(spacing: Tokens.Spacing.extraSmall) {
                Text(title)
                    .font(.abcGinto(style: .headline, weight: .bold))
                    .foregroundStyle(Color(.label))

                if let subtitle {
                    Text(subtitle)
                        .font(.abcGinto(style: .footnote, weight: .regular))
                        .foregroundStyle(Color(.secondaryLabel))
                }
            }

            QRCodeView(data: data, size: 200)
                .padding(Tokens.Spacing.medium)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))

            // Address display
            Text(truncatedAddress)
                .font(.system(.footnote, design: .monospaced))
                .foregroundStyle(Color(.secondaryLabel))
                .lineLimit(1)

            // Action buttons
            HStack(spacing: Tokens.Spacing.medium) {
                if showCopyButton {
                    Button {
                        UIPasteboard.general.string = data
                        withAnimation {
                            copied = true
                        }
                        onCopy?()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                copied = false
                            }
                        }
                    } label: {
                        Label(
                            copied ? "Copied!" : "Copy",
                            systemImage: copied ? "checkmark" : "doc.on.doc"
                        )
                    }
                    .borderedStyle(color: copied ? .green : Tokens.Color.violet.color)
                }

                if showShareButton {
                    ShareLink(item: data) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }
                    .borderedProminentStyle(color: Tokens.Color.violet.color)
                }
            }
        }
        .padding(Tokens.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: Tokens.CornerRadius.large)
                .fill(Color(.secondarySystemBackground))
        )
    }

    private var truncatedAddress: String {
        guard data.count > 20 else { return data }
        return String(data.prefix(12)) + "..." + String(data.suffix(8))
    }
}

// MARK: - AddressDisplay

public struct AddressDisplay: View {
    let address: String
    let label: String?
    let isCopyable: Bool

    @State private var copied = false

    public init(
        address: String,
        label: String? = nil,
        isCopyable: Bool = true
    ) {
        self.address = address
        self.label = label
        self.isCopyable = isCopyable
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
            if let label {
                Text(label)
                    .font(.abcGinto(style: .caption, weight: .medium))
                    .foregroundStyle(Color(.secondaryLabel))
            }

            HStack {
                Text(address)
                    .font(.system(.footnote, design: .monospaced))
                    .foregroundStyle(Color(.label))
                    .lineLimit(1)
                    .truncationMode(.middle)

                Spacer()

                if isCopyable {
                    Button {
                        UIPasteboard.general.string = address
                        withAnimation {
                            copied = true
                        }
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                copied = false
                            }
                        }
                    } label: {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .font(.system(size: 14))
                            .foregroundStyle(copied ? .green : Color(.secondaryLabel))
                    }
                }
            }
            .padding(Tokens.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                    .fill(Color(.tertiarySystemFill))
            )
        }
    }
}

// MARK: - Preview

#Preview("QR Code View") {
    VStack(spacing: Tokens.Spacing.large) {
        QRCodeView(
            data: "bitcoin:bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
            size: 200
        )

        QRCodeView(
            data: "bitcoin:bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
            size: 150,
            foregroundColor: Tokens.Color.violet.color,
            backgroundColor: .white
        )
    }
    .padding()
}

#Preview("QR Code Card") {
    QRCodeCard(
        title: "Receive Bitcoin",
        subtitle: "Scan this QR code to send Bitcoin",
        data: "bitcoin:bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh"
    )
    .padding()
}

#Preview("Address Display") {
    VStack(spacing: Tokens.Spacing.medium) {
        AddressDisplay(
            address: "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
            label: "Bitcoin Address"
        )

        AddressDisplay(
            address: "lnbc1500n1p3yfnmapp5qqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqf",
            label: "Lightning Invoice"
        )
    }
    .padding()
}
