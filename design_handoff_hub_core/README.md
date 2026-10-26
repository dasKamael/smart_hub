# Handoff: Smart Home Hub – Core (Floor plan, Lights, Plants, Music)

## Overview
A wall-mounted Android tablet app (landscape, ~11") that controls a small apartment (≈42 m², 7 rooms). The **floor plan is the heart of the app**: lights, speakers and plants are placed on it, show their live state there and can be controlled directly from it. This first release covers four features:

1. **Floor plan** – rooms, walls, doors/openings, draggable device markers, grouping, inspector panel
2. **Lights** – Philips Hue now, Govee and other brands later, via one capability-based model
3. **Plants** – watering schedule, due/overdue states, watering by tap
4. **Music** – Sonos speakers, Spotify as content source

Target stack: **Flutter (Android)** + **Home Assistant** as the device bridge (WebSocket API). The app never talks to Hue/Govee/Sonos directly.

## About the Design Files
The files in `design/` are **design references built in HTML** – interactive prototypes that show the intended look and behaviour. They are **not production code**. Recreate them in Flutter using idiomatic widgets (CustomPainter, Stack/Positioned, implicit animations, Riverpod). Open any `.dc.html` file directly in a browser (keep `support.js` next to it).

## Fidelity
**High-fidelity.** Colors, type sizes, radii, spacing and animation curves are final. Match them closely. The only intended deviation: the Apple system font (SF Pro) is not available on Android – substitute one freely licensed sans (decision pending) and keep the same size/weight scale.

## Architecture
```
Flutter app (tablet, kiosk / lock-task mode)
  ├─ UI: floor plan, inspector, pages, widgets
  ├─ Local DB (drift): floor plan, device placements, plants
  └─ HA client (web_socket_channel): auth → get_states → subscribe_events(state_changed) → call_service
        ↓
Home Assistant (Raspberry Pi 5 / mini PC)
  ├─ Hue Bridge (local)          → light.*
  ├─ Govee (LAN preferred)       → light.*
  ├─ Sonos (local)               → media_player.*
  └─ Spotify integration         → media_player.spotify_*
```
- Reconnect automatically (exponential backoff). While disconnected: show an "Offline" pill top-right, keep the last known state, disable controls.
- Optimistic UI: apply a change locally immediately, roll back if HA returns an error or the state does not arrive within ~3 s.
- Packages: `flutter_riverpod`, `web_socket_channel`, `drift`, `wakelock_plus`.

---

## Screens / Views

Canvas: landscape tablet. Prototype frame is 1166 × 806 logical px inside the bezel; outer padding 20–24, gap between cards 16. Background `#000` with a very subtle blurred multi-color glow (opacity .2) – optional.

### 1. Floor plan – full page (primary screen)
Reference: `design/Widget Kit.dc.html` → tab **Plan** → "Full page".

**Layout (column, gap 16)**
1. **Plan card** – `surface #1C1C1E`, radius 26, padding 14/18/18. Top row (height 36): layer chips right-aligned (Plants · Lights · Speakers · Glow). Below: the plan, full card width, aspect ratio = plan bounds (≈ 1140:460).
2. **Bottom row** – grid `1.6fr | 1fr`, gap 16, fills remaining height (~160 px):
   - **Inspector card** (radius 26, padding 16/20) – content depends on selection (see below).
   - **"Not placed" tray card** (radius 26, padding 16/18) – title "Not placed" 17/700, hint "Drag onto the plan" 13 text2; horizontal row of tray items (62 px wide: 44 px marker + 11/600 name, ellipsis). No visible scrollbar.

**Plan rendering**
- Data: `data/floorplan.json` (units **cm**). Rooms = polygons, walls = solid polygons, doors = segments with `type: "door" | "open"`.
- Room floor `#262628`, walls stroke `#636366` 4 px (outer outline 12 px drawn first), round joins.
- Doors/openings: draw a segment in floor color (width ~7) over the wall to create the gap. Doors additionally get a thin leaf line + dashed quarter arc (editor shows this; on the main plan the gap alone is enough).
- Room labels: top-left area of the room, name 15/700 `text2`, optional area 12/600 `text3`. Selected room: label `#409CFF`.
- Selected room overlay: fill `rgba(10,132,255,.12)`, stroke `#0A84FF` 4 px.
- **Light glow**: for each light that is on, a radial gradient centred on the light, diameter = (16 + brightness × 0.26) % of plan width, stops `color@70% → color@30% (35%) → transparent (70%)`, opacity `.45 + bri/180`, blend `screen`, **clipped to the room polygon** the light is in. Fade opacity 500 ms when switching.

**Device markers** (44 × 44, circle, centred on position)
| Type | Background | Icon | State styling |
|---|---|---|---|
| Light on | light color | bulb, `#1C1C1E` | shadow `0 0 16px color@66%` |
| Light off | `#3A3A3C` | bulb, text2 | ring `0 0 0 2px rgba(255,255,255,.18)` |
| Plant ok | `#1E3524` | leaf, `#30D158` | ring 2 px white@25% |
| Plant due today | same | same | ring 3 px `#0A84FF` |
| Plant overdue | same | same | ring 3 px `#FF453A` + halo 7 px `rgba(255,69,58,.25)` + badge "!" (18 px, `#FF453A`, 2 px border `#1C1C1E`, top-right −5) |
| Speaker | `#2C2C2E` | speaker, white (off: white@50%) | playing: green dot 14 px `#30D158` bottom-right −3 |
| Selected (any) | – | – | ring `0 0 0 3px #fff, 0 6px 18px rgba(0,0,0,.5)` + name pill below (top 52, padding 4/9, radius 9, `rgba(0,0,0,.8)`, 12/600) |

Icons: simple filled glyphs (bulb, speaker with cone, leaf) – see `design/UI Library.dc.html` → "Grundriss-Marker" for exact shapes; replace with your icon set at the same optical size (15–16 px).

**Inspector variants** (bottom-left card)
- **Nothing selected** – "Tap a room or device" 20/700 + one line text2.
- **Room** – name 20/700, sub (area) 14 text2; buttons right: "Lights on/off" (secondary) and "Water N" (primary, only when plants are due); below a 3-column stat grid (tiles `#2C2C2E`, radius 14, padding 9/14: label 13/600 text2, value 16/700): Lights "2 of 3 on", Plants "4 · 1 to water", Speakers "Playing | Idle | None".
- **Light** – row: 48 px power circle (tap = toggle; colors as marker) · name 20/700 + "Room · 80% | Off" · "Remove" (destructive). Row 2: horizontal **SliderBar** (height 40, radius 12, track `#3A3A3C`, fill = light color, label "80%" inside left 14/700, dark text when fill > 20%) + 5 color swatches (30 px, selected ring `0 0 0 2px #1C1C1E, 0 0 0 4px #fff`). Only show controls the entity supports (see capability model).
- **Plant** – 100 × 100 photo (radius 18, fallback initial) · name 20/700, "Room · Every 7 days", status 15/600 colored (overdue `#FF6961`, today `#409CFF`, watered `#30D158`, future text2) · buttons "Water now" (primary) / "Undo" (secondary when watered today), "Remove".
- **Speaker** – 48 px icon circle · name · "Room · Playing | Paused | Not in group" · "Join group / Leave group" · "Remove". Row 2: 40 px album art (radius 8) · title 15/600 + artist 13 text2 (150 px) · 40 px white play/pause button · volume SliderBar (white fill, label "Volume 35%").

### 2. Floor plan – widgets (dashboard)
- **XL 728×356** – "Home" 20/700 + plan below (same rendering, markers 24 px, no names). Tap a marker → open full plan with that device selected.
- **M 356×170** – "Home" + 3 rows (28 px icon circle + label 15/600 + value): Lights "4 on", Plants "2 overdue" (red) / "1 due today" (blue) / "All watered" (green), Music "Office, Kitchen" / "Paused".

### 3. Lights page
Reference: `Widget Kit` → tab **Lights**, widgets + full page.
- Full page grid `1.5fr | 1fr`. Left card "Rooms": 3-column grid of room tiles (radius 22, padding 16; on = `color@18%` background, 52 px icon circle in light color with glow; off = `#2C2C2E`). Tap tile = select, tap icon = toggle. Right card = selected room: vertical brightness slider + scene buttons (Relax 55 % `#FFB340`, Read 85 % `#FFE08A`, Focus 100 % `#BFE3FF`, Night 12 % `#FF9F6B`), active scene `#0A84FF`.
- Widgets S/M/L/XL as in the kit (fixed tile height 100 px in the dashboard version).
- "All off / All on" secondary button in the header.

### 4. Plants page
Reference: `Widget Kit` → tab **Plants**.
- Full page "Watering plan": header (26/700 + "N due today · 17 plants") + "Water all" primary. Week view: 7 columns starting today; today column `#2C2C2E` radius 16 with blue date badge; other days faded preview. Items: photo thumb + name; tap toggles watered (opacity .35 when done); overdue = red ring + red name.
- Overview widget: only two groups, "Overdue" (red label) and "Today", as simple rows.
- Photos are uploaded per plant (camera or gallery) and stored locally.

### 5. Music page
Reference: `Widget Kit` → tab **Music**.
- Top card: current track with album-art tint (art color @30 % behind the card), title 24/700, artist 16 text2, progress bar (4 px, white fill) with elapsed / remaining (11, tabular), controls prev / play-pause / next.
- Below grid `1.4fr | 1fr`: "Jump back in" (3-col grid of playlist tiles) and "Up next" (queue rows: 40 px art radius 8, title 16/600 – current track `#1DB954` on `#2C2C2E` row).
- Dashboard: compact player only (no big cover).
- Speaker group selection per room (join/leave) lives in the floor plan inspector and on this page.

---

## Interactions & Behavior

### Floor plan
- **Tap room** → select room (inspector = room). Tap again → deselect. Tapping a room also closes any open group.
- **Tap marker** → select device. **Drag marker** (threshold 5 px) → moves it; position snaps nothing (free), clamped 20 cm inside plan bounds. Room membership is computed from the position (`Path.contains` on room polygons) – dropping a plant into another room moves it there.
- **Drag from tray** → a ghost (44 px, white ring, shadow `0 10px 28px rgba(0,0,0,.55)`) follows the finger; once over the plan the device becomes placed and follows directly.
- **Remove** (inspector) → device goes back to the tray.
- **Grouping**: while dragging, the nearest other visible device within **40 cm** is the drop target – it scales to 1.18, gets a blue ring `0 0 0 3px #0A84FF, 0 0 0 9px rgba(10,132,255,.28)` and a blue pill "Group" above. Over an existing group the pill reads "Add to group". On drop the dragged device snaps to target + (7, 5) cm. Devices closer than **34 cm** form a group (single-linkage). The device being dragged is excluded from grouping.
- **Group appearance** (default "Stack"): up to 3 member markers stacked with offsets (0,0), (−7,−6), (−14,−12) px and scales 1 / .9 / .8, front one with drop shadow; count pill bottom-right (22 px, white on dark; red `#FF453A` if any member is overdue). Alternative "Ring": 44 px circle with conic segments in each member's status color and the count in the middle.
- **Fan out**: tap a group → members animate out to a full circle, radius `44 + n×4` px, starting at 12 o'clock, 35 ms stagger per member. The group centre shows a 30 px "×" close button. **No dark backdrop.** Members can be tapped or dragged out; a group of one dissolves automatically.
- **Layer chips** hide/show plants, lights, speakers and the glow.

### Animation spec
| What | Duration | Curve |
|---|---|---|
| Marker move / fan out / collapse | 450 ms | `Cubic(.3, 1.25, .5, 1)` (slight overshoot) |
| Scale (lift, target, pop) | 350–400 ms | `Cubic(.3, 1.5, .5, 1)` |
| Opacity, colors, shadows | 200–250 ms | ease |
| Glow on/off | 500 ms | ease |
| Tab indicator slide | 450 ms | `Cubic(.3, 1.35, .5, 1)` |
| While dragging | no position animation – follow the finger 1:1; lifted scale 1.12, ring `0 0 0 3px #fff, 0 14px 30px rgba(0,0,0,.55)` |

Flutter: `AnimatedPositioned` / `AnimatedScale` / `AnimatedOpacity` with a custom `Cubic`, or a `SpringSimulation` with similar feel. Keep one widget per device (stable keys) so moves animate instead of re-creating.

### Lights
- Toggle, brightness (1–100 %), color, color temperature – only if supported.
- Slider drags send throttled updates (≤ 5/s) and a final value on release.
- Room action "Lights on/off" affects all placed lights in that room.

### Plants
- `due in = every − daysSinceWatered`. `< 0` overdue, `= 0` today.
- "Water now" sets `lastWatered = now` and keeps the previous value for **Undo** (same day).
- "Water N" (room) / "Water all" (page) waters every due plant.

### Music
- Play/pause, next/previous, volume per speaker, join/leave group.
- Spotify: playback goes to the Sonos speaker via Spotify Connect; playlists from HA's media browser or directly via the Spotify Web API (OAuth PKCE). **Requires Spotify Premium**; dev-mode apps are limited to 5 users (fine for one household).

---

## State & Data

```dart
// Persisted locally (drift)
class FloorPlan { String unit = 'cm'; List<Room> rooms; List<Wall> walls; List<Door> doors; }
class Room { String id; String name; List<Offset> polygon; }
class Wall { String id; List<Offset> polygon; }
class Door { String id; DoorType type; Offset a; Offset b; }   // door | open

class Placement { String deviceId; DeviceKind kind; Offset pos; bool placed; } // kind: light | speaker | plant
class Plant { String id; String name; int everyDays; DateTime lastWatered; DateTime? prevWatered; String? photoPath; }

// Live from Home Assistant (not persisted)
class LightState { String entityId; bool on; int brightnessPct; Color? color; int? kelvin; Set<LightCap> caps; }
class SpeakerState { String entityId; PlayState state; int volumePct; List<String> groupMembers; MediaInfo? media; }

// UI state
selection: null | room(id) | device(id)
openGroupKey: String?        // sorted member ids joined by '|'
dragId: String?, ghost: Offset?
layers: {plants, lights, speakers, glow}
```
- `Placement.deviceId` = HA `entity_id` for lights/speakers, local id for plants.
- Room of a device is **derived** from `pos` + polygons, never stored.

### Capability model (lights)
Read `supported_color_modes` from the HA entity:
| HA color mode | Show |
|---|---|
| `onoff` | power only |
| `brightness` | + brightness slider |
| `color_temp` | + warm↔cool slider (`color_temp_kelvin`) |
| `hs` / `rgb` / `xy` | + color swatches |
Service: `light.turn_on` with `brightness_pct`, `rgb_color` or `color_temp_kelvin`; `light.turn_off`. Govee via HA (`govee_light_local`) exposes the same entity model – LAN control must be enabled per device in the Govee app.

### Home Assistant calls (speakers)
`media_player.media_play_pause`, `media_next_track`, `media_previous_track`, `volume_set` (0–1), `media_player.join` / `unjoin`, `play_media` (Spotify URI).

---

## Design Tokens
Full visual reference: `design/UI Library.dc.html`.

**Colors**
| Token | Value |
|---|---|
| bg | `#000000` |
| surface | `#1C1C1E` |
| elevated | `#2C2C2E` |
| control | `#3A3A3C` |
| controlStrong | `#48484A` |
| selected (segment) | `#636366` |
| floor | `#262628` · wall stroke `#636366` |
| text | `#FFFFFF` |
| text2 | `rgba(235,235,245,.60)` |
| text3 | `rgba(235,235,245,.45)` |
| separator | `rgba(84,84,88,.60)` |
| accent | `#0A84FF` · accent text `#409CFF` · accentTint `rgba(10,132,255,.22)` |
| danger | `#FF453A` · danger text `#FF6961` |
| success | `#30D158` · plant marker bg `#1E3524` |
| playing | `#1DB954` |
| light presets | warm `#FFB340`, soft `#FFE08A`, sunset `#FF9F6B`, cool `#BFE3FF`, violet `#BF5AF2` |

**Typography** (size / weight / letter-spacing)
display 46/700/−1.5 · pageTitle 28/700/−0.6 · sectionTitle 24/700/−0.4 · widgetTitle 20/700 · body 17/600 · secondary 15/400 text2 · label 13/600 · micro 11/700 caps +0.4. Numbers use tabular figures.

**Spacing** 4 · 8 · 12 · 16 · 20 · 24
**Radii** 8 thumbs · 12 sliders/events · 14–16 rows · 20–22 room tiles · 24 widgets · 26 page cards · pill (buttons, chips, markers)
**Widget grid** unit 170 px, gap 16: S 170×170 · M 356×170 · L 356×356 · XL 728×356
**Buttons** primary `#0A84FF` / secondary `#2C2C2E` / destructive `#2C2C2E` + `#FF6961`; height 36–44, pill, pressed scale .96
**Touch targets** ≥ 44 px

## Assets
- No raster assets. Icons in the prototype are simple inline SVG glyphs (bulb, speaker, leaf, play/pause) – use an icon set with equivalent shapes.
- Plant photos: user-provided per plant.
- Album art: from the media player / Spotify metadata.

## Files
| File | What it shows |
|---|---|
| `data/floorplan.json` | **The apartment** (cm): 7 rooms, doors and open passages – load this as the initial plan |
| `design/Widget Kit.dc.html` | All features, widget sizes S–XL and full pages. Tabs: Plants, Lights, Music, **Plan**. Tweak `groupStyle` = Stack / Ring |
| `design/Floor Plan Editor.dc.html` | Editor used to create `floorplan.json` (later phase; reference for data model + editing behaviour) |
| `design/UI Library.dc.html` | Tokens and every component state |
| `design/Roadmap.dc.html` | Phases, milestones, risks (German) |
| `design/support.js`, `image-slot.js`, `doc-page.js` | Runtime for opening the prototypes in a browser – not needed in the app |

## Suggested build order (this handoff)
1. HA connection + entity list, kiosk mode.
2. Floor plan rendering from `floorplan.json` with test devices, drag, tray, grouping, animations, persistence.
3. Hue lights live (state, toggle, brightness, color, glow).
4. Govee via HA – must work without code changes.
5. Plants (local data, due states, water/undo, photos).
6. Sonos + Spotify (state on marker, inspector controls, music page).

## Acceptance criteria
- Changing a light in the Hue app shows on the plan within 1 s, and vice versa.
- A new HA light entity can be placed and controlled without code changes.
- Positions and plants survive an app restart.
- Dragging stays at 60 fps on the target tablet with ~30 markers.
- Offline state is visible and controls are disabled.

## Open questions
- Replacement font for Android.
- Exact length of the office/storage wall (currently 1.70 m in the JSON; user mentioned 1.40 m – confirm on site).
- Whether plants get soil-moisture sensors later (would replace fixed intervals).
