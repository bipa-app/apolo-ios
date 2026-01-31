//
//  Transaction.swift
//  Apolo
//
//  Created by Apolo on 2025.
//

import SwiftUI

// MARK: - TransactionType

public enum TransactionType {
    case sent
    case received
    case pending

    var icon: String {
        switch self {
        case .sent: return "arrow.up.right"
        case .received: return "arrow.down.left"
        case .pending: return "clock"
        }
    }

    var iconColor: Color {
        switch self {
        case .sent: return Color(.systemRed)
        case .received: return Color(.systemGreen)
        case .pending: return Color(.systemOrange)
        }
    }

    var backgroundColor: Color {
        switch self {
        case .sent: return Color(.systemRed).opacity(0.1)
        case .received: return Color(.systemGreen).opacity(0.1)
        case .pending: return Color(.systemOrange).opacity(0.1)
        }
    }

    var amountPrefix: String {
        switch self {
        case .sent: return "-"
        case .received: return "+"
        case .pending: return ""
        }
    }
}

// MARK: - TransactionStatus

public enum TransactionStatus {
    case pending
    case confirmed
    case failed

    var label: String {
        switch self {
        case .pending: return "Pending"
        case .confirmed: return "Confirmed"
        case .failed: return "Failed"
        }
    }

    var color: Color {
        switch self {
        case .pending: return Color(.systemOrange)
        case .confirmed: return Color(.systemGreen)
        case .failed: return Color(.systemRed)
        }
    }
}

// MARK: - TransactionIcon

public struct TransactionIcon: View {
    let type: TransactionType
    let size: CGFloat

    public init(type: TransactionType, size: CGFloat = 40) {
        self.type = type
        self.size = size
    }

    public var body: some View {
        Image(systemName: type.icon)
            .font(.system(size: size * 0.4, weight: .semibold))
            .foregroundStyle(type.iconColor)
            .frame(width: size, height: size)
            .background(type.backgroundColor)
            .clipShape(Circle())
    }
}

// MARK: - TransactionItem

public struct TransactionItem: View {
    let type: TransactionType
    let title: String
    let subtitle: String?
    let btcAmount: Double
    let fiatAmount: Double?
    let timestamp: Date
    let status: TransactionStatus
    let action: (() -> Void)?

    public init(
        type: TransactionType,
        title: String,
        subtitle: String? = nil,
        btcAmount: Double,
        fiatAmount: Double? = nil,
        timestamp: Date,
        status: TransactionStatus = .confirmed,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.btcAmount = btcAmount
        self.fiatAmount = fiatAmount
        self.timestamp = timestamp
        self.status = status
        self.action = action
    }

    private var btcDisplay: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 8
        formatter.maximumFractionDigits = 8
        let formatted = formatter.string(from: NSNumber(value: btcAmount)) ?? "0"
        return "\(type.amountPrefix)\(formatted) BTC"
    }

    private var fiatDisplay: String? {
        guard let fiatAmount else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: fiatAmount))
    }

    private var timeDisplay: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }

    public var body: some View {
        Button {
            action?()
        } label: {
            HStack(spacing: Tokens.Spacing.small) {
                TransactionIcon(type: type)

                VStack(alignment: .leading, spacing: Tokens.Spacing.extraExtraSmall) {
                    Text(title)
                        .font(.abcGinto(style: .body, weight: .medium))
                        .foregroundStyle(Color(.label))

                    HStack(spacing: Tokens.Spacing.extraExtraSmall) {
                        if let subtitle {
                            Text(subtitle)
                                .font(.abcGinto(style: .footnote, weight: .regular))
                                .foregroundStyle(Color(.secondaryLabel))
                                .lineLimit(1)
                        }

                        if status != .confirmed {
                            Text("•")
                                .foregroundStyle(Color(.tertiaryLabel))

                            Text(status.label)
                                .font(.abcGinto(style: .footnote, weight: .medium))
                                .foregroundStyle(status.color)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: Tokens.Spacing.extraExtraSmall) {
                    Text(btcDisplay)
                        .font(.abcGinto(style: .body, weight: .bold))
                        .foregroundStyle(
                            type == .received ? Color(.systemGreen) :
                            type == .sent ? Color(.label) :
                            Color(.secondaryLabel)
                        )

                    if let fiat = fiatDisplay {
                        Text(fiat)
                            .font(.abcGinto(style: .footnote, weight: .regular))
                            .foregroundStyle(Color(.secondaryLabel))
                    } else {
                        Text(timeDisplay)
                            .font(.abcGinto(style: .footnote, weight: .regular))
                            .foregroundStyle(Color(.tertiaryLabel))
                    }
                }
            }
            .padding(.vertical, Tokens.Spacing.small)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - TransactionGroup

public struct TransactionGroup<Content: View>: View {
    let title: String
    let content: Content

    public init(
        title: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.extraSmall) {
            Text(title)
                .font(.abcGinto(style: .footnote, weight: .medium))
                .foregroundStyle(Color(.secondaryLabel))

            VStack(spacing: 0) {
                content
            }
            .padding(.horizontal, Tokens.Spacing.medium)
            .background(
                RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                    .fill(Color(.secondarySystemBackground))
            )
        }
    }
}

// MARK: - TransactionDetail

public struct TransactionDetail: View {
    let type: TransactionType
    let btcAmount: Double
    let fiatAmount: Double
    let status: TransactionStatus
    let timestamp: Date
    let confirmations: Int?
    let txId: String?
    let address: String?
    let fee: Double?
    let note: String?

    public init(
        type: TransactionType,
        btcAmount: Double,
        fiatAmount: Double,
        status: TransactionStatus,
        timestamp: Date,
        confirmations: Int? = nil,
        txId: String? = nil,
        address: String? = nil,
        fee: Double? = nil,
        note: String? = nil
    ) {
        self.type = type
        self.btcAmount = btcAmount
        self.fiatAmount = fiatAmount
        self.status = status
        self.timestamp = timestamp
        self.confirmations = confirmations
        self.txId = txId
        self.address = address
        self.fee = fee
        self.note = note
    }

    private var formattedBTC: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 8
        formatter.maximumFractionDigits = 8
        return "₿ \(formatter.string(from: NSNumber(value: btcAmount)) ?? "0")"
    }

    private var formattedFiat: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "BRL"
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: fiatAmount)) ?? "R$ 0,00"
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                // Header
                VStack(spacing: Tokens.Spacing.medium) {
                    TransactionIcon(type: type, size: 64)

                    VStack(spacing: Tokens.Spacing.extraExtraSmall) {
                        Text(type == .sent ? "Sent" : type == .received ? "Received" : "Pending")
                            .font(.abcGinto(style: .title3, weight: .bold))
                            .foregroundStyle(Color(.label))

                        HStack(spacing: Tokens.Spacing.extraExtraSmall) {
                            Circle()
                                .fill(status.color)
                                .frame(width: 8, height: 8)

                            Text(status.label)
                                .font(.abcGinto(style: .subheadline, weight: .medium))
                                .foregroundStyle(status.color)
                        }
                    }
                }

                // Amount
                VStack(spacing: Tokens.Spacing.extraExtraSmall) {
                    Text(formattedBTC)
                        .font(.abcGinto(size: 32, weight: .bold))
                        .foregroundStyle(Color(.label))

                    Text(formattedFiat)
                        .font(.abcGinto(style: .body, weight: .regular))
                        .foregroundStyle(Color(.secondaryLabel))
                }

                // Details
                VStack(spacing: 0) {
                    InfoRow(label: "Date", value: formattedDate)
                    Divider()

                    if let confirmations {
                        InfoRow(
                            label: "Confirmations",
                            value: "\(confirmations)",
                            valueColor: confirmations >= 6 ? .green : Color(.label)
                        )
                        Divider()
                    }

                    if let address {
                        InfoRow(
                            label: type == .sent ? "To" : "From",
                            value: String(address.prefix(8)) + "..." + String(address.suffix(8)),
                            isCopyable: true
                        )
                        Divider()
                    }

                    if let txId {
                        InfoRow(
                            label: "Transaction ID",
                            value: String(txId.prefix(8)) + "..." + String(txId.suffix(8)),
                            isCopyable: true
                        )
                        Divider()
                    }

                    if let fee {
                        let feeFormatted = String(format: "%.8f BTC", fee)
                        InfoRow(label: "Network Fee", value: feeFormatted)
                        Divider()
                    }

                    if let note {
                        InfoRow(label: "Note", value: note)
                    }
                }
                .padding(.horizontal, Tokens.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                        .fill(Color(.secondarySystemBackground))
                )
            }
            .padding()
        }
    }
}

// MARK: - Preview

#Preview("Transaction Items") {
    VStack(spacing: 0) {
        TransactionItem(
            type: .received,
            title: "Received Bitcoin",
            subtitle: "From: 1A2b3C...x9Y0Z",
            btcAmount: 0.00050000,
            fiatAmount: 250.00,
            timestamp: Date().addingTimeInterval(-3600)
        ) {
            print("Tapped")
        }

        Divider().padding(.leading, 56)

        TransactionItem(
            type: .sent,
            title: "Sent to John",
            btcAmount: 0.00025000,
            fiatAmount: 125.00,
            timestamp: Date().addingTimeInterval(-86400)
        )

        Divider().padding(.leading, 56)

        TransactionItem(
            type: .pending,
            title: "Pending Transaction",
            btcAmount: 0.00100000,
            timestamp: Date().addingTimeInterval(-300),
            status: .pending
        )
    }
    .padding()
}

#Preview("Transaction Group") {
    ScrollView {
        VStack(spacing: Tokens.Spacing.large) {
            TransactionGroup(title: "Today") {
                TransactionItem(
                    type: .received,
                    title: "Received Bitcoin",
                    btcAmount: 0.00050000,
                    timestamp: Date().addingTimeInterval(-3600)
                )
            }

            TransactionGroup(title: "Yesterday") {
                TransactionItem(
                    type: .sent,
                    title: "Sent to Maria",
                    btcAmount: 0.00025000,
                    timestamp: Date().addingTimeInterval(-86400)
                )

                Divider().padding(.leading, 56)

                TransactionItem(
                    type: .received,
                    title: "Received from João",
                    btcAmount: 0.00100000,
                    timestamp: Date().addingTimeInterval(-90000)
                )
            }
        }
        .padding()
    }
}

#Preview("Transaction Detail") {
    TransactionDetail(
        type: .received,
        btcAmount: 0.00123456,
        fiatAmount: 617.28,
        status: .confirmed,
        timestamp: Date().addingTimeInterval(-3600),
        confirmations: 12,
        txId: "a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0",
        address: "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
        fee: 0.00001234,
        note: "Payment for dinner"
    )
}
