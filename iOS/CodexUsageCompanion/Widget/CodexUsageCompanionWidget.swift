import SwiftUI
import WidgetKit

struct CodexUsageEntry: TimelineEntry {
    let date: Date
    let snapshot: UsageSnapshot
}

struct CodexUsageProvider: TimelineProvider {
    func placeholder(in context: Context) -> CodexUsageEntry {
        CodexUsageEntry(date: Date(), snapshot: .preview)
    }

    func getSnapshot(in context: Context, completion: @escaping (CodexUsageEntry) -> Void) {
        completion(CodexUsageEntry(date: Date(), snapshot: .preview))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<CodexUsageEntry>) -> Void) {
        let entry = CodexUsageEntry(date: Date(), snapshot: .preview)
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(15 * 60))))
    }
}

struct CodexUsageCompanionWidget: Widget {
    let kind = "CodexUsageCompanionWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: CodexUsageProvider()) { entry in
            CodexUsageWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Codex Usage")
        .description("Shows remaining Codex usage.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular])
    }
}

struct CodexUsageWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: CodexUsageEntry

    var body: some View {
        switch family {
        case .systemMedium:
            UsagePanelView(snapshot: entry.snapshot, compact: true)
        case .accessoryCircular:
            ZStack {
                AccessoryWidgetBackground()
                Text("C \(entry.snapshot.session.remainingPercent)")
                    .font(.headline.weight(.bold))
            }
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 2) {
                Text("Codex \(entry.snapshot.session.remainingPercent)%")
                    .font(.headline.weight(.semibold))
                Text(entry.snapshot.session.resetText)
                    .font(.caption2)
            }
        default:
            SmallWidgetView(snapshot: entry.snapshot)
        }
    }
}

struct SmallWidgetView: View {
    let snapshot: UsageSnapshot

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("C")
                    .font(.title.weight(.black))
                Text("\(snapshot.session.remainingPercent)%")
                    .font(.title2.weight(.semibold))
            }
            UsageBar(limit: snapshot.session)
                .frame(height: 9)
            Text(snapshot.session.resetText)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

#Preview(as: .systemSmall) {
    CodexUsageCompanionWidget()
} timeline: {
    CodexUsageEntry(date: Date(), snapshot: .preview)
}
