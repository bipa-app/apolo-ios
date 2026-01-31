//
//  Balance.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - CurrencyUnit

public enum CurrencyUnit: String, CaseIterable {
    case btc = "BTC"
    case sats = "sats"
    case fiat = "BRL"

    var symbol: String {
        switch self {
        case .btc: return "₿"
        case .sats: return "sats"
        case .fiat: return "R$"
        }
    }
}

// MARK: - BalanceDisplay

public struct BalanceDisplay: View {
    let btcAmount: Double
    let fiatAmount: Double
    let fiatCurrency: String
    let isHidden: Bool
    let primaryUnit: CurrencyUnit
    let onToggleVisibility: (() -> Void)?
    let onToggleUnit: (() -> Void)?

    public init(
        btcAmount: Double,
        fiatAmount: Double,
        fiatCurrency: String = "BRL",
        isHidden: Bool = false,
        primaryUnit: CurrencyUnit = .btc,
        onToggleVisibility: (() -> Void)? = nil,
        onToggleUnit: (() -> Void)? = nil
    ) {
        self.btcAmount = btcAmount
        self.fiatAmount = fiatAmount
        self.fiatCurrency = fiatCurrency
        self.isHidden = isHidden
        self.primaryUnit = primaryUnit
        self.onToggleVisibility = onToggleVisibility
        self.onToggleUnit = onToggleUnit
    }

    private var primaryDisplay: String {
        if isHidden { return "••••••" }
        switch primaryUnit {
        case .btc:
            return formatBTC(btcAmount)
        case .sats:
            return formatSats(btcAmount)
        case .fiat:
            return formatFiat(fiatAmount)
        }
    }

    private var secondaryDisplay: String {
        if isHidden { return "••••" }
        switch primaryUnit {
        case .btc, .sats:
            return formatFiat(fiatAmount)
        case .fiat:
            return formatBTC(btcAmount)
        }
    }

    private func formatBTC(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 8
        formatter.maximumFractionDigits = 8
        return "₿ \(formatter.string(from: NSNumber(value: amount)) ?? "0")"
    }

    private func formatSats(_ btcAmount: Double) -> String {
        let sats = Int(btcAmount * 100_000_000)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return "\(formatter.string(from: NSNumber(value: sats)) ?? "0") sats"
    }

    private func formatFiat(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = fiatCurrency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: amount)) ?? "R$ 0,00"
    }

    public var body: some View {
        VStack(spacing: Tokens.Spacing.extraSmall) {
            // Primary balance
            HStack(spacing: Tokens.Spacing.extraSmall) {
                Text(primaryDisplay)
                    .font(.abcGinto(size: 36, weight: .bold))
                    .foregroundStyle(Color(.label))
                    .contentTransition(.numericText())

                if let onToggleVisibility {
                    Button {
                        onToggleVisibility()
                    } label: {
                        Image(systemName: isHidden ? "eye.slash.fill" : "eye.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color(.secondaryLabel))
                    }
                }
            }

            // Secondary balance
            Button {
                onToggleUnit?()
            } label: {
                HStack(spacing: Tokens.Spacing.extraExtraSmall) {
                    Text(secondaryDisplay)
                        .font(.abcGinto(style: .body, weight: .regular))
                        .foregroundStyle(Color(.secondaryLabel))

                    if onToggleUnit != nil {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 12))
                            .foregroundStyle(Color(.tertiaryLabel))
                    }
                }
            }
            .disabled(onToggleUnit == nil)
            .buttonStyle(.plain)
        }
    }
}

// MARK: - BalanceRow

public struct BalanceRow: View {
    let title: String
    let btcAmount: Double
    let fiatAmount: Double
    let icon: String?
    let iconColor: Color
    let isHidden: Bool

    public init(
        title: String,
        btcAmount: Double,
        fiatAmount: Double,
        icon: String? = nil,
        iconColor: Color = Color(.systemBlue),
        isHidden: Bool = false
    ) {
        self.title = title
        self.btcAmount = btcAmount
        self.fiatAmount = fiatAmount
        self.icon = icon
        self.iconColor = iconColor
        self.isHidden = isHidden
    }

    private var btcDisplay: String {
        if isHidden { return "••••••" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 8
        formatter.maximumFractionDigits = 8
        return "₿ \(formatter.string(from: NSNumber(value: btcAmount)) ?? "0")"
    }

    private var fiatDisplay: String {
        if isHidden { return "••••" }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: fiatAmount)) ?? "R$ 0,00"
    }

    public var body: some View {
        HStack(spacing: Tokens.Spacing.small) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .background(iconColor)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                Text(title)
                    .font(.abcGinto(style: .subheadline, weight: .medium))
                    .foregroundStyle(Color(.label))

                Text(fiatDisplay)
                    .font(.abcGinto(style: .footnote, weight: .regular))
                    .foregroundStyle(Color(.secondaryLabel))
            }

            Spacer()

            Text(btcDisplay)
                .font(.abcGinto(style: .body, weight: .bold))
                .foregroundStyle(Color(.label))
        }
        .padding(.vertical, Tokens.Spacing.extraSmall)
    }
}

// MARK: - BalanceCard

public struct BalanceCard: View {
    let btcAmount: Double
    let fiatAmount: Double
    let percentageChange: Double?
    let isHidden: Bool
    let onSend: () -> Void
    let onReceive: () -> Void

    public init(
        btcAmount: Double,
        fiatAmount: Double,
        percentageChange: Double? = nil,
        isHidden: Bool = false,
        onSend: @escaping () -> Void,
        onReceive: @escaping () -> Void
    ) {
        self.btcAmount = btcAmount
        self.fiatAmount = fiatAmount
        self.percentageChange = percentageChange
        self.isHidden = isHidden
        self.onSend = onSend
        self.onReceive = onReceive
    }

    public var body: some View {
        VStack(spacing: Tokens.Spacing.large) {
            VStack(spacing: Tokens.Spacing.extraSmall) {
                BalanceDisplay(
                    btcAmount: btcAmount,
                    fiatAmount: fiatAmount,
                    isHidden: isHidden
                )

                if let change = percentageChange, !isHidden {
                    HStack(spacing: Tokens.Spacing.extraExtraSmall) {
                        Image(systemName: change >= 0 ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 12, weight: .bold))

                        Text(String(format: "%.2f%%", abs(change)))
                            .font(.abcGinto(style: .footnote, weight: .medium))
                    }
                    .foregroundStyle(change >= 0 ? Color(.systemGreen) : Color(.systemRed))
                }
            }

            HStack(spacing: Tokens.Spacing.medium) {
                Button {
                    onSend()
                } label: {
                    Label("Send", systemImage: "arrow.up.right")
                }
                .borderedProminentStyle(color: Tokens.Color.violet.color)

                Button {
                    onReceive()
                } label: {
                    Label("Receive", systemImage: "arrow.down.left")
                }
                .borderedStyle(color: Tokens.Color.violet.color)
            }
        }
        .padding(Tokens.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: Tokens.CornerRadius.large)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

// MARK: - Preview

@available(iOS 17.0, *)
#Preview("Balance Display") {
    @Previewable @State var isHidden = false
    @Previewable @State var unit: CurrencyUnit = .btc

    return VStack(spacing: Tokens.Spacing.extraLarge) {
        BalanceDisplay(
            btcAmount: 0.00123456,
            fiatAmount: 1234.56,
            isHidden: isHidden,
            primaryUnit: unit,
            onToggleVisibility: { isHidden.toggle() },
            onToggleUnit: {
                switch unit {
                case .btc: unit = .sats
                case .sats: unit = .fiat
                case .fiat: unit = .btc
                }
            }
        )

        Divider()

        BalanceDisplay(
            btcAmount: 1.5,
            fiatAmount: 750000,
            isHidden: true
        )
    }
    .padding()
}

#Preview("Balance Rows") {
    VStack(spacing: 0) {
        BalanceRow(
            title: "Main Wallet",
            btcAmount: 0.00123456,
            fiatAmount: 1234.56,
            icon: "bitcoinsign.circle.fill",
            iconColor: Color(.systemOrange)
        )
        Divider()
        BalanceRow(
            title: "Savings",
            btcAmount: 0.5,
            fiatAmount: 250000,
            icon: "lock.fill",
            iconColor: Color(.systemGreen)
        )
        Divider()
        BalanceRow(
            title: "Hidden Balance",
            btcAmount: 0.1,
            fiatAmount: 50000,
            icon: "eye.slash.fill",
            iconColor: Color(.systemGray),
            isHidden: true
        )
    }
    .padding()
}

#Preview("Balance Card") {
    BalanceCard(
        btcAmount: 0.00123456,
        fiatAmount: 1234.56,
        percentageChange: 2.5,
        onSend: { print("Send") },
        onReceive: { print("Receive") }
    )
    .padding()
}
