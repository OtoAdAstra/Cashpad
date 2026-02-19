//
//  ChartView.swift
//  Cashpad
//
//  Created by Oto Sharvashidze on 15.01.26.
//

import SwiftUI
import Charts

struct ChartView: View {
    @ObservedObject var viewModel: ChartViewModel

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            flowSelectorRow
            granularityPicker
            periodNavigator
            chartContent
                .id(viewModel.periodRange.lowerBound)
                .transition(.opacity)
        }
        .padding()
        .background(Color("Background"))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    // MARK: - Flow Selector

    private var flowSelectorRow: some View {
        HStack(spacing: 12) {
            summaryCard(
                title: "Income",
                amount: viewModel.periodIncomeTotal,
                isSelected: viewModel.selectedFlow == .income,
                color: .green,
                currency: viewModel.currency
            )
            .onTapGesture {
                Haptic.tap()
                viewModel.selectedFlow = .income
            }

            summaryCard(
                title: "Expenses",
                amount: viewModel.periodExpenseTotal,
                isSelected: viewModel.selectedFlow == .expense,
                color: .red,
                currency: viewModel.currency
            )
            .onTapGesture {
                Haptic.tap()
                viewModel.selectedFlow = .expense
            }
        }
    }

    // MARK: - Granularity Picker

    private var granularityPicker: some View {
        Picker("Granularity", selection: $viewModel.selectedGranularity) {
            ForEach(Granularity.allCases) { g in
                Text(g.rawValue).tag(g)
            }
        }
        .pickerStyle(.segmented)
    }

    // MARK: - Period Navigator

    private var periodNavigator: some View {
        HStack {
            Button {
                Haptic.tap()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    viewModel.shiftPeriod(-1)
                }
            } label: {
                Image(systemName: "chevron.left")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)

            Spacer()

            Text(viewModel.periodTitle)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .contentTransition(.numericText())

            Spacer()

            Button {
                Haptic.tap()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                    viewModel.shiftPeriod(1)
                }
            } label: {
                Image(systemName: "chevron.right")
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .gesture(swipeGesture)
    }

    // MARK: - Chart

    @ViewBuilder
    private var chartContent: some View {
        Chart {
            if viewModel.aggregated.isEmpty {
                emptyChartMarks
            } else {
                ForEach(viewModel.aggregated, id: \.date) { bucket in
                    areaMark(for: bucket)
                    lineMark(for: bucket)
                }
            }
        }
        .chartXAxis { xAxisContent }
        .chartYAxis { yAxisContent }
        .chartXScale(domain: viewModel.periodRange.lowerBound...viewModel.periodRange.upperBound)
        .chartYScale(domain: yDomain)
        .aspectRatio(1.6, contentMode: .fit)
        .contentShape(Rectangle())
        .gesture(swipeGesture)
        .animation(.none, value: viewModel.aggregated.map(\.date))
    }

    // MARK: - Chart Marks

    @ChartContentBuilder
    private var emptyChartMarks: some ChartContent {
        RuleMark(
            xStart: .value("Start", viewModel.periodRange.lowerBound),
            xEnd:   .value("End",   viewModel.periodRange.upperBound)
        )
        .opacity(0)

        RuleMark(y: .value("Zero", 0))
            .opacity(0)
    }

    @ChartContentBuilder
    private func areaMark(for bucket: (date: Date, total: Double)) -> some ChartContent {
        AreaMark(
            x: .value("Date",   bucket.date),
            y: .value("Amount", bucket.total)
        )
        .interpolationMethod(.catmullRom)
        .foregroundStyle(
            LinearGradient(
                colors: [viewModel.selectedFlowColor.opacity(0.20),
                         viewModel.selectedFlowColor.opacity(0.0)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    @ChartContentBuilder
    private func lineMark(for bucket: (date: Date, total: Double)) -> some ChartContent {
        LineMark(
            x: .value("Date",   bucket.date),
            y: .value("Amount", bucket.total)
        )
        .interpolationMethod(.catmullRom)
        .symbol {
            Circle()
                .fill(viewModel.selectedFlowColor)
                .frame(width: 7, height: 7)
                .shadow(color: viewModel.selectedFlowColor.opacity(0.35), radius: 3, y: 1)
        }
        .foregroundStyle(viewModel.selectedFlowColor)
        .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
    }

    // MARK: - Axis Content

    @AxisContentBuilder
    private var xAxisContent: some AxisContent {
        switch viewModel.selectedGranularity {
        case .day:
            AxisMarks(values: .stride(by: .hour, count: 3)) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                AxisValueLabel(format: .dateTime.hour(), centered: false)
            }
        case .week:
            AxisMarks(values: .stride(by: .day, count: 1)) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                AxisValueLabel(format: .dateTime.weekday(.narrow), centered: true)
            }
        case .year:
            AxisMarks(values: .stride(by: .month, count: 1)) { _ in
                AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                AxisValueLabel(format: .dateTime.month(.narrow), centered: true)
            }
        }
    }

    @AxisContentBuilder
    private var yAxisContent: some AxisContent {
        AxisMarks(position: .trailing, values: .automatic(desiredCount: 4)) { value in
            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
            AxisValueLabel {
                if let amount = value.as(Double.self) {
                    Text(amount, format: .number.notation(.compactName).precision(.fractionLength(0)))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
