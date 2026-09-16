# Bhāvanā

Guided mind-body training. Design language: **water** — continuous flow, no mid-practice dashboard or metrics feel.

**Display name:** Bhāvanā · **Package / slug:** `bhavana` · **Org:** `com.stillwater`

Repo: https://github.com/fencingbuddha/Bhavana

## Setup

1. Install [Flutter](https://docs.flutter.dev/get-started/install) (stable channel).
2. Clone and enter the project:

   ```bash
   git clone https://github.com/fencingbuddha/Bhavana.git
   cd Bhavana
   ```

3. Fetch packages and analyze:

   ```bash
   flutter pub get
   flutter analyze
   ```

4. Run (desktop, web, or device):

   ```bash
   flutter run
   # examples:
   # flutter run -d linux
   # flutter run -d chrome
   ```

No paid packages or third-party SaaS. Local persistence uses `shared_preferences`.

## Navigation

`Home / tracks` → `Session launch` → `In-session (start → middle → end)` → `Practice log`

Locked Body & Flexibility tracks open a visible “coming soon” shell.

## Feature checklist (v1)

| Feature | Status | Notes |
|--------|--------|--------|
| Guided session player — **Mind** | **Working** | Start / middle / end phases, soft timer, continuous flow UI |
| Guided session player — **Body** | **Stubbed** | Visible locked / coming-soon shell |
| Guided session player — **Flexibility** | **Stubbed** | Visible locked / coming-soon shell |
| Capacity growth | **Working** | Capacity = last *completed* middle; next middle = capacity + 3 min; bookends fixed (3 + 3); optional “I have X minutes” caps *this* session only; capacity updates only on finished middle |
| Continuous flow UX | **Working** | No mid-practice dashboard; thin progress line + remaining time only |
| Quiet local practice log | **Working** | `shared_preferences` list of completed sessions |
| Unlock / IAP | **Stubbed** | Local unlock flag only (“Unlock locally”); **no real IAP** |
| Audio / live coaching scripts | **Stubbed** | Guidance text placeholders; no audio engine yet |

## Capacity model (wired in UI)

- **Start** = arrival / breath (fixed)
- **Middle** = capacity-driven practice block (grows after completed sessions)
- **End** = cool-down / close (fixed)
- Optional time budget at launch shortens *this* middle if needed; does not raise stored capacity unless the session is completed

## Project structure

```
lib/
  core/           # theme, constants
  features/
    home/         # tracks list
    session/      # launch, player, capacity, models
    practice_log/ # quiet local log
    unlock/       # local unlock stub
```

## License

See repository license file if present.
