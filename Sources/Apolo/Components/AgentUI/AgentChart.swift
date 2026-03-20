//
//  AgentChart.swift
//  Apolo
//
//  Sparkline, bar chart, and progress bar.
//

import SwiftUI

// MARK: - Chart Style

public enum AgentChartStyle {
    case sparkline
    case bar(labels: [String]?)
    case progress
}

// MARK: - Agent Chart

public struct AgentChart: View {
    public let style: AgentChartStyle
    public let data: [Double]
    public let color: Color
    public let height: CGFloat

    public init(
        style: AgentChartStyle = .sparkline,
        data: [Double],
        color: Color = Tokens.Color.violet.color,
        height: CGFloat = 80
    ) {
        self.style = style
        self.data = data
        self.color = color
        self.height = height
    }

    public var body: some View {
        switch style {
        case .sparkline:
            AgentSparkline(data: data, color: color)
                .frame(height: height)
        case .bar(let labels):
            AgentBarChart(data: data, labels: labels, color: color)
                .frame(height: height)
        case .progress:
            AgentProgressBar(value: data.first ?? 0, color: color)
        }
    }
}

// MARK: - Sparkline

/// Smooth Bézier sparkline matching BipaChart.SparkLine.
public struct AgentSparkline: View {
    public let data: [Double]
    public let color: Color

    public init(data: [Double], color: Color) {
        self.data = data
        self.color = color
    }

    public var body: some View {
        GeometryReader { geo in
            let minY = data.min() ?? 0
            let maxY = data.max() ?? 1
            let range = max(maxY - minY, 1)
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                let pts = data.enumerated().map { i, v in
                    CGPoint(
                        x: w * CGFloat(i) / CGFloat(max(data.count - 1, 1)),
                        y: h * (1 - CGFloat((v - minY) / range))
                    )
                }
                guard let first = pts.first else { return }
                path.move(to: first)
                for i in 1..<pts.count {
                    let cx = (pts[i].x + pts[i - 1].x) / 2
                    path.addCurve(
                        to: pts[i],
                        control1: CGPoint(x: cx, y: pts[i - 1].y),
                        control2: CGPoint(x: cx, y: pts[i].y)
                    )
                }
            }
            .stroke(color, style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
        }
    }
}

// MARK: - Bar Chart

public struct AgentBarChart: View {
    public let data: [Double]
    public let labels: [String]?
    public let color: Color

    public init(data: [Double], labels: [String]? = nil, color: Color) {
        self.data = data
        self.labels = labels
        self.color = color
    }

    public var body: some View {
        let maxVal = data.max() ?? 1

        GeometryReader { geo in
            HStack(alignment: .bottom, spacing: Tokens.Spacing.extraExtraSmall) {
                ForEach(Array(data.enumerated()), id: \.offset) { i, value in
                    VStack(spacing: Tokens.Spacing.extraExtraSmall) {
                        Spacer(minLength: 0)

                        RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                            .fill(color.opacity(0.25 + 0.75 * value / maxVal))
                            .frame(height: max(4, geo.size.height * 0.85 * CGFloat(value / maxVal)))

                        if let labels, i < labels.count {
                            Text(labels[i])
                                .caption2()
                                .foregroundStyle(Tokens.Color.secondaryLabel.color)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Progress Bar

public struct AgentProgressBar: View {
    public let value: Double
    public let color: Color

    public init(value: Double, color: Color) {
        self.value = value
        self.color = color
    }

    public var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                    .fill(color.opacity(0.15))

                RoundedRectangle(cornerRadius: Tokens.CornerRadius.small)
                    .fill(color)
                    .frame(width: geo.size.width * CGFloat(min(max(value, 0), 1)))
            }
        }
        .frame(height: 8)
    }
}

// MARK: - Previews

#Preview("Sparkline") {
    AgentChart(
        style: .sparkline,
        data: [640, 642, 638, 645, 648, 644, 650, 652, 649, 655, 653, 656],
        color: Tokens.Color.violet.color
    )
    .padding()
}

#Preview("Bar Chart") {
    AgentChart(
        style: .bar(labels: ["Alimentação", "Transporte", "Moradia", "Lazer", "Saúde"]),
        data: [1200, 800, 600, 450, 300],
        color: Tokens.Color.violet.color,
        height: 120
    )
    .padding()
}

#Preview("Progress") {
    VStack(spacing: Tokens.Spacing.medium) {
        AgentChart(style: .progress, data: [0.62], color: Tokens.Color.green.color)
        AgentChart(style: .progress, data: [0.15], color: Tokens.Color.red.color)
    }
    .padding()
}
