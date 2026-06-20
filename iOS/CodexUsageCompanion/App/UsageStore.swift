import Foundation

@MainActor
final class UsageStore: ObservableObject {
    @Published private(set) var snapshot = UsageSnapshot.preview
    @Published private(set) var isRefreshing = false
    @Published private(set) var sourceText = "Demo"

    private var demoIndex = 0

    func refresh() async {
        guard !isRefreshing else { return }
        isRefreshing = true

        try? await Task.sleep(nanoseconds: 180_000_000)
        snapshot = nextDemoSnapshot()
        sourceText = "Demo"
        isRefreshing = false
    }

    private func nextDemoSnapshot() -> UsageSnapshot {
        let snapshots = UsageSnapshot.demoSnapshots
        demoIndex = (demoIndex + 1) % snapshots.count
        return snapshots[demoIndex].refreshed()
    }
}
