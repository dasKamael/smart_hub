# Smart Hub

Wall-mounted Android tablet app (landscape, ~11", kiosk mode) that controls a small apartment through
Home Assistant. The floor plan is the heart of the app: lights, speakers and plants are placed on it, show
their live state there and are controlled directly from it.

## Source of truth

- `design_handoff_hub_core/README.md` – the spec: screens, interactions, animation spec, data model,
  design tokens, acceptance criteria. Read the relevant section before building anything.
- `design_handoff_hub_core/design/*.dc.html` – high-fidelity HTML prototypes. Reference only, not code.
  Colors, sizes, radii, spacing and curves are final – match them exactly.
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
- Tests: `flutter_test`, `mocktail`, `fake_async`, `clock`, `patrol`

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
- Comments only where the *why* is not obvious from the code.
- Keep diffs minimal; no drive-by refactorings.
- Secrets (HA URL, long-lived token) never go into the repo. Runtime: `flutter_secure_storage` via the
  setup screen. Development: `--dart-define-from-file=env/dev.json` (gitignored).

## Commands

```sh
flutter pub get
dart run build_runner build -d          # after changing freezed / riverpod / drift / json sources
dart format --line-length 120 lib test packages patrol_test
flutter analyze
flutter test                             # unit + widget + architecture tests
flutter test test/architecture           # architecture rules only
(cd packages/ha_client && dart test)     # HA client package
patrol test                              # integration tests on device / emulator
```

## Working agreement

- New feature: read the handoff section, then propose a short plan (context, files per layer, tests)
  before implementing.
- Visual work: after each component, run it and compare with the prototype; share a screenshot.
- Done means: formatted, `flutter analyze` clean, all tests green (including architecture tests),
  new logic covered by tests.

## Open decisions

- Replacement font for SF Pro (needs tabular figures).
- Kiosk approach: device owner + lock task vs. launcher app.
- CI setup.
