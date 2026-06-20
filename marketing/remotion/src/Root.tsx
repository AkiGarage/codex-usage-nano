import {Composition} from "remotion";
import {Walkthrough} from "./Walkthrough";

export const VIDEO_FPS = 30;
export const VIDEO_WIDTH = 1280;
export const VIDEO_HEIGHT = 720;
export const VIDEO_DURATION_FRAMES = 1650;

export const RemotionRoot = () => {
  return (
    <Composition
      id="CodexUsageNanoWalkthrough"
      component={Walkthrough}
      durationInFrames={VIDEO_DURATION_FRAMES}
      fps={VIDEO_FPS}
      width={VIDEO_WIDTH}
      height={VIDEO_HEIGHT}
    />
  );
};
