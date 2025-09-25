freud.ai Splash & Loading System
================================

The new launch flow recreates the four-step splash/loading narrative from the
freud.ai concept art. The visual language is earthy, warm, and minimal. This
document captures the palette, typography, and layout principles backing the
implementation in `lib/core/theme.dart` and
`lib/screens/splash/splash_sequence_screen.dart`.

🎨 Color Language
-----------------

Flat fills only—no gradients or glass. The palette mirrors the splash frames.

```
cream        #F5EFE6  base canvas, first slide background
richBrown    #4B2E21  logo mark, dense loader background
cocoa        #7A4B32  secondary brown for loader circles
burntOrange  #F57C1F  quote screen background
mossGreen    #6C8A3C  fetching screen background
paleOlive    #C4D88F  translucent bubbles on green screen
textDark     #2F1D12  body copy on light backgrounds
textLight    #FDF7EF  type on dark/colored backgrounds
error        #D64545  alerts (kept for runtime messaging)
```

Use opacity steps (0.2 → 0.4) on cocoa/paleOlive to recreate overlapping
circles. All screens share the same brown + cream logo mark.

✍️ Typography
--------------

- Typeface: **Manrope** (Google Fonts). Medium geometric sans with soft humanist
  curves.
- Display: 32/24/20pt, weight 600–700 for bold statements.
- Body: 16pt regular for intro copy, 14pt medium for captions and CTAs.
- Quote screen uses 26pt display with 1.4 line height and light italic feel.

Typography is encoded via `FreudTypography.build()` so widgets can reuse
`Theme.of(context).textTheme` for consistent weights.

📐 Layout, Spacing & Motion
---------------------------

- Global spacing grid: multiples of 12dp (aligns with large logo mark). Common
  paddings: 32, 36, 48.
- Buttons retain 28dp radius to echo the circular motif.
- Splash transitions use `AnimatedSwitcher` with 600ms ease curves.
- Background motifs (circles) rely on absolute positioning with soft opacity;
  keep them oversized so edges bleed off-screen.

🟤 Frame-by-Frame Breakdown
---------------------------

1. **Brand Splash** (cream)
   - Center the 5-dot clover mark above the wordmark `freud.ai`.
   - Text color: `textDark`.

2. **Loading** (rich brown)
   - Full-bleed dark backdrop with three oversized cocoa circles (0.2–0.35
     opacity).
   - Centered `99%` in `textLight`, tracking 2pt.

3. **Quote** (burnt orange)
   - Left-aligned stack, generous left padding.
   - White logo mark above the quote.
   - Quote text uses double quotes and 26pt type; attribution sits 32dp below.

4. **Fetching Data** (moss green)
   - Layer three pale olive bubbles with varying offsets.
   - Message stack centered: “Fetching Data…” + supporting row with vibration
     icon + “Shake screen to interact!”.

🔧 Implementation Notes
----------------------

- `FreudTheme.light()` maps colors into the Material color scheme so general UI
  components stay brand-aligned without extra styling.
- `_LogoMark` builds the four-petal icon using concentric circles; reuse on any
  screen that needs the freud.ai mark.
- `_BackgroundCircle` helper manages the translucent overlays for loader and
  fetching states.
- Splash sequence timing: 1.6s → 2.2s → 2.4s transitions, then 1.8s hold before
  navigation.

♿ Accessibility
----------------

- Text on colored backgrounds uses `textLight` for ≥ 4.5:1 contrast.
- Minimum tap/click targets remain ≥ 48dp high (buttons inherit from theme).
- Animations are time-based, no reliance on user gestures during the splash.

✅ Summary
----------

- Earthy, confident launch moment with sequential storytelling.
- Simple geometry (circles + clover mark) keeps brand memorable.
- Theme + helper widgets ensure future onboarding or status screens can borrow
  the same visual rules without duplication.