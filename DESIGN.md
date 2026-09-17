# Bhāvanā design system (Loom)

Contract: [UX Spec issue #1](https://github.com/fencingbuddha/Bhavana/issues/1) §2 + §4.6.

**Personality:** quiet ritual / water flow (Ground & Return, Mercilia). Soft blues + moss. Soft fades only. No Material default chrome.

## Rule for Dev

Feature code may **only** use:

- `BhavanaTheme.of(context)` / `colorsOf` / `spacingOf` / `radiiOf` / `motionOf` / `typographyOf`
- Widgets under `lib/core/widgets/`
- Theme-driven Material widgets that inherit from `AppTheme` (until migrated)

Do **not** introduce raw `Color(0x…)`, hard-coded paddings, or stock chrome looks (`CircularProgressIndicator` without soft wrapper, bright Material defaults mid-practice).

## Files to land in repo

```
lib/core/theme/
  tokens_color.dart
  tokens_typography.dart
  tokens_spacing.dart
  tokens_radius.dart
  tokens_motion.dart
  bhavana_theme.dart
  app_theme.dart
  theme.dart          # barrel
lib/core/widgets/
  bhavana_soft_progress.dart
  bhavana_progress_line.dart
  bhavana_card.dart
  bhavana_buttons.dart
  widgets.dart
lib/main.dart         # use main_patch.dart: theme + darkTheme + ThemeMode.system + AppTheme.builder
DESIGN.md             # this file (repo root)
```

Replace existing `lib/core/theme/app_theme.dart`. Keep imports that already point at `core/theme/app_theme.dart`.

## Tokens

| Module | Access | Notes |
|--------|--------|-------|
| Color | `BhavanaTheme.colorsOf` | `light` / `dark`; AA body text; `primaryFill` for CTAs |
| Type | `…typographyOf` | Nunito; `timer` has tabular figures |
| Spacing | `…spacingOf` | 4 / 8 / 12 / 16 / 24 / 32 / 48; `tapTarget` 44 |
| Radius | `…radiiOf` | card 20, pill 28 |
| Motion | `…motionOf` | `fast` / `normal` / `slow`; durations → 0 when reduce-motion |

## Core widgets

- `BhavanaSoftProgress` — loading
- `BhavanaProgressLine(value:)` — 4pt in-session
- `BhavanaCard` — quiet surface
- `BhavanaButton` — `primary` / `secondary` / `destructiveQuiet` (Leave dialog)

## Builder follow-ups (Verdict P0 #2, P2 #7)

1. Swap screens from `NavigationBar` / `ChoiceChip` / `Card` / `CircularProgressIndicator` to themed or `Bhavana*` widgets.
2. Use `BhavanaTheme.motionOf(context)` for page fades; honor reduce-motion.
3. Leave dialog: Stay = secondary, Leave = `destructiveQuiet`.

## Wire check

`MaterialApp` must set `darkTheme: AppTheme.dark`, `themeMode: ThemeMode.system`, `builder: AppTheme.builder`.
