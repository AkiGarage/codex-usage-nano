import type {CSSProperties, ReactNode} from "react";
import {
  AbsoluteFill,
  Easing,
  Img,
  Sequence,
  interpolate,
  staticFile,
  useCurrentFrame,
  useVideoConfig,
} from "remotion";

const clamp = {
  extrapolateLeft: "clamp" as const,
  extrapolateRight: "clamp" as const,
};

const palette = {
  ink: "#17384d",
  muted: "#5d7280",
  faint: "#e6f2f7",
  cyan: "#42b8d2",
  cyanDeep: "#1f8fac",
  yellow: "#ffc238",
  red: "#ff313b",
  surface: "#f7fbfd",
  panel: "#93d0ef",
  shadow: "rgba(19, 69, 91, 0.22)",
};

const scenes = [
  {from: 0, duration: 180},
  {from: 180, duration: 270},
  {from: 450, duration: 330},
  {from: 780, duration: 360},
  {from: 1140, duration: 300},
  {from: 1440, duration: 210},
] as const;

export const Walkthrough = () => {
  return (
    <AbsoluteFill style={baseStyle}>
      <Backdrop />
      <Sequence from={scenes[0].from} durationInFrames={scenes[0].duration}>
        <IntroScene duration={scenes[0].duration} />
      </Sequence>
      <Sequence from={scenes[1].from} durationInFrames={scenes[1].duration}>
        <ProblemScene duration={scenes[1].duration} />
      </Sequence>
      <Sequence from={scenes[2].from} durationInFrames={scenes[2].duration}>
        <SolutionScene duration={scenes[2].duration} />
      </Sequence>
      <Sequence from={scenes[3].from} durationInFrames={scenes[3].duration}>
        <StatesScene duration={scenes[3].duration} />
      </Sequence>
      <Sequence from={scenes[4].from} durationInFrames={scenes[4].duration}>
        <ControlsScene duration={scenes[4].duration} />
      </Sequence>
      <Sequence from={scenes[5].from} durationInFrames={scenes[5].duration}>
        <CreditScene duration={scenes[5].duration} />
      </Sequence>
    </AbsoluteFill>
  );
};

type TimedProps = {
  duration: number;
};

const IntroScene = ({duration}: TimedProps) => {
  const frame = useCurrentFrame();
  const opacity = sceneOpacity(frame, duration);
  const iconStyle = rise(frame, 0, 18);
  const titleStyle = rise(frame, 12, 22);
  const subtitleStyle = rise(frame, 24, 18);

  return (
    <Scene opacity={opacity}>
      <div style={centerColumn}>
        <div style={{...iconShell, ...iconStyle}}>
          <Img src={staticFile("app-icon.svg")} style={iconImage} />
        </div>
        <h1 style={{...heroTitle, ...titleStyle}}>Codex Usage Nano</h1>
        <p style={{...heroSubtitle, ...subtitleStyle}}>
          Codex usage at a glance, without menu bar clutter.
        </p>
        <div style={{...captionPill, ...rise(frame, 42, 12)}}>
          Companion for installed CodexBarCLI
        </div>
      </div>
    </Scene>
  );
};

const ProblemScene = ({duration}: TimedProps) => {
  const frame = useCurrentFrame();
  const opacity = sceneOpacity(frame, duration);
  const hidden = interpolate(frame, [80, 150], [0, 1], clamp);

  return (
    <Scene opacity={opacity}>
      <div style={splitLayout}>
        <div style={{width: 520}}>
          <Kicker>Why this exists</Kicker>
          <h2 style={sectionTitle}>Menu bar apps can disappear behind the notch.</h2>
          <p style={sectionCopy}>
            On a MacBook Air, only a few third-party menu items stay visible. A usage meter
            that is hidden is not really a usage meter.
          </p>
        </div>
        <div style={macMockShell}>
          <div style={desktopMock}>
            <div style={menuBar}>
              <div style={appleDot} />
              <div style={menuLabel}>Finder</div>
              <div style={notch} />
              <div style={menuItems}>
                {["Wi-Fi", "Battery", "Clock"].map((item) => (
                  <span key={item} style={menuItem}>
                    {item}
                  </span>
                ))}
                <span
                  style={{
                    ...hiddenCodexBar,
                    transform: `translateX(${interpolate(hidden, [0, 1], [0, 112])}px)`,
                    opacity: interpolate(hidden, [0, 0.7, 1], [1, 1, 0.16]),
                  }}
                >
                  Codex 82% left
                </span>
              </div>
            </div>
            <div style={notchCallout}>Notch + crowded menu bar</div>
          </div>
        </div>
      </div>
    </Scene>
  );
};

const SolutionScene = ({duration}: TimedProps) => {
  const frame = useCurrentFrame();
  const opacity = sceneOpacity(frame, duration);
  const open = interpolate(frame, [78, 128], [0, 1], clamp);
  const cursorX = interpolate(frame, [28, 78], [1050, 930], clamp);
  const cursorY = interpolate(frame, [28, 78], [350, 306], clamp);

  return (
    <Scene opacity={opacity}>
      <div style={stageTitleBlock}>
        <Kicker>One click away</Kicker>
        <h2 style={sectionTitle}>A small floating tab opens the usage panel only when needed.</h2>
      </div>
      <div style={solutionStage}>
        <ScreenshotFrame
          src="screenshot-normal.png"
          style={{
            width: 760,
            transform: `translateX(${interpolate(open, [0, 1], [-28, 0])}px) scale(${interpolate(
              open,
              [0, 1],
              [0.94, 1],
            )})`,
            opacity: open,
          }}
        />
        <FloatingTab
          percent="37%"
          style={{
            right: 84,
            top: 208,
            transform: `scale(${interpolate(frame, [78, 94, 118], [1, 0.94, 1], clamp)})`,
          }}
        />
        <MousePointer x={cursorX} y={cursorY} opacity={interpolate(frame, [20, 40, 128, 170], [0, 1, 1, 0], clamp)} />
      </div>
    </Scene>
  );
};

const StatesScene = ({duration}: TimedProps) => {
  const frame = useCurrentFrame();
  const opacity = sceneOpacity(frame, duration);
  const cards = [
    {src: "screenshot-normal.png", label: "Normal", color: palette.cyan, delay: 18},
    {src: "screenshot-warning.png", label: "Warning", color: palette.yellow, delay: 58},
    {src: "screenshot-critical.png", label: "Critical", color: palette.red, delay: 98},
  ];

  return (
    <Scene opacity={opacity}>
      <div style={stageTitleBlock}>
        <Kicker>Read the status instantly</Kicker>
        <h2 style={sectionTitle}>Blue, yellow, and red make the remaining token state obvious.</h2>
      </div>
      <div style={stateGrid}>
        {cards.map((card) => {
          const appear = interpolate(frame, [card.delay, card.delay + 36], [0, 1], clamp);
          return (
            <div
              key={card.label}
              style={{
                ...stateCard,
                transform: `translateY(${interpolate(appear, [0, 1], [30, 0])}px)`,
                opacity: appear,
              }}
            >
              <div style={{...stateChip, backgroundColor: card.color}}>{card.label}</div>
              <Img src={staticFile(card.src)} style={stateImage} />
            </div>
          );
        })}
      </div>
    </Scene>
  );
};

const ControlsScene = ({duration}: TimedProps) => {
  const frame = useCurrentFrame();
  const opacity = sceneOpacity(frame, duration);
  const resize = interpolate(frame, [95, 165], [1, 0.74], clamp);

  return (
    <Scene opacity={opacity}>
      <div style={controlsLayout}>
        <div style={controlPreview}>
          <ScreenshotFrame
            src="screenshot-warning.png"
            style={{
              width: 650,
              transform: `scale(${resize}) translate(${interpolate(frame, [95, 165], [0, -88], clamp)}px, -10px)`,
              transformOrigin: "top left",
            }}
          />
          <FloatingTab percent="29%" style={{right: 42, top: 120}} />
          <ContextMenu style={{opacity: interpolate(frame, [170, 200], [0, 1], clamp)}} />
        </div>
        <div style={controlCopy}>
          <Kicker>Widget-like behavior</Kicker>
          <h2 style={sectionTitle}>Move it. Resize it. Hide it again.</h2>
          <FeatureLine color={palette.cyan}>Drag the floating tab anywhere on the desktop.</FeatureLine>
          <FeatureLine color={palette.cyanDeep}>Click once to show or hide the panel.</FeatureLine>
          <FeatureLine color={palette.yellow}>Resize down to about half size.</FeatureLine>
          <FeatureLine color={palette.red}>Control-click for Refresh or Quit.</FeatureLine>
        </div>
      </div>
    </Scene>
  );
};

const CreditScene = ({duration}: TimedProps) => {
  const frame = useCurrentFrame();
  const opacity = sceneOpacity(frame, duration);

  return (
    <Scene opacity={opacity}>
      <div style={centerColumn}>
        <div style={{...iconShell, width: 128, height: 128, ...rise(frame, 0, 16)}}>
          <Img src={staticFile("app-icon.svg")} style={iconImage} />
        </div>
        <h2 style={{...sectionTitle, fontSize: 56, textAlign: "center", ...rise(frame, 14, 18)}}>
          Fast usage checks, zero menu bar dependency.
        </h2>
        <p style={{...heroSubtitle, maxWidth: 760, ...rise(frame, 28, 16)}}>
          Powered by the installed CodexBarCLI. CodexBar is MIT licensed; this project keeps
          attribution explicit and does not bundle CodexBar.
        </p>
        <div style={{...repoPill, ...rise(frame, 48, 12)}}>github.com/owner/codex-usage-nano</div>
      </div>
    </Scene>
  );
};

const Backdrop = () => (
  <AbsoluteFill
    style={{
      background:
        "linear-gradient(135deg, #f8fcff 0%, #e3f4fb 42%, #b6e1f4 100%)",
    }}
  >
    <div style={diagonalBand} />
    <div style={{...diagonalBand, top: 450, opacity: 0.24, transform: "rotate(-7deg)"}} />
  </AbsoluteFill>
);

const Scene = ({children, opacity}: {children: ReactNode; opacity: number}) => (
  <AbsoluteFill style={{opacity, padding: 72}}>{children}</AbsoluteFill>
);

const Kicker = ({children}: {children: ReactNode}) => <div style={kickerStyle}>{children}</div>;

const FeatureLine = ({children, color}: {children: ReactNode; color: string}) => (
  <div style={featureLine}>
    <span style={{...featureDot, backgroundColor: color}} />
    <span>{children}</span>
  </div>
);

const ScreenshotFrame = ({src, style}: {src: string; style?: CSSProperties}) => (
  <div style={{...screenshotShell, ...style}}>
    <Img src={staticFile(src)} style={screenshotImage} />
  </div>
);

const FloatingTab = ({percent, style}: {percent: string; style?: CSSProperties}) => (
  <div style={{...floatingTab, ...style}}>
    <span style={tabC}>C</span>
    <span>{percent}</span>
  </div>
);

const ContextMenu = ({style}: {style?: CSSProperties}) => (
  <div style={{...contextMenu, ...style}}>
    <div style={contextMenuItem}>Show Panel</div>
    <div style={contextMenuItem}>Refresh</div>
    <div style={{...contextMenuItem, color: palette.red}}>Quit Codex Usage Nano</div>
  </div>
);

const MousePointer = ({x, y, opacity}: {x: number; y: number; opacity: number}) => (
  <div
    style={{
      ...cursor,
      opacity,
      transform: `translate(${x}px, ${y}px) rotate(-14deg)`,
    }}
  />
);

const sceneOpacity = (frame: number, duration: number) => {
  const fadeIn = interpolate(frame, [0, 24], [0, 1], clamp);
  const fadeOut = interpolate(frame, [duration - 24, duration], [1, 0], clamp);
  return Math.min(fadeIn, fadeOut);
};

const rise = (frame: number, delay: number, distance: number): CSSProperties => {
  const amount = interpolate(frame, [delay, delay + 32], [0, 1], {
    ...clamp,
    easing: Easing.bezier(0.16, 1, 0.3, 1),
  });
  return {
    opacity: amount,
    transform: `translateY(${interpolate(amount, [0, 1], [distance, 0])}px)`,
  };
};

const baseStyle: CSSProperties = {
  color: palette.ink,
  fontFamily:
    "-apple-system, BlinkMacSystemFont, 'SF Pro Display', 'Helvetica Neue', Arial, sans-serif",
  overflow: "hidden",
};

const centerColumn: CSSProperties = {
  alignItems: "center",
  display: "flex",
  flexDirection: "column",
  height: "100%",
  justifyContent: "center",
  textAlign: "center",
};

const heroTitle: CSSProperties = {
  fontSize: 76,
  fontWeight: 800,
  letterSpacing: 0,
  lineHeight: 1,
  margin: "30px 0 18px",
};

const heroSubtitle: CSSProperties = {
  color: palette.muted,
  fontSize: 30,
  fontWeight: 520,
  lineHeight: 1.25,
  margin: 0,
};

const iconShell: CSSProperties = {
  alignItems: "center",
  background: "rgba(255, 255, 255, 0.72)",
  border: "1px solid rgba(25, 86, 114, 0.16)",
  borderRadius: 34,
  boxShadow: `0 24px 70px ${palette.shadow}`,
  display: "flex",
  height: 152,
  justifyContent: "center",
  width: 152,
};

const iconImage: CSSProperties = {height: "72%", width: "72%"};

const captionPill: CSSProperties = {
  background: "rgba(255, 255, 255, 0.72)",
  border: "1px solid rgba(31, 143, 172, 0.2)",
  borderRadius: 999,
  color: palette.cyanDeep,
  fontSize: 22,
  fontWeight: 720,
  marginTop: 34,
  padding: "13px 22px",
};

const splitLayout: CSSProperties = {
  alignItems: "center",
  display: "flex",
  gap: 56,
  height: "100%",
  justifyContent: "space-between",
};

const sectionTitle: CSSProperties = {
  fontSize: 48,
  fontWeight: 820,
  letterSpacing: 0,
  lineHeight: 1.05,
  margin: "14px 0 22px",
};

const sectionCopy: CSSProperties = {
  color: palette.muted,
  fontSize: 27,
  fontWeight: 520,
  lineHeight: 1.32,
  margin: 0,
};

const kickerStyle: CSSProperties = {
  color: palette.cyanDeep,
  fontSize: 20,
  fontWeight: 820,
  letterSpacing: 0,
  textTransform: "uppercase",
};

const macMockShell: CSSProperties = {
  background: "rgba(255, 255, 255, 0.62)",
  border: "1px solid rgba(25, 86, 114, 0.18)",
  borderRadius: 30,
  boxShadow: `0 30px 80px ${palette.shadow}`,
  padding: 18,
};

const desktopMock: CSSProperties = {
  background: "linear-gradient(145deg, #5bbfe1, #2c8eb8)",
  borderRadius: 22,
  height: 360,
  overflow: "hidden",
  position: "relative",
  width: 560,
};

const menuBar: CSSProperties = {
  alignItems: "center",
  background: "rgba(255, 255, 255, 0.78)",
  display: "flex",
  height: 44,
  padding: "0 18px",
  position: "relative",
};

const appleDot: CSSProperties = {
  background: palette.ink,
  borderRadius: 10,
  height: 16,
  marginRight: 14,
  width: 16,
};

const menuLabel: CSSProperties = {fontSize: 17, fontWeight: 760};

const notch: CSSProperties = {
  background: "#111820",
  borderBottomLeftRadius: 16,
  borderBottomRightRadius: 16,
  height: 34,
  left: "50%",
  position: "absolute",
  top: 0,
  transform: "translateX(-50%)",
  width: 138,
  zIndex: 3,
};

const menuItems: CSSProperties = {
  alignItems: "center",
  display: "flex",
  gap: 10,
  marginLeft: "auto",
  overflow: "hidden",
  whiteSpace: "nowrap",
};

const menuItem: CSSProperties = {
  color: palette.muted,
  fontSize: 14,
  fontWeight: 680,
};

const hiddenCodexBar: CSSProperties = {
  background: palette.panel,
  borderRadius: 999,
  color: palette.ink,
  fontSize: 14,
  fontWeight: 780,
  padding: "7px 12px",
  willChange: "transform, opacity",
};

const notchCallout: CSSProperties = {
  background: "rgba(255, 255, 255, 0.82)",
  borderRadius: 18,
  bottom: 30,
  color: palette.ink,
  fontSize: 26,
  fontWeight: 780,
  left: 34,
  padding: "16px 22px",
  position: "absolute",
};

const stageTitleBlock: CSSProperties = {width: 900};

const solutionStage: CSSProperties = {
  alignItems: "center",
  display: "flex",
  height: 460,
  justifyContent: "center",
  marginTop: 18,
  position: "relative",
};

const screenshotShell: CSSProperties = {
  background: "rgba(255, 255, 255, 0.58)",
  border: "1px solid rgba(25, 86, 114, 0.16)",
  borderRadius: 28,
  boxShadow: `0 26px 70px ${palette.shadow}`,
  overflow: "hidden",
  padding: 0,
};

const screenshotImage: CSSProperties = {
  display: "block",
  width: "100%",
};

const floatingTab: CSSProperties = {
  alignItems: "center",
  background: "#9bd7f3",
  border: "2px solid rgba(23, 56, 77, 0.36)",
  borderRadius: 999,
  boxShadow: "0 14px 36px rgba(12, 50, 68, 0.28)",
  color: palette.ink,
  display: "flex",
  fontSize: 31,
  fontWeight: 620,
  gap: 12,
  padding: "17px 28px",
  position: "absolute",
};

const tabC: CSSProperties = {fontWeight: 900};

const cursor: CSSProperties = {
  borderBottom: "30px solid transparent",
  borderLeft: "22px solid #102c3c",
  borderTop: "8px solid transparent",
  filter: "drop-shadow(0 8px 12px rgba(8, 40, 56, 0.28))",
  height: 0,
  left: 0,
  position: "absolute",
  top: 0,
  width: 0,
};

const stateGrid: CSSProperties = {
  display: "grid",
  gap: 22,
  gridTemplateColumns: "repeat(3, 1fr)",
  marginTop: 26,
};

const stateCard: CSSProperties = {
  background: "rgba(255, 255, 255, 0.62)",
  border: "1px solid rgba(25, 86, 114, 0.15)",
  borderRadius: 24,
  boxShadow: `0 22px 58px ${palette.shadow}`,
  overflow: "hidden",
  padding: 16,
};

const stateChip: CSSProperties = {
  borderRadius: 999,
  color: palette.ink,
  display: "inline-block",
  fontSize: 19,
  fontWeight: 820,
  marginBottom: 14,
  padding: "8px 14px",
};

const stateImage: CSSProperties = {
  borderRadius: 16,
  display: "block",
  width: "100%",
};

const controlsLayout: CSSProperties = {
  alignItems: "center",
  display: "grid",
  gap: 42,
  gridTemplateColumns: "1.1fr 0.9fr",
  height: "100%",
};

const controlPreview: CSSProperties = {
  height: 470,
  position: "relative",
};

const controlCopy: CSSProperties = {
  paddingTop: 10,
};

const featureLine: CSSProperties = {
  alignItems: "center",
  color: palette.muted,
  display: "flex",
  fontSize: 25,
  fontWeight: 620,
  gap: 14,
  lineHeight: 1.2,
  marginTop: 18,
};

const featureDot: CSSProperties = {
  borderRadius: 999,
  flex: "0 0 auto",
  height: 14,
  width: 14,
};

const contextMenu: CSSProperties = {
  background: "rgba(255, 255, 255, 0.94)",
  border: "1px solid rgba(25, 86, 114, 0.18)",
  borderRadius: 14,
  boxShadow: `0 18px 48px ${palette.shadow}`,
  position: "absolute",
  right: 18,
  top: 208,
  width: 244,
};

const contextMenuItem: CSSProperties = {
  borderBottom: "1px solid rgba(25, 86, 114, 0.1)",
  fontSize: 19,
  fontWeight: 680,
  padding: "13px 16px",
};

const repoPill: CSSProperties = {
  background: palette.ink,
  borderRadius: 999,
  color: "#f6fdff",
  fontSize: 24,
  fontWeight: 760,
  marginTop: 34,
  padding: "16px 26px",
};

const diagonalBand: CSSProperties = {
  background: "rgba(255, 255, 255, 0.32)",
  height: 150,
  left: -120,
  position: "absolute",
  top: 88,
  transform: "rotate(8deg)",
  width: 1600,
};
