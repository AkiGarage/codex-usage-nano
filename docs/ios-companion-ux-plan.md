# iPhone Companion UX Plan

This document defines a practical iPhone companion for Codex Usage Widget.
The goal is not to copy the macOS floating panel exactly. iOS does not allow a
normal app to keep an arbitrary always-floating desktop window above other apps.
The right iPhone experience is a tiny, glanceable widget/control surface backed
by a normal SwiftUI app for setup and detail.

## Goal

Build a small iPhone companion that lets a user check Codex usage quickly with one
tap or less.

Success criteria:

- The current Codex usage is visible at a glance on iPhone.
- The default surface is small, quiet, and not visually noisy.
- One tap opens a compact detail view similar to the macOS panel.
- The UI clearly shifts from cyan to yellow to red as usage gets low.
- The iPhone app never stores Codex cookies or OpenAI/Codex credentials.
- The Mac app remains the source of truth because it already reads CodexBarCLI.
- Stale data is obvious, not silently misleading.

## Platform Facts

Apple's current WidgetKit model fits this use case:

- Home Screen, Lock Screen, and Today View widgets can show small, glanceable
  information from an app.
- Widget extensions are not continuously active. They receive timeline reloads
  under system budget, so we should design for cached snapshots and predictable
  refreshes instead of second-by-second live UI.
- Control widgets can appear in places such as Control Center, the Lock Screen,
  and the Action button. They are best for app actions, toggles, or opening the
  app, not for reproducing a full custom dashboard.
- Widgets and controls can share WidgetKit/App Intents code paths.

References:

- https://developer.apple.com/documentation/widgetkit
- https://developer.apple.com/documentation/widgetkit/creating-a-widget-extension
- https://developer.apple.com/documentation/widgetkit/keeping-a-widget-up-to-date
- https://developer.apple.com/documentation/widgetkit/creating-controls-to-perform-actions-across-the-system
- https://developer.apple.com/design/human-interface-guidelines/controls

## Recommended Product Shape

Ship an iOS app with three surfaces:

1. Home Screen widget
2. Lock Screen widget
3. Tiny SwiftUI detail app

Add a Control Center control after the core widget flow works.

### Home Screen Widget

Primary surface. This should be the best experience.

Small widget content:

- `C 37%`
- a single compact progress bar
- color state: cyan, yellow, red
- optional small text: `1h 15m` or `stale 8m`

Medium widget content:

- Session and Weekly rows
- same bar/marker language as the macOS app
- reset time and projected empty/run out text

Design rule: show less text than the macOS panel by default. iPhone widgets are
for scanning, not reading.

### Lock Screen Widget

Use this for the fastest glance.

Recommended variants:

- Circular: `C 37`
- Rectangular: `Codex 37%`, tiny bar, reset text

The Lock Screen version should avoid dense wording. Color and percentage carry
the main signal.

### iPhone Detail App

One tap from the widget opens the app.

The app should show:

- the same compact Session/Weekly panel as macOS
- last updated time
- refresh button
- pairing/settings button
- stale/offline state

It should not have a landing page. The first screen is the actual usage panel.

### Control Center Control

Control Center is useful, but should not be the primary surface.

Recommended control:

- title: `Codex`
- value/status: `37%`
- icon: app icon or SF Symbol style `c.circle`
- tap action: open the detail app
- optional second action later: refresh snapshot

Reason: Apple's Control widgets are meant for quick actions or opening app
functionality. A full live usage panel belongs in a widget or the app, not
inside Control Center.

## Data Architecture

The iPhone cannot directly call:

```text
/Applications/CodexBar.app/Contents/Helpers/CodexBarCLI
```

That path exists only on the Mac. Therefore, the Mac app should publish a
sanitized snapshot, and the iPhone app should read that snapshot.

### Recommended MVP: Mac Publisher + Cloudflare Worker

Use the existing macOS app as the data producer.

Flow:

1. macOS app reads Codex usage from CodexBarCLI.
2. macOS app converts it into a small JSON snapshot.
3. macOS app sends the snapshot to a tiny backend using a random write token.
4. iPhone app/widget fetches the latest snapshot using a separate read token.
5. WidgetKit renders from cached data and refreshes on timeline budget.

Why this is the best MVP:

- Works when the iPhone is away from the Mac.
- Does not require exposing CodexBar or Codex credentials.
- Backend stores only low-sensitivity usage numbers.
- Pairing can be simple with a QR code.
- Cloudflare Workers + KV is enough for this tiny read-heavy snapshot use case.

Cloudflare references:

- https://developers.cloudflare.com/workers/
- https://developers.cloudflare.com/kv/

### Snapshot Contract

Use a small, versioned JSON payload.

```json
{
  "schemaVersion": 1,
  "deviceId": "my-mac",
  "updatedAt": "2026-06-05T06:00:00Z",
  "source": "CodexBarCLI",
  "session": {
    "remainingPercent": 37,
    "detailText": "On pace",
    "resetText": "Resets in 1h 15m",
    "projectionText": "Projected empty in 2h 11m",
    "markerPercent": 25,
    "state": "normal"
  },
  "weekly": {
    "remainingPercent": 77,
    "detailText": "8% in deficit",
    "resetText": "Resets in 5d 23h",
    "projectionText": "Runs out in 3d 11h",
    "markerPercent": 85,
    "state": "normal"
  }
}
```

State thresholds should match the macOS app:

- `normal`: above 30%
- `warning`: 16% to 30%
- `critical`: 15% or below
- `stale`: no fresh Mac publish for a configured interval

### Pairing UX

Pairing should take under 30 seconds.

Mac:

- Right-click or Control-click the tab.
- Choose `Pair iPhone`.
- Show a QR code and a short pairing code.

iPhone:

- First launch opens the scanner.
- Scan the QR code.
- Confirm the Mac name.
- Start showing the widget preview.

The QR payload should contain:

- backend base URL
- device ID
- read token
- optional display name

The write token remains on the Mac only.

### Privacy and Security

Do not send:

- Codex cookies
- OpenAI tokens
- email addresses
- raw CodexBar output
- local machine paths

Do send:

- percent remaining
- reset/projection text
- marker percent
- source timestamp

Use two tokens:

- write token: Mac only
- read token: iPhone only

This prevents the iPhone app from modifying usage data and limits damage if the
read token is exposed.

## UX States

### Fresh

Show the normal compact UI. No extra explanation text.

### Warning

Switch the active bar to yellow at 30% or lower. Keep typography stable.

### Critical

Switch the active bar to red at 15% or lower. Avoid animation; the color change
is the alert.

### Stale

If the iPhone has not received an update recently:

- make the bar gray
- show `Updated 18m ago`
- in the app detail view, show `Mac publisher offline`

Do not pretend the old percentage is current.

### Not Paired

The app first screen should be a direct pairing screen, not a marketing page.

Required elements:

- scan button
- manual code entry
- short privacy note: only usage percentages are synced

## Implementation Phases

### Phase 1: Shared Data Model

Add a shared `UsageSnapshot` JSON contract that can be used by macOS, backend,
and iOS.

Acceptance:

- fixture JSON decodes in Swift
- state thresholds are unit-tested
- stale calculation is unit-tested

### Phase 2: Backend MVP

Add a tiny Cloudflare Worker:

- `POST /v1/snapshot/:deviceId` with write token
- `GET /v1/snapshot/:deviceId` with read token
- KV stores the latest JSON snapshot
- no history needed for MVP

Acceptance:

- local worker tests pass
- invalid token returns 401
- snapshot body is schema-validated

### Phase 3: macOS Publisher

Extend the existing Mac app:

- optional sync settings
- publish after every successful CodexBarCLI refresh
- retry with backoff
- show `iPhone sync: updated 1m ago` in settings only

Acceptance:

- Mac app still works with sync disabled
- publishing failure does not break local widget
- no secret is logged

### Phase 4: iOS App

Create a native SwiftUI iPhone app:

- pairing screen
- compact detail panel
- manual refresh
- cached snapshot in App Group storage
- token storage in Keychain

Acceptance:

- app works after relaunch
- offline cached state renders correctly
- stale state is visible

### Phase 5: Widget Extension

Add WidgetKit extension:

- small Home Screen widget
- medium Home Screen widget
- Lock Screen circular/rectangular widgets
- shared rendering components where possible

Acceptance:

- widgets render normal/warning/critical/stale previews
- tap opens the detail app
- timeline refresh does not depend on live background execution

### Phase 6: Control Center Control

Add a Control widget after the core widgets are stable.

Acceptance:

- control appears in Control Center on supported iOS versions
- status shows current cached percent
- tap opens app or performs refresh through App Intent

## Alternatives Considered

### CloudKit/iCloud

Good privacy story, but more setup friction:

- Apple Developer account and entitlements are required for distribution.
- macOS and iOS targets need shared CloudKit configuration.
- Background/widget refresh behavior still needs careful testing.

Use this if avoiding Cloudflare is more important than easiest setup.

### Local Network Only

The Mac app could serve data over Bonjour/local network. This is private, but it
fails when the iPhone is away from the Mac or the Mac is asleep/off network.

Not recommended as the primary UX.

### iPhone Direct Codex Login/Scraping

Not recommended.

It would be fragile, high maintenance, and worse for security. The iPhone app
should not need Codex/OpenAI credentials just to show a usage percentage.

## Recommended Decision

Build the MVP as:

```text
Mac CodexUsageWidget
  -> CodexBarCLI
  -> sanitized snapshot
  -> Cloudflare Worker/KV
  -> iPhone SwiftUI app
  -> WidgetKit widgets
  -> optional Control Center control
```

This gives the best user experience for the original problem:

- no menu bar dependency
- no notch issue
- one-glance iPhone access
- no noisy app surface
- no credential duplication
- clear stale/offline behavior
