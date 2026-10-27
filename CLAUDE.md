# Smart Hub

Wall-mounted Android tablet app (landscape, ~11", kiosk mode) that controls a small apartment through
Home Assistant (runs on a Raspberry Pi 4 with Home Assistant OS). The floor plan is the heart of the app: lights, speakers and plants are placed on it, show
their live state there and are controlled directly from it.

## Source of truth

- `design_handoff_hub_core/README.md` – the spec: screens, interactions, animation spec, data model,
  design tokens, acceptance criteria. Read the relevant section before building anything.
- `design_handoff_hub_core/design/*.dc.html` – high-fidelity HTML prototypes. Reference only, not code.
  Colors, sizes, radii, spacing and curves are final – match them exactly.
  Deliberate change (Richard, 2026-10-27): no black background – a calm sky that follows the time of day
  (`HubBackground`, `HubSky`) with solid cards (`HubColorPalette.card`, white veils for tiles and controls on them).
  Every area has its own color in its cards and page glow (`HubAreaColors`); weather shows live scenes instead.
- `design_handoff_hub_core/data/floorplan.json` – the apartment (units: cm), initial plan.
- `design_handoff_hub_core/design/Roadmap.dc.html` – phases and milestones (German).

Build in the order of the handoff ("Suggested build order") / roadmap phases.

## Stack

- Flutter (Android), Dart 3, pinned Flutter version via fvm
- State: `flutter_riverpod` 3 + `riverpod_annotation` / `riverpod_generator`
- Models: `freezed` 4, `json_serializable`
- Persistence: `drift`
- Routing: `go_router`
- Home Assistant: own pure Dart package `packages/ha_client` on top of `web_socket_channel`
- Platform: `wakelock_plus`, `flutter_secure_storage`
- Logging: `logging`; time: `clock`
- Tests: `flutter_test`, `mocktail`, `fake_async`, `clock`, `integration_test` (performance)

## Architecture

@docs/architecture.md

## Testing

@docs/testing.md

## Code rules

- **English everywhere**: identifiers, comments, UI strings, docs, commit messages.
- Package imports only (`package:smart_hub/...`), single quotes, line width 120.
- Never edit generated files (`*.g.dart`, `*.freezed.dart`, drift output). Change the source and run
  `dart run build_runner build -d`.
- No `print` / `debugPrint` – use `Logger('ClassName')` from `package:logging`.
- No `DateTime.now()` – use `clock.now()` from `package:clock`, so time stays testable.
- No brand names (Hue, Govee, Sonos) in domain or presentation code. The app knows device kinds and
  capabilities, not brands.
- Only render controls a device reports as supported (capability model in the handoff).
- Own icons only: draw them as `HubGlyph` paths (`design_system/atoms/hub_glyph.dart`), never `Icons.*` or emojis.
- Tiles stay compact; actions appear when a tile is tapped (options laid over the tile) instead of permanent
  buttons. Prefer icons and numbers over text.
- Comments only where the *why* is not obvious from the code.
- Keep diffs minimal; no drive-by refactorings.
- Secrets (HA URL, long-lived token) never go into the repo. Runtime: `flutter_secure_storage` via the
  setup screen. Development: `--dart-define-from-file=env/dev.json` (gitignored).

## Commands

```sh
flutter pub get
flutter run --dart-define-from-file=env/dev.json   # Spotify client id, Perenual key (env/dev.json is gitignored, see env/example.json)
dart run build_runner build -d          # after changing freezed / riverpod / drift / json sources
dart format --line-length 120 lib test packages integration_test test_driver
flutter analyze
flutter test                             # unit + widget + architecture tests
flutter test test/architecture           # architecture rules only
(cd packages/ha_client && dart test)     # HA client package
(cd packages/ha_client && dart run coverage:test_with_coverage)   # coverage → packages/ha_client/coverage/lcov.info
# Drag performance (acceptance: 60 fps with ~30 markers) – run on the real tablet, emulator GPUs are not representative.
# Summaries: build/plan_idle|plan_drag|plan_drag_no_glow.timeline_summary.json
flutter drive --profile --no-dds --driver=test_driver/perf_driver.dart --target=integration_test/plan_drag_perf_test.dart
# Music page while Spotify is polled and while using it → build/music_idle|music_use.timeline_summary.json
flutter drive --profile --no-dds --driver=test_driver/perf_driver.dart --target=integration_test/music_perf_test.dart
# flutter drive reinstalls the app: app data (HA connection, Spotify sign-in, settings) is gone afterwards.
```

## Plant database

Plant profiles come from Perenual (free plan: 100 requests a day, care data only for species ids 1–3000; others are
found but marked "Premium only"). A profile is loaded once and stored per plant (`plant_profiles` table); a second
plant of the same species copies it. Perenual has no fertilizer data – the fertilizing plan (March–September, interval
from the care level) is the hub's own (`fertilizing.util.dart`). Answers often take 10–30 s.

For plants Perenual does not cover, care data is imported as JSON (Plants → import button): the dialog copies a
prompt with the hub's plant names for a chat assistant and reads its answer (`plant_care_import.util.dart`, format
`smart-hub-plant-care` v1). Imported profiles have no species id; watering has a summer and a winter range.

## Without Home Assistant

Setup → "No Home Assistant? Start with plants and Spotify" (`ConnectionConfig.standalone()`): the floor plan, plants,
Spotify and the zen mode work; light and speaker parts are hidden or explain what they need (`hasHomeAssistantProvider`,
`HomeAssistantHint`). Home Assistant can be connected later from the settings.

## Dashboard

Start page (`HubRoute.home`). Widgets use `WidgetTile` / `WidgetSize` (S 1×1 … XL 4×2 on the 170 px grid); built one
feature at a time (weather, home, plants, lights, music, apps so far; see `docs/architecture.md` → contexts). A widget of an existing
feature lives in that feature's `widgets/` folder and uses its services (e.g. `plants/widgets/plants_widget.dart`). Arranged like the iPad home screen: long press
to jiggle, drag to move (the others make room), corner handle to resize, "–" to remove, gallery to add, tap a
widget to edit it (`DashboardWidget.selection`, e.g. the rooms of a lights widget, empty = automatic; `card` = with or
without background card). The apps widget lists and opens the tablet's apps via the `smart_hub/apps` channel
(`MainActivity.kt`). One page of
6 × 3 units; widgets flow from the top left in their order (`dashboard_layout.util.dart`), stored in drift. A new widget
kind needs an entry in `DashboardWidgetKind` (sizes) and `DashboardCatalog` (name, glyph, builder). Weather: Open-Meteo (open source, no key,
attribution on the weather page), town names from OpenStreetMap Nominatim (identifying user agent, asked once per
position), device location via `geolocator` (coarse). The emulator AVD has no GPS – choose a place in the settings.

## Branding

Logo master: `branding/logo.svg` (floor plan with a glowing light and a plant). Android: adaptive icon as vectors
(`drawable/ic_launcher_foreground|background|monochrome.xml`), PNG fallbacks in `mipmap-*`, splash screen via
`values-v31` (Android 12+) and `launch_background.xml` (older). In Flutter: `HubLogo`. The app is dark in light and dark
system mode alike.

## Lights without Home Assistant

Settings → Lights → "Pair bridge" (several possible, their lamps are combined): the hub talks to Philips Hue Bridges directly in the home network (CLIP v2, event
stream for live changes; `data/lights/hue/`). Found via Signify's discovery service or typed address; pairing needs the
bridge's button. The key lives in `flutter_secure_storage`. Paired bridges provide all lights instead of Home
Assistant (`lightRepositoryProvider`). Domain and presentation call it a "light bridge" (no brand names there).

## Speakers without Home Assistant

Settings → "Speakers in the network": the hub talks to Sonos speakers directly over their local UPnP interface (port
1400, `data/music/sonos/`) – no Home Assistant, cloud or Sonos app. One address is enough, the others of the system
are read from it (SSDP search does not get through the emulator). State is polled every 1.5 s. Music sent from a phone
plays on Sonos via Spotify Connect and is shown and controlled from the speaker. Spotify's Web API does not list Sonos
speakers: the hub starts Spotify tracks, albums and playlists on them through the speaker's queue instead (needs Spotify
linked in the Sonos system once; service 9 / `SA_RINCON2311`, the speaker finds the account). Moving music from a
Spotify device to a speaker goes on at the same track and position.

## Demo mode

The app runs without Home Assistant: the setup screen offers a demo mode backed by `FakeHomeAssistant`
(`lib/data/connection/demo/`) with demo lights and speakers that react to service calls. Use it for UI work.

## Kiosk

Launcher approach, no device owner: the app runs fullscreen (immersive sticky) with the screen always on.
Settings → "Hub as home screen" enables the `HomeAlias` activity alias (HOME category), so the hub replaces the
launcher and starts on boot; switching it off restores the normal launcher (`lib/common/device/kiosk.dart`,
`MainActivity.kt`).

## Working agreement

- New feature: read the handoff section, then propose a short plan (context, files per layer, tests)
  before implementing.
- Visual work: after each component, run it and compare with the prototype; share a screenshot.
- Done means: formatted, `flutter analyze` clean, all tests green (including architecture tests),
  new logic covered by tests.

## Open decisions

- Replacement font for SF Pro (needs tabular figures).
- CI setup.
