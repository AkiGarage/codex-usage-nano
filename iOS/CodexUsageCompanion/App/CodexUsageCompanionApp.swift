import SwiftUI

@main
struct CodexUsageCompanionApp: App {
    var body: some Scene {
        WindowGroup {
            CompanionHomeView()
        }
    }
}

struct CompanionHomeView: View {
    @StateObject private var store = UsageStore()

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Codex")
                        .font(.title3.weight(.semibold))
                    Text("\(store.sourceText) · \(store.snapshot.updatedText)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button {
                    Task { await store.refresh() }
                } label: {
                    if store.isRefreshing {
                        ProgressView()
                            .controlSize(.small)
                    } else {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .tint(.primary)
                .accessibilityLabel("Refresh")
            }

            UsagePanelView(snapshot: store.snapshot, compact: true)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 18)
        .padding(.top, 58)
        .padding(.bottom, 18)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.codexAppBackground.ignoresSafeArea())
        .task {
            await store.refresh()
        }
    }
}

#Preview {
    CompanionHomeView()
}
