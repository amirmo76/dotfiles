---
name: svg-anim
description: Build an animated illustration from layered SVG exports in React Native using Reanimated shared values — stacked absoluteFill layers, per-part transformOrigin, onLayout scale normalization, and self-contained repeating drivers with no JS callbacks. Use when asked to animate an SVG/illustration (empty states, onboarding art, mascots), to add motion to an exported multi-layer SVG, or when the user says "animate this illustration", "empty state animation", "svg animation".
---

# Animated layered SVG illustrations

The illustration is exported from the design file as **one SVG per moving part**,
all sharing the same artboard (same `viewBox`, same coordinates). Every layer is
then stacked at `StyleSheet.absoluteFill` and animated independently. Nothing is
positioned by hand — the artboard already places it.

Reference implementations in this codebase:
`src/components/ui/EmptyContactsIllustration.tsx`, `src/components/ui/EmptyChatIllustration.tsx`.

## Asset prep (before any code)

Ask for / export one file per part that moves, plus one `-base` file with
everything static. Each export must keep the **full artboard**, not a cropped
bounding box — cropping destroys the shared coordinate space and you end up
hand-nudging `top`/`left` forever.

Naming: `empty-<screen>-<part>.svg`, e.g. `empty-chat-bubble-front-base.svg`.

## Skeleton

```tsx
export const XIllustration = (props: ViewProps) => {
  const progress = useSharedValue(0)
  const scale = useSharedValue(1)

  useEffect(() => { bob(progress, { duration: 2600 }) }, [])

  const partStyle = useAnimatedStyle(() => ({
    transform: [{ translateY: interpolate(progress.value, [0, 1], [0, -6]) }],
  }))

  // Artboard units → screen units. Only needed for pixel-distance moves.
  const onLayout = (e: LayoutChangeEvent) =>
    { scale.value = e.nativeEvent.layout.width / ARTBOARD_WIDTH }

  return (
    <View style={styles.container} onLayout={onLayout} {...props}>
      <Base width="100%" height="100%" />
      <Animated.View style={[styles.part, partStyle]}>
        <Part width="100%" height="100%" />
      </Animated.View>
    </View>
  )
}

const styles = StyleSheet.create({
  container: { width: "100%", aspectRatio: ARTBOARD_W / ARTBOARD_H },
  part: { ...StyleSheet.absoluteFillObject, transformOrigin: "17% 18%" },
})
```

Rules baked into that skeleton:

- **Container**: `width: "100%"` + `aspectRatio` from the artboard. Never fixed px.
- **Every layer**: `absoluteFill`, `width="100%" height="100%"`. Order in JSX = paint order.
- **`transformOrigin` as a percentage of the artboard**, set to the part's own
  centre — otherwise `rotate`/`scale` swings the part around the canvas centre.
  Measure it from the SVG: `partCenterX / artboardWidth`.
- **`scale.value` from `onLayout`** multiplies any translate expressed in
  artboard units, so the motion tracks the rendered size. Skip it for translates
  you tuned by eye at render size; required for anything derived from SVG coords.

## Drivers

One `useSharedValue` per independent motion, driven by a **self-contained
repeating sequence**. No `runOnJS`, no `setInterval`, no state — a driver starts
once in `useEffect` and never talks to JS again. Pauses are `withDelay` *inside*
the sequence, not separate animations.

```tsx
// ping-pong 0→1→0, the workhorse
const bob = (p, { duration, delay = 0 }) => {
  p.value = withDelay(delay, withRepeat(
    withSequence(
      withTiming(1, { duration, easing: Easing.inOut(Easing.sin) }),
      withTiming(0, { duration, easing: Easing.inOut(Easing.sin) })
    ), -1, true))
}

// hold at the end of a cycle: a zero-length timing behind a delay
withDelay(REST, withTiming(0, { duration: 1 }))
```

Easing carries the physics — pick it, don't fake it with keyframes:
`Easing.inOut(Easing.sin)` for floating/breathing, `Easing.out(Easing.quad)` for
a decelerating rise, `Easing.in(Easing.quad)` for a fall, `Easing.inOut(Easing.cubic)`
for a scanning sweep.

**Stagger identical drivers instead of writing new ones.** Three twinkling star
layers = one `twinkle` helper called with delays `0`, `0.45×`, `0.9×` of its
period.

## Coupling parts

Parts that must stay in sync **share one driver** and derive different styles
from it. A shadow that grows as a head lifts reads off `headProgress`, so it can
never drift. A dependent part that should lag gets its own driver at the same
period with a small delay, and its style subtracts the leader's value so the
transform is only the *gap*:

```tsx
translateY: -HEIGHT * (dotProgress.value - frontProgress.value)
```

Nested parts inherit the parent's transform — put a group in one
`Animated.View` and animate children relative to it.

Overlapping segments (telescope tubes, stacked cards) must move **monotonically
in the tuck direction**: each segment shifts less than the one it slides under,
and paint order matches the tuck order, or seams tear open.

## Moving along a path

To ride an SVG curve, sample the cubic béziers into points, then interpolate.
Space the breakpoints by **cumulative arc length**, not sample index, or speed
jumps at every segment boundary:

```tsx
const D = PATH.reduce((acc, p, i) =>
  i === 0 ? [0] : [...acc, acc[i-1] + Math.hypot(p.x - PATH[i-1].x, p.y - PATH[i-1].y)], [])
const BREAKPOINTS = D.map(d => d / D[D.length - 1])
const X = PATH.map(p => p.x - REST.x)   // offsets from the painted position
```

Then `interpolate(progress.value, BREAKPOINTS, X) * scale.value`. Anchor at the
part's painted centre (`REST`) so progress `0` is a no-op.

## Performance

- One transform per layer where possible; every animated style is a worklet, keep it arithmetic-only.
- Constants (durations, distances, offsets) live at module scope, not in the component.
- Static layers stay in a plain `View` — don't pay for `Animated.View` you don't animate.
- No `useDerivedValue` when the expression fits in the `useAnimatedStyle` body.
- Drivers are `withRepeat(..., -1)`; they stop with the component. No cleanup needed.

## Commenting

These files are geometry, and the geometry is not self-evident. Comment the
*why* of a number: what the unit vector points along, why the shadow scales that
range, why the pulse gap is `PAUSE - CYCLE + SWEEP`. Don't comment the API calls.
