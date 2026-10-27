# Architecture

Layered architecture with **bounded contexts mirrored in every layer** (same pattern as the coodoo
s-broker app): `data/<context>`, `domain/<context>`, `presentation/screens/<context>`.

```
smart_hub/
├─ packages/
│  └─ ha_client/                  pure Dart: Home Assistant WebSocket client + fake server
├─ lib/
│  ├─ common/                     cross-cutting infrastructure, no business logic
│  │  ├─ config/                  env, app config
│  │  ├─ device/                  kiosk, wakelock, platform info
│  │  ├─ go_router/               routes, tab shell
│  │  ├─ logging/
│  │  ├─ riverpod/                provider helpers / extensions
│  │  └─ utils/                   generic helpers (throttle, optimistic overlay, ...)
│  ├─ data/
│  │  ├─ database/                app_database.dart (drift), migrations
│  │  ├─ connection/              ha_session.repository.dart – owns the ha_client instance
│  │  ├─ floorplan/               floorplan.repository.dart, placement.repository.dart, *.table.dart
│  │  ├─ lights/                  light.repository.dart
│  │  ├─ plants/                  plant.repository.dart, plant_photo.repository.dart, *.table.dart
│  │  ├─ music/                   speaker.repository.dart, speaker_settings.repository.dart, spotify/
│  │  └─ zen/                     zen_settings.repository.dart, *.table.dart
│  ├─ domain/
│  │  ├─ connection/              connection.service.dart, connection.state.dart, model/
│  │  ├─ floorplan/               placement.service.dart, room_lookup.util.dart, grouping.util.dart, model/
│  │  ├─ lights/                  light.service.dart, light_capabilities.util.dart, model/
│  │  ├─ plants/                  watering.service.dart, watering_due.util.dart, model/
│  │  ├─ music/                   speaker.service.dart, spotify*.service.dart, model/
│  │  └─ zen/                     zen.service.dart (idle time)
│  └─ presentation/
│     ├─ design_system/
│     │  ├─ tokens/               hub.color_palette.dart, hub_text_styles.dart, hub_motion.dart, spacing/radii
│     │  ├─ atoms/                device marker, slider bar, color swatch, pill button, chip
│     │  ├─ molecules/            stat tile, tray item, now-playing row
│     │  ├─ organisms/            inspector card, plan card
│     │  └─ layouts/              page scaffold, widget grid (S/M/L/XL)
│     ├─ shared_widgets/
│     └─ screens/
│        ├─ floorplan/            floorplan.screen.dart, floorplan.controller.dart, floorplan.state.dart, widgets/
│        ├─ lights/  plants/  music/  dashboard/  setup/
├─ test/                          mirrors lib/ + architecture/, mocks/, utils/, fixtures/
├─ integration_test/              performance tests (profile mode)
└─ test_driver/                   timeline summaries for integration tests
```

## Bounded contexts

| Context | Owns | Source of state |
|---|---|---|
| `connection` | HA session: auth, reconnect with backoff, online/offline, entity registry (for the placement picker) | HA |
| `floorplan` | Rooms, walls, doors, device placements, room derivation, grouping, tray | drift |
| `lights` | Light state, capabilities, light commands, room scenes | HA |
| `plants` | Plants, watering and fertilizing plan, photos, plant profiles (species care data from Perenual, loaded once per species and kept locally) | drift + local files + Perenual API |
| `music` | Speaker state, playback, volume, speaker groups, Spotify content and Connect devices, local speaker settings | HA + Spotify Web API + drift |
| `zen` | Idle time until the zen mode (calm full screen with time and cover) | drift |
| `weather` | Forecast for where the hub is (device location, town name from Nominatim) or a chosen place; last forecast cached offline | Open-Meteo + drift |
| `dashboard` | Presentation only – the start page; composes widgets from the other contexts on the 170 px grid | – |
| `setup` | Presentation only – HA URL / token entry (uses `connection`) | – |

`floorplan` is brand- and device-state-agnostic. It only knows `Placement(deviceId, kind, pos)` with
`DeviceKind { light, speaker, plant }`. `deviceId` is the HA `entity_id` for lights/speakers and the
local id for plants. Live state is joined with placements **in the presentation layer**
(`floorplan.controller.dart`), never inside `domain/floorplan`.

Cross-context actions (e.g. room action "Lights on/off", "Water N") are orchestrated in the controller:
ask `floorplan` which devices are in the room, then call the `lights` / `plants` service with those ids.

## Dependency rules

Enforced by `test/architecture/`. Do not add exceptions without asking.

1. `presentation` → `domain` → `data`. `presentation` never imports `data`.
2. `domain` and `data` never import `presentation`.
3. `common` never imports `domain` or `presentation`.
4. `data/<ctx>` is only imported by `domain/<ctx>` (and by `data/database`).
   Exception: every `data/<ctx>` may use `data/connection` (the shared HA session).
5. `package:ha_client` is only imported in `lib/data/`.
6. `domain/floorplan` does not import `domain/lights`, `domain/plants` or `domain/music`.
7. `data` may import domain models (`domain/<ctx>/model/`) to map into them – nothing else from `domain`.
8. `packages/ha_client` imports nothing from the app and nothing from Flutter.

## Layers

### packages/ha_client

Pure Dart. Speaks the HA WebSocket protocol and nothing else – no knowledge of lights, plants or rooms.

- `auth` → `get_states` → `subscribe_events(state_changed)` → `call_service`
- message id correlation, result/error futures, reconnect with exponential backoff
- exposes entity states as raw `HaEntityState(entityId, state, attributes, lastChanged)` and a stream of changes
- ships `FakeHomeAssistant` (in-process fake speaking the real protocol) via `package:ha_client/testing.dart`
  for tests and a demo mode without a real HA instance

### data

Repositories wrap one source each (HA session, drift, file system) and map raw types into domain models.

- `ha_session.repository.dart` is a keep-alive provider holding the single `HaClient`.
- `light.repository.dart` maps `light.*` entities → `LightState` (incl. `supported_color_modes` → caps)
  and turns commands into `light.turn_on` / `light.turn_off` service calls.
- `speaker.repository.dart` does the same for `media_player.*`.
- drift: one `AppDatabase` in `data/database/`, tables live next to their context as `*.table.dart`.
  Bump `schemaVersion` for every schema change and run `dart run drift_dev make-migrations` – it stores the
  schema in `drift_schemas/` and generates migration tests in `test/data/database/` (config in `build.yaml`).
- Plant photos are stored as files in the app documents directory; the DB stores the path.

Provider at the bottom of the repository file:

```dart
part 'light.repository.g.dart';

class LightRepository {
  LightRepository({required this.session});

  final HaSession session;

  Stream<List<LightState>> watchLights() { ... }

  Future<void> turnOn(String entityId, {int? brightnessPct, Color? color, int? kelvin}) { ... }
}

/// Providers
@riverpod
LightRepository lightRepository(Ref ref) {
  return LightRepository(session: ref.watch(haSessionRepositoryProvider));
}
```

### domain

Business rules, independent of widgets.

- **Services** (`*.service.dart`): `@riverpod` functions or classes that use repositories and expose
  state / commands to presentation.
- **Utils** (`*.util.dart`): pure logic, no Riverpod, no Flutter imports – exhaustively unit tested.
  Examples: point-in-polygon and room lookup, clamping inside plan bounds, single-linkage grouping
  (34 cm) and drop target search (40 cm), watering due calculation, color temperature → RGB.
  Translating HA formats (e.g. `supported_color_modes` → capabilities) is the data layer's job.
- **Models** (`model/`): freezed classes and enums.
- Geometry is in **cm** with an own point type. Conversion to pixels happens only in presentation.
- A device's room is **derived** from its position, never stored.

Optimistic updates (lights, music): apply the desired state immediately as an overlay on top of the HA
state, send the service call, drop the overlay when the matching `state_changed` arrives, roll back on
error or after 3 s without confirmation. The generic overlay lives in `common/utils/`.

Offline: `connection` exposes online/offline. While offline, keep the last known state and disable
controls; show the "Offline" pill.

### presentation

- Per screen: `*.screen.dart` (widget), `*.controller.dart` (`@riverpod` Notifier), `*.state.dart`
  (freezed), `widgets/` for screen-private widgets.
- Controllers hold UI state only (selection, open group, drag, layers) and call domain services.
- Slider changes are throttled in the controller (≤ 5 updates/s plus a final value on release).
- Design tokens from the handoff live in `design_system/tokens/`; widgets never hardcode colors, sizes
  or curves.
- Floor plan rendering: static geometry (rooms, walls, doors, labels) in a `CustomPainter` behind a
  `RepaintBoundary`; glow as a separate layer clipped per room; markers as widgets with stable keys
  (one widget per device) so moves animate instead of rebuilding. Target: 60 fps while dragging with
  ~30 markers.

## File naming

The suffix states what the file contains; the architecture tests check it.

| Suffix | Contains | Layer |
|---|---|---|
| `*.repository.dart` | `...Repository` class + provider | `data` |
| `*.table.dart` | drift table | `data` |
| `*.service.dart` | `@riverpod` service(s) | `domain` |
| `*.util.dart` | `...Util` class with pure logic | `domain`, `common` |
| `*.controller.dart` | `...Controller` Notifier | `presentation` |
| `*.state.dart` | `...State` freezed class | `domain`, `presentation` |
| `*.screen.dart` | `...Screen` widget | `presentation` |
| `*.enum.dart` | enum | any |
| `*.extension.dart` | named extension | any |
| `*.color_palette.dart` | `...ColorPalette` | `presentation/design_system` |

Riverpod patterns follow the code generator: functional providers for repositories and simple services,
`@riverpod class ... extends _$...` for controllers and stateful services, `keepAlive: true` only for
long-lived infrastructure (HA session, database).
