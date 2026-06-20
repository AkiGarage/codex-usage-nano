# Marketing Assets

This directory contains reproducible marketing assets for Codex Usage Widget.

## Walkthrough Video

The Remotion project in `remotion/` creates a short, captioned product walkthrough:

- why a menu-bar-only usage meter is unreliable on a notched MacBook
- the floating tab workflow
- one-click show/hide behavior
- normal, warning, and critical usage states
- resize, move, refresh, and quit affordances
- explicit CodexBarCLI credit

The current version is silent and caption-led. That keeps the video easy to
publish without recording a private desktop, voiceover, or licensed music.

Render locally:

```bash
cd marketing/remotion
npm install
npm run render
```

The default render writes `marketing/remotion/out/codex-usage-widget-walkthrough.mp4`.
For release artifacts, render to `artifacts/videos/` with a dated filename.
