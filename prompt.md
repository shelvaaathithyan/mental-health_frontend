Here’s how you move from **just a landing + voice page** → to a full **Emma UI prototype** following your rules. Think in **steps** not all-at-once code dump.

---

## 1. **Set up Project Structure**

Inside `lib/` add folders:

```
lib/
 ├─ core/          # theme, constants, utils
 ├─ widgets/       # reusable UI components (cards, buttons, sliders)
 ├─ screens/       # each screen widget
 │   ├─ onboarding/
 │   ├─ dashboard/
 │   ├─ journaling/
 │   ├─ exercises/
 │   ├─ crisis/
 │   ├─ progress/
 │   └─ settings/
```

This keeps UI modular and matches your rules.

---

## 2. **Define Core Theme**

In `lib/core/theme.dart`:

* Use your **theme.md** tokens (colors, fonts, spacing).
* Add `TextStyle` constants (Heading, Subheading, Body).
* Add `ColorScheme` (primary gradient, background, accent).

This ensures consistency across all screens.

---

## 3. **Build Reusable Widgets**

In `lib/widgets/` create:

* `PrimaryButton.dart` – rounded button with gradient + ripple.
* `MoodCard.dart` – emoji + text + slider.
* `JournalCard.dart` – card with prompt + text field.
* `ExerciseTile.dart` – card with icon + description.
* `ProgressChart.dart` – placeholder chart or Lottie tree.
* `SettingTile.dart` – card with toggle or dropdown.

Each widget must have comments like:

```dart
// --- Mood Card ---
// Displays emoji + label + slider for mood tracking
```

---

## 4. **Screens You Need to Add**

1. Onboarding / Welcome

Purpose: Set tone, explain trust and confidentiality, make user comfortable.

Content:

App name + calming tagline (“Emma – here for you, always confidential”).

Short intro text (1–2 lines, culturally sensitive).

Primary button → “Start”.

Theme: Calming gradient, avatar waves or blinks softly.

Note: No persona selector. Keep it stigma-free and frictionless.

2. Dashboard / Home

Purpose: Central hub for quick access.

Content Layout:

Greeting Card: “Hi, how’s your day going?” (rotates messages daily).

Quick Actions:

Log Mood → Journaling

Exercises → Coping

Progress → Insights

Crisis Help → Support

Avatar bubble at top with subtle micro-animation (breathing halo).

Design: Card-based, 2-column grid for actions.

3. Mood Journaling

Purpose: Capture daily feelings, help reflection.

Content:

Mood slider (very sad → very happy, emoji-based).

Short text box: “Want to share what’s on your mind?”

Save entry → confirmation.

Below: timeline of recent logs (sample data until backend).

Extra: Animated emoji changes when slider moves.

4. Therapeutic Exercises / Interventions

Purpose: On-demand relief tools.

Content Blocks:

Breathing Exercise: Lottie bubble animation with inhale/exhale timer.

Grounding Exercise: “5-4-3-2-1 senses” interactive checklist.

Affirmations: Swipeable cards with daily positive statements.

Mini-Meditation: Play calming sound/animation (placeholder).

UI: Grid or list of exercise tiles with icons/animations.

5. Crisis / Support

Purpose: Urgent help in emergencies.

Content:

Urgent Banner: “You’re not alone. Help is available right now.”

Buttons:

Call India’s KIRAN Helpline (1800-599-0019).

Connect with a trusted contact (placeholder).

Quick self-grounding exercise.

Supportive text: “It’s okay to ask for help. You’re safe here.”

UI: Bold but non-alarming (red accent + calming base colors).

6. Progress / Insights

Purpose: Show growth, encourage consistency.

Content:

Mood Trend Graph: Last 7 days (sample chart).

Highlights Card: “Most common mood: Anxious. Journaling streak: 4 days.”

Achievements: Badge system (Resilience, Calm Streak, Reflection Hero).

Optional: playful growth visual (tree animation grows with logs).

UI: Scrollable dashboard with charts and badges.

---

## 5. **Animations & Micro-Interactions**

* Use `AnimatedContainer`, `Hero`, `FadeTransition` for small movements.
* Use **Lottie animations** for breathing, progress.
* Add subtle scale on button press.

---

## 6. **Navigation**

* Use **`Navigator.pushNamed`** with a route map in `main.dart`.
* Example:

```dart
routes: {
  '/': (context) => OnboardingScreen(),
  '/dashboard': (context) => DashboardScreen(),
  '/journaling': (context) => JournalingScreen(),
  '/exercises': (context) => ExercisesScreen(),
  '/crisis': (context) => CrisisScreen(),
  '/progress': (context) => ProgressScreen(),
  '/settings': (context) => SettingsScreen(),
},
```
Onboarding → user enters app with reassurance.

Dashboard → central hub with avatar presence.

Daily cycle:

Log mood in Journaling.

Use Exercises if stressed.

Check Progress weekly.

Access Crisis Support if overwhelmed.

---


1. Scaffold empty screens with just `Scaffold(body: Center(child: Text("...")))`.
2. Add navigation so you can click through all pages.
3. Replace placeholders step by step with widgets.
4. Reuse `MoodCard`, `JournalCard`, etc.

