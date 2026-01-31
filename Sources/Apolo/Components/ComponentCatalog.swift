//
//  ComponentCatalog.swift
//  Apolo
//
//  A comprehensive preview of all Apolo Design System components.
//

import SwiftUI

// MARK: - Component Catalog

public struct ComponentCatalog: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            List {
                Section("Tokens") {
                    NavigationLink("Colors") { ColorsCatalog() }
                    NavigationLink("Typography") { TypographyCatalog() }
                    NavigationLink("Spacing & Radius") { SpacingCatalog() }
                    NavigationLink("Shadows") { ShadowsCatalog() }
                }

                Section("Form Inputs") {
                    NavigationLink("Text Fields") { TextFieldsCatalog() }
                    NavigationLink("Keyboards") { KeyboardsCatalog() }
                    NavigationLink("Checkboxes & Radio") { FormControlsCatalog() }
                }

                Section("Feedback") {
                    NavigationLink("Notifications") { NotificationsCatalog() }
                    NavigationLink("Progress & Loading") { ProgressCatalog() }
                }

                Section("Navigation & Layout") {
                    NavigationLink("Headers") { HeadersCatalog() }
                    NavigationLink("Rows") { RowsCatalog() }
                    NavigationLink("Tab Bar") { TabBarCatalog() }
                    NavigationLink("Bottom Sheet") { BottomSheetCatalog() }
                }

                Section("Fintech Components") {
                    NavigationLink("Balance") { BalanceCatalog() }
                    NavigationLink("Transactions") { TransactionsCatalog() }
                    NavigationLink("QR Codes") { QRCodesCatalog() }
                }

                Section("Atoms") {
                    NavigationLink("Buttons") { ButtonsCatalog() }
                    NavigationLink("Tags") { TagsCatalog() }
                    NavigationLink("Cards") { CardsCatalog() }
                }
            }
            .navigationTitle("Apolo Components")
        }
    }
}

// MARK: - Colors Catalog

private struct ColorsCatalog: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Custom Colors") {
                    HStack(spacing: Tokens.Spacing.medium) {
                        colorSwatch("Violet", Tokens.Color.violet.color)
                        colorSwatch("Rose", Tokens.Color.rose.color)
                    }
                }

                catalogSection("System Colors") {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: Tokens.Spacing.small) {
                        colorSwatch("Blue", Color(.systemBlue))
                        colorSwatch("Green", Color(.systemGreen))
                        colorSwatch("Orange", Color(.systemOrange))
                        colorSwatch("Red", Color(.systemRed))
                        colorSwatch("Teal", Color(.systemTeal))
                        colorSwatch("Yellow", Color(.systemYellow))
                    }
                }

                catalogSection("Semantic Colors") {
                    VStack(spacing: Tokens.Spacing.small) {
                        colorRow("Label", Color(.label))
                        colorRow("Secondary Label", Color(.secondaryLabel))
                        colorRow("Tertiary Label", Color(.tertiaryLabel))
                        colorRow("System Background", Color(.systemBackground))
                        colorRow("Secondary Background", Color(.secondarySystemBackground))
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Colors")
    }

    private func colorSwatch(_ name: String, _ color: Color) -> some View {
        VStack(spacing: Tokens.Spacing.extraSmall) {
            RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                .fill(color)
                .frame(height: 60)
            Text(name)
                .font(.abcGinto(style: .caption, weight: .medium))
                .foregroundStyle(Color(.secondaryLabel))
        }
    }

    private func colorRow(_ name: String, _ color: Color) -> some View {
        HStack {
            Text(name)
                .font(.abcGinto(style: .body, weight: .regular))
            Spacer()
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 60, height: 30)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(Color(.separator), lineWidth: 1)
                )
        }
    }
}

// MARK: - Typography Catalog

private struct TypographyCatalog: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Tokens.Spacing.large) {
                catalogSection("Display Styles") {
                    VStack(alignment: .leading, spacing: Tokens.Spacing.medium) {
                        Text("Extra Large Title")
                            .extraLargeTitle()
                        Text("Extra Large Title 2")
                            .extraLargeTitle2()
                    }
                }

                catalogSection("Heading Styles") {
                    VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
                        Text("Title 1").title1()
                        Text("Title 2").title2()
                        Text("Title 3").title3()
                        Text("Headline").headline()
                    }
                }

                catalogSection("Body Styles") {
                    VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
                        Text("Body Regular").body()
                        Text("Body Medium").body(weight: .medium)
                        Text("Callout").callout()
                        Text("Subheadline").subheadline()
                    }
                }

                catalogSection("Small Styles") {
                    VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
                        Text("Footnote").footnote()
                        Text("Caption 1").caption1()
                        Text("Caption 2").caption2()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Typography")
    }
}

// MARK: - Spacing Catalog

private struct SpacingCatalog: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Spacing Scale") {
                    VStack(spacing: Tokens.Spacing.small) {
                        spacingRow("Extra Extra Small", Tokens.Spacing.extraExtraSmall)
                        spacingRow("Extra Small", Tokens.Spacing.extraSmall)
                        spacingRow("Small", Tokens.Spacing.small)
                        spacingRow("Medium", Tokens.Spacing.medium)
                        spacingRow("Large", Tokens.Spacing.large)
                        spacingRow("Extra Large", Tokens.Spacing.extraLarge)
                        spacingRow("Extra Extra Large", Tokens.Spacing.extraExtraLarge)
                    }
                }

                catalogSection("Corner Radius") {
                    HStack(spacing: Tokens.Spacing.medium) {
                        radiusSwatch("Small", Tokens.CornerRadius.small)
                        radiusSwatch("Medium", Tokens.CornerRadius.medium)
                        radiusSwatch("Large", Tokens.CornerRadius.large)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Spacing & Radius")
    }

    private func spacingRow(_ name: String, _ value: CGFloat) -> some View {
        HStack {
            Text(name)
                .font(.abcGinto(style: .body, weight: .regular))
            Spacer()
            Text("\(Int(value))pt")
                .font(.abcGinto(style: .body, weight: .medium))
                .foregroundStyle(Color(.secondaryLabel))
            RoundedRectangle(cornerRadius: 2)
                .fill(Tokens.Color.violet.color)
                .frame(width: value, height: 20)
        }
    }

    private func radiusSwatch(_ name: String, _ radius: CGFloat) -> some View {
        VStack(spacing: Tokens.Spacing.extraSmall) {
            RoundedRectangle(cornerRadius: radius)
                .fill(Tokens.Color.violet.color.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: radius)
                        .strokeBorder(Tokens.Color.violet.color, lineWidth: 2)
                )
            Text(name)
                .font(.abcGinto(style: .caption, weight: .medium))
            Text("\(Int(radius))pt")
                .font(.abcGinto(style: .caption2, weight: .regular))
                .foregroundStyle(Color(.secondaryLabel))
        }
    }
}

// MARK: - Shadows Catalog

private struct ShadowsCatalog: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.extraLarge) {
                catalogSection("Shadow Levels") {
                    HStack(spacing: Tokens.Spacing.large) {
                        shadowCard("Small", .small)
                        shadowCard("Medium", .medium)
                        shadowCard("Large", .large)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Shadows")
        .background(Color(.secondarySystemBackground))
    }

    private func shadowCard(_ name: String, _ shadow: Tokens.Shadow) -> some View {
        VStack(spacing: Tokens.Spacing.small) {
            RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium)
                .fill(Color(.systemBackground))
                .frame(width: 100, height: 100)
                .shadow(shadow)

            Text(name)
                .font(.abcGinto(style: .caption, weight: .medium))
        }
    }
}

// MARK: - Text Fields Catalog

private struct TextFieldsCatalog: View {
    @State private var text1 = ""
    @State private var text2 = "Hello World"
    @State private var password = ""

    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Outlined Style") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        ApoloTextField(
                            text: $text1,
                            label: "Email",
                            placeholder: "Enter your email",
                            helperText: "We'll never share your email",
                            leadingIcon: "envelope.fill"
                        )

                        ApoloTextField(
                            text: $text2,
                            label: "Username",
                            placeholder: "Choose a username",
                            leadingIcon: "person.fill",
                            maxLength: 20
                        )
                    }
                }

                catalogSection("With Error State") {
                    ApoloTextField(
                        text: .constant(""),
                        label: "Required Field",
                        placeholder: "This field is required",
                        errorMessage: "This field cannot be empty"
                    )
                }

                catalogSection("Filled Style") {
                    ApoloTextField(
                        text: $text1,
                        label: "Search",
                        placeholder: "Search...",
                        leadingIcon: "magnifyingglass",
                        style: .filled
                    )
                }

                catalogSection("Secure Field") {
                    ApoloSecureTextField(
                        text: $password,
                        label: "Password",
                        placeholder: "Enter your password",
                        helperText: "Must be at least 8 characters"
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Text Fields")
    }
}

// MARK: - Keyboards Catalog

private struct KeyboardsCatalog: View {
    @State private var numericValue = ""
    @State private var pin = ""
    @State private var pinError: String? = nil

    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.extraLarge) {
                catalogSection("Numeric Keyboard") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        Text(numericValue.isEmpty ? "0" : numericValue)
                            .font(.abcGinto(size: 36, weight: .bold))

                        NumericKeyboard(showDecimal: true) { key in
                            handleNumericKey(key)
                        }
                    }
                }

                catalogSection("PIN Entry") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        PINDotsView(length: 6, filledCount: pin.count)

                        if let error = pinError {
                            Text(error)
                                .font(.abcGinto(style: .footnote, weight: .medium))
                                .foregroundStyle(Color(.systemRed))
                        }

                        NumericKeyboard(showBiometric: true) { key in
                            handlePINKey(key)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Keyboards")
    }

    private func handleNumericKey(_ key: KeyboardKey) {
        switch key {
        case let .digit(d): numericValue += "\(d)"
        case .decimal: if !numericValue.contains(",") { numericValue += numericValue.isEmpty ? "0," : "," }
        case .delete: if !numericValue.isEmpty { numericValue.removeLast() }
        default: break
        }
    }

    private func handlePINKey(_ key: KeyboardKey) {
        switch key {
        case let .digit(d):
            guard pin.count < 6 else { return }
            pin += "\(d)"
            if pin.count == 6 {
                if pin != "123456" {
                    pinError = "Incorrect PIN"
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        pin = ""
                        pinError = nil
                    }
                }
            }
        case .delete: if !pin.isEmpty { pin.removeLast() }
        case .biometric: print("Biometric tapped")
        default: break
        }
    }
}

// MARK: - Form Controls Catalog

private struct FormControlsCatalog: View {
    @State private var isChecked1 = false
    @State private var isChecked2 = true
    @State private var selectedOption = "option1"

    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Checkboxes") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        Checkbox(label: "Accept terms and conditions", isChecked: $isChecked1)
                        Checkbox(
                            label: "Subscribe to newsletter",
                            description: "Get weekly updates about new features",
                            isChecked: $isChecked2
                        )
                    }
                }

                catalogSection("Radio Buttons") {
                    RadioButtonGroup(
                        options: [
                            RadioOption(id: "1", value: "option1", label: "Option 1", description: "First option description"),
                            RadioOption(id: "2", value: "option2", label: "Option 2", description: "Second option description"),
                            RadioOption(id: "3", value: "option3", label: "Option 3")
                        ],
                        selectedValue: $selectedOption
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Checkboxes & Radio")
    }
}

// MARK: - Notifications Catalog

private struct NotificationsCatalog: View {
    @State private var showToast = false

    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Toast Messages") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        Toast(message: "This is an info message", style: .info)
                        Toast(message: "Operation successful!", style: .success)
                        Toast(message: "Please check your input", style: .warning)
                        Toast(message: "Something went wrong", style: .error, actionLabel: "Retry") {}
                    }
                }

                catalogSection("Banners") {
                    VStack(spacing: 0) {
                        Banner(title: "New Update Available", message: "Version 2.0 is ready", style: .info)
                        Banner(title: "Payment Confirmed", style: .success)
                        Banner(title: "Low Balance Warning", style: .warning)
                        Banner(title: "Connection Lost", style: .error)
                    }
                }

                catalogSection("Inline Alerts") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        InlineAlert(title: "Information", message: "Your transaction is being processed.", style: .info)
                        InlineAlert(message: "Payment completed successfully!", style: .success)
                        InlineAlert(title: "Warning", message: "Your session will expire soon.", style: .warning, actionLabel: "Extend") {}
                        InlineAlert(title: "Error", message: "Failed to process payment.", style: .error)
                        InlineAlert(title: "Pro Tip", message: "Use Face ID for faster transactions.", style: .tip, icon: "faceid")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Notifications")
    }
}

// MARK: - Progress Catalog

private struct ProgressCatalog: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Progress Bars") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        ProgressBar(value: 0.3)
                        ProgressBar(value: 0.6, showLabel: true)
                        ProgressBar(value: 1.0, foregroundColor: .green)
                    }
                }

                catalogSection("Stepped Progress") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        SteppedProgressBar(currentStep: 1, totalSteps: 4)
                        SteppedProgressBar(currentStep: 2, totalSteps: 4)
                        SteppedProgressBar(currentStep: 4, totalSteps: 4)
                    }
                }

                catalogSection("Circular Progress") {
                    HStack(spacing: Tokens.Spacing.large) {
                        CircularProgress(value: 0.25, size: 60)
                        CircularProgress(value: 0.5, size: 60)
                        CircularProgress(value: 0.75, size: 60)
                        CircularProgress(value: 1.0, size: 60, foregroundColor: .green)
                    }
                }

                catalogSection("Loading Indicators") {
                    HStack(spacing: Tokens.Spacing.extraLarge) {
                        VStack {
                            Spinner(size: 30)

                            Text("Spinner").caption2()
                        }
                        VStack {
                            LoadingDots()
                            Text("Dots").caption2()
                        }
                    }
                }

                catalogSection("Skeletons") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        SkeletonListRow()
                        SkeletonListRow(showAvatar: false)
                        SkeletonCard()
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Progress & Loading")
    }
}

// MARK: - Headers Catalog

private struct HeadersCatalog: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Navigation Headers") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        NavigationHeader(title: "Settings") {
                            BackButton {}
                        } trailing: {
                            EmptyView()
                        }
                        .background(Color(.systemBackground))

                        NavigationHeader(title: "Wallet", subtitle: "Main Account") {
                            BackButton {}
                        } trailing: {
                            Button {} label: {
                                Image(systemName: "ellipsis")
                            }
                        }
                        .background(Color(.systemBackground))

                        NavigationHeader(title: "Confirm") {
                            EmptyView()
                        } trailing: {
                            CloseButton {}
                        }
                        .background(Color(.systemBackground))
                    }
                }

                catalogSection("Section Headers") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        SectionHeader(title: "Recent Transactions")
                        SectionHeader(title: "Activity", subtitle: "Last 30 days", actionLabel: "See All") {}
                    }
                }

                catalogSection("Page Header") {
                    PageHeader(title: "Welcome back", subtitle: "Here's what's happening today")
                }

                catalogSection("List Header") {
                    ListHeader("Account Settings")
                }
            }
            .padding()
        }
        .navigationTitle("Headers")
    }
}

// MARK: - Rows Catalog

private struct RowsCatalog: View {
    @State private var toggleOn = true

    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("List Rows") {
                    VStack(spacing: 0) {
                        ListRow(title: "Profile", subtitle: "John Doe") {
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(Color(.systemGray))
                        } trailing: {
                            EmptyView()
                        } action: {}

                        Divider().padding(.leading, Tokens.Spacing.medium)

                        ListRow(title: "Account Settings") {
                            EmptyView()
                        } trailing: {
                            Text("Premium")
                                .font(.abcGinto(style: .caption, weight: .medium))
                                .foregroundStyle(Tokens.Color.violet.color)
                        } action: {}
                    }
                    .padding(.horizontal, Tokens.Spacing.medium)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))
                }

                catalogSection("Settings Rows") {
                    VStack(spacing: 0) {
                        SettingsRow(icon: "person.fill", iconColor: .blue, title: "Account", value: "Premium") {}
                        Divider().padding(.leading, 52 + Tokens.Spacing.medium)
                        SettingsRow(icon: "bell.fill", iconColor: .red, title: "Notifications") {}
                        Divider().padding(.leading, 52 + Tokens.Spacing.medium)
                        SettingsRow(icon: "lock.fill", iconColor: .green, title: "Privacy") {}
                    }
                    .padding(.horizontal, Tokens.Spacing.medium)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))
                }

                catalogSection("Toggle Row") {
                    ToggleRow(
                        icon: "bell.fill",
                        iconColor: .orange,
                        title: "Push Notifications",
                        subtitle: "Receive alerts about transactions",
                        isOn: $toggleOn
                    )
                    .padding(.horizontal, Tokens.Spacing.medium)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))
                }

                catalogSection("Info Rows") {
                    VStack(spacing: 0) {
                        InfoRow(label: "Status", value: "Confirmed", valueColor: .green)
                        Divider()
                        InfoRow(label: "Amount", value: "0.00123 BTC")
                        Divider()
                        InfoRow(label: "Transaction ID", value: "abc123...xyz789", isCopyable: true)
                    }
                    .padding(.horizontal, Tokens.Spacing.medium)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))
                }

                catalogSection("Action Rows") {
                    VStack(spacing: 0) {
                        ActionRow(icon: "square.and.arrow.up", title: "Share") {}
                        Divider().padding(.leading, 44 + Tokens.Spacing.medium)
                        ActionRow(icon: "doc.on.doc", title: "Copy Address") {}
                        Divider().padding(.leading, 44 + Tokens.Spacing.medium)
                        ActionRow(icon: "trash", title: "Delete", isDestructive: true) {}
                    }
                    .padding(.horizontal, Tokens.Spacing.medium)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))
                }
            }
            .padding()
        }
        .navigationTitle("Rows")
    }
}

// MARK: - Tab Bar Catalog

private struct TabBarCatalog: View {
    @State private var selectedTab = "home"

    private let tabs: [TabItem] = [
        TabItem(id: "home", icon: "house", label: "Home"),
        TabItem(id: "wallet", icon: "wallet.pass", label: "Wallet", badge: 2),
        TabItem(id: "activity", icon: "clock.arrow.circlepath", label: "Activity"),
        TabItem(id: "settings", icon: "gearshape", label: "Settings")
    ]

    var body: some View {
        VStack(spacing: Tokens.Spacing.large) {
            Spacer()

            Text("Selected: \(selectedTab)")
                .headline()

            Spacer()

            catalogSection("Custom Tab Bar") {
                CustomTabBar(items: tabs, selectedId: $selectedTab)
            }

            catalogSection("Floating Tab Bar") {
                FloatingTabBar(
                    items: Array(tabs.prefix(3)),
                    selectedId: $selectedTab
                )
            }

            catalogSection("Badge View") {
                HStack(spacing: Tokens.Spacing.large) {
                    BadgeView(count: 1)
                    BadgeView(count: 9)
                    BadgeView(count: 42)
                    BadgeView(count: 100)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Tab Bar")
    }
}

// MARK: - Bottom Sheet Catalog

private struct BottomSheetCatalog: View {
    @State private var showSheet = false

    var body: some View {
        VStack(spacing: Tokens.Spacing.large) {
            Spacer()

            Button("Show Bottom Sheet") {
                showSheet = true
            }
            .borderedProminentStyle(color: Tokens.Color.violet.color)

            Spacer()

            catalogSection("Sheet Handle") {
                SheetHandle()
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))
            }

            catalogSection("Action Sheet Preview") {
                ActionSheet(
                    title: "Share Transaction",
                    message: "Choose how to share",
                    items: [
                        ActionSheetItem(title: "Copy Link", icon: "link") {},
                        ActionSheetItem(title: "Share", icon: "square.and.arrow.up") {},
                        ActionSheetItem(title: "Delete", icon: "trash", style: .destructive) {},
                        ActionSheetItem(title: "Cancel", style: .cancel) {}
                    ],
                    onDismiss: {}
                )
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Bottom Sheet")
        .bottomSheet(isPresented: $showSheet, detents: [.medium, .large]) {
            VStack(spacing: Tokens.Spacing.large) {
                PageHeader(title: "Bottom Sheet", subtitle: "Drag to resize or dismiss")

                Text("This is a draggable bottom sheet component.")
                    .foregroundStyle(Color(.secondaryLabel))

                Spacer()

                Button("Close") {
                    showSheet = false
                }
                .borderedProminentStyle(color: Tokens.Color.violet.color)
            }
            .padding()
        }
    }
}

// MARK: - Balance Catalog

private struct BalanceCatalog: View {
    @State private var isHidden = false
    @State private var unit: CurrencyUnit = .btc

    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Balance Display") {
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
                }

                catalogSection("Balance Rows") {
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
                            fiatAmount: 250_000,
                            icon: "lock.fill",
                            iconColor: Color(.systemGreen)
                        )
                        Divider()
                        BalanceRow(
                            title: "Hidden",
                            btcAmount: 0.1,
                            fiatAmount: 50000,
                            icon: "eye.slash.fill",
                            iconColor: Color(.systemGray),
                            isHidden: true
                        )
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))
                }

                catalogSection("Balance Card") {
                    BalanceCard(
                        btcAmount: 0.00123456,
                        fiatAmount: 1234.56,
                        percentageChange: 2.5,
                        onSend: {},
                        onReceive: {}
                    )
                }
            }
            .padding()
        }
        .navigationTitle("Balance")
    }
}

// MARK: - Transactions Catalog

private struct TransactionsCatalog: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Transaction Icons") {
                    HStack(spacing: Tokens.Spacing.large) {
                        VStack {
                            TransactionIcon(type: .received)
                            Text("Received").caption2()
                        }
                        VStack {
                            TransactionIcon(type: .sent)
                            Text("Sent").caption2()
                        }
                        VStack {
                            TransactionIcon(type: .pending)
                            Text("Pending").caption2()
                        }
                    }
                }

                catalogSection("Transaction Items") {
                    VStack(spacing: 0) {
                        TransactionItem(
                            type: .received,
                            title: "Received Bitcoin",
                            subtitle: "From: 1A2b3C...x9Y0Z",
                            btcAmount: 0.00050000,
                            fiatAmount: 250.00,
                            timestamp: Date().addingTimeInterval(-3600)
                        )
                        Divider().padding(.leading, 56 + Tokens.Spacing.medium)
                        TransactionItem(
                            type: .sent,
                            title: "Sent to John",
                            btcAmount: 0.00025000,
                            fiatAmount: 125.00,
                            timestamp: Date().addingTimeInterval(-86400)
                        )
                        Divider().padding(.leading, 56 + Tokens.Spacing.medium)
                        TransactionItem(
                            type: .pending,
                            title: "Pending Transaction",
                            btcAmount: 0.00100000,
                            timestamp: Date().addingTimeInterval(-300),
                            status: .pending
                        )
                    }
                    .padding(.horizontal, Tokens.Spacing.medium)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: Tokens.CornerRadius.medium))
                }

                catalogSection("Transaction Group") {
                    TransactionGroup(title: "Today") {
                        TransactionItem(
                            type: .received,
                            title: "Received Bitcoin",
                            btcAmount: 0.00050000,
                            timestamp: Date()
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Transactions")
    }
}

// MARK: - QR Codes Catalog

private struct QRCodesCatalog: View {
    private let sampleAddress = "bitcoin:bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh"

    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("QR Code View") {
                    HStack(spacing: Tokens.Spacing.large) {
                        QRCodeView(data: sampleAddress, size: 120)
                        QRCodeView(
                            data: sampleAddress,
                            size: 120,
                            foregroundColor: Tokens.Color.violet.color
                        )
                    }
                }

                catalogSection("QR Code Card") {
                    QRCodeCard(
                        title: "Receive Bitcoin",
                        subtitle: "Scan to send BTC",
                        data: sampleAddress
                    )
                }

                catalogSection("Address Display") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        AddressDisplay(
                            address: "bc1qxy2kgdygjrsqtzq2n0yrf2493p83kkfjhx0wlh",
                            label: "Bitcoin Address"
                        )
                        AddressDisplay(
                            address: "lnbc1500n1p3yfnmapp5qqqsyqcyq5rqwzqf",
                            label: "Lightning Invoice"
                        )
                    }
                }
            }
            .padding()
        }
        .navigationTitle("QR Codes")
    }
}

// MARK: - Buttons Catalog

private struct ButtonsCatalog: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Bordered Prominent") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        Button("Primary Button") {}
                            .borderedProminentStyle(color: Tokens.Color.violet.color)

                        Button("With Icon", systemImage: "bitcoinsign.circle.fill") {}
                            .borderedProminentStyle(color: Tokens.Color.violet.color)
                    }
                }

                catalogSection("Bordered") {
                    Button("Secondary Button") {}
                        .borderedStyle(color: Tokens.Color.violet.color)
                }

                catalogSection("Stroked") {
                    Button("Stroked Button") {}
                        .strokedStyle()
                }

                catalogSection("Sizes") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        Button("Small") {}
                            .borderedProminentStyle(color: Tokens.Color.violet.color, size: .small)
                        Button("Regular") {}
                            .borderedProminentStyle(color: Tokens.Color.violet.color, size: .regular)
                        Button("Large") {}
                            .borderedProminentStyle(color: Tokens.Color.violet.color, size: .large)
                    }
                }

                catalogSection("Shapes") {
                    HStack(spacing: Tokens.Spacing.medium) {
                        Button(systemImage: "plus") {}
                            .borderedProminentStyle(shape: .circle, color: Tokens.Color.violet.color)
                        Button("Capsule") {}
                            .borderedProminentStyle(shape: .capsule, color: Tokens.Color.violet.color)
                        Button("Rounded") {}
                            .borderedProminentStyle(shape: .roundedRectangle, color: Tokens.Color.violet.color)
                    }
                }

                catalogSection("Copy Button") {
                    CopyButton(value: "Hello World")
                }
            }
            .padding()
        }
        .navigationTitle("Buttons")
    }
}

// MARK: - Tags Catalog

private struct TagsCatalog: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Tag Styles") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        HStack(spacing: Tokens.Spacing.small) {
                            Tag(style: .label(), title: "Label")
                            Tag(style: .success, title: "Success")
                            Tag(style: .warning, title: "Warning")
                            Tag(style: .error, title: "Error")
                        }

                        HStack(spacing: Tokens.Spacing.small) {
                            Tag(style: .turbo)
                            Tag(style: .custom(backgroundColor: Tokens.Color.violet.color.opacity(0.2), textColor: Tokens.Color.violet.color), title: "Custom")
                        }
                    }
                }

                catalogSection("Tag Sizes") {
                    HStack(spacing: Tokens.Spacing.small) {
                        Tag(style: .label(), title: "Small", size: .small)
                        Tag(style: .label(), title: "Regular", size: .regular)
                    }
                }

                catalogSection("With Icons") {
                    HStack(spacing: Tokens.Spacing.small) {
                        Tag(style: .label(icon: "bitcoinsign.circle.fill"), title: "Bitcoin")
                        Tag(style: .label(icon: "exclamationmark.triangle.fill"), title: "Warning")
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Tags")
    }
}

// MARK: - Cards Catalog

private struct CardsCatalog: View {
    var body: some View {
        ScrollView {
            VStack(spacing: Tokens.Spacing.large) {
                catalogSection("Card Background") {
                    VStack(spacing: Tokens.Spacing.medium) {
                        Text("Primary Style")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .cardBackground()

                        Text("Secondary Style")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .cardBackground(.secondary)

                        Text("Custom Color")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .cardBackground(color: Tokens.Color.violet.color.opacity(0.1))
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Cards")
    }
}

// MARK: - Helper Views

private func catalogSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
    VStack(alignment: .leading, spacing: Tokens.Spacing.small) {
        Text(title)
            .font(.abcGinto(style: .headline, weight: .bold))
            .foregroundStyle(Color(.label))

        content()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
}

// MARK: - Preview

#Preview {
    ComponentCatalog()
}
