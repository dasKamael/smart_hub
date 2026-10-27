# Backlog

Open wishes and known gaps, newest first. Each one gets a short concept before it is built.

## Lights: scenes per room, matching what the lamps can do

Reported 2026-10-27. Today every room offers the same four scenes (Relax, Read, Focus, Night) with fixed colors
(`LightScene.all`).

- Scenes should be saved per room, not one set for all.
- Some lamps cannot show a cool / blue tone (color temperature only, or only a warm range). After choosing Focus in the
  hall, the slider and the room tile stay amber, yet Focus shows as active – the active scene is only matched by
  brightness (`LightRoom.activeScene`), and the scene's color is sent although the lamp cannot take it.
- To decide: which scenes a room offers (and its own presets), how a scene adapts to the room's lamps (capability
  model), and that "active" also compares color / color temperature.

## Design: area colors on the pages

The pages carry their area color in the glow and the page cards (`HubAreaColors`). Open: stronger page tint (~30 %),
"Jump back in" / "Up next" in the cover color, a hint of the area color in tiles inside the pages.

## Dashboard widgets

- To-dos (local, check off in the widget)
- News (RSS feeds)
- Calendar via iCal link (read-only) – later
