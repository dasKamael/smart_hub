# Testing

## Layout

`test/` mirrors `lib/`. One test file per source file, same name with `_test` appended:
`lib/domain/plants/watering_due.util.dart` → `test/domain/plants/watering_due.util_test.dart`.

```
test/
├─ architecture/        layer, context, naming, file location and code quality rules + utils/arch_utils.dart
├─ common/  data/  domain/  presentation/
├─ fixtures/
│  └─ ha/               real get_states dumps (lights, media players) as JSON
├─ mocks/               mocktail mocks shared across tests
└─ utils/
   ├─ riverpod.test_util.dart     createTestContainer()
   └─ widget.test_util.dart       loadWidgetTestApp()
packages/ha_client/test/          protocol tests against FakeHomeAssistant
integration_test/       performance tests (profile mode, real tablet)
test_driver/            writes timeline summaries to build/
```

## Test names

Given / When / Then in the description, matching comments in the body:

```dart
test('Given a plant watered 8 days ago with interval 7, '
    'when calculating the due state, '
    'then it is overdue by 1 day', () {
  // Given
  final plant = buildPlant(everyDays: 7, lastWatered: DateTime(2026, 10, 18));

  // When
  final due = withClock(Clock.fixed(DateTime(2026, 10, 26)), () => WateringDueUtil.dueIn(plant));

  // Then
  expect(due, -1);
});
```

## What to test per layer

| Layer | How | Focus |
|---|---|---|
| `domain/*.util.dart` | plain `test` | All edge cases: polygon borders, 34 cm / 40 cm thresholds exactly at the limit, clamping, due today vs. overdue |
| `domain/*.service.dart` | `createTestContainer` with repository overrides (mocktail) | Orchestration, optimistic overlay + rollback (`fake_async`), offline behaviour |
| `data/*.repository.dart` | fixtures from `test/fixtures/ha/` against `FakeHomeAssistant`; drift with `NativeDatabase.memory()` | Mapping HA → domain (e.g. every HA color mode → capabilities), service call payloads, persistence round trips |
| `data/database` | drift migration tests against `drift_schemas/` | Every schema version upgrades cleanly |
| `presentation/*.controller.dart` | `createTestContainer` with service overrides | Selection, grouping, drag state, throttling |
| `presentation/**` widgets & screens | `loadWidgetTestApp` | Correct variant rendered (inspector, marker states), gestures (tap, drag threshold 5 px, drop on target), controls disabled while offline, only supported controls shown |
| `packages/ha_client` | `dart test` + `FakeHomeAssistant` + `fake_async` | Auth, id correlation, error results, reconnect backoff, resubscribe after reconnect |
| `integration_test/` | `flutter drive --profile --no-dds` on the tablet | Drag performance with ~30 markers (frame timings, see CLAUDE.md) |

The acceptance criterion "a new HA light works without code changes" is covered by fixtures: add the
`get_states` dump of a new light type (e.g. Govee) and assert capabilities and service calls without
touching production code.

## Test utils

- `createTestContainer({overrides, observers, retry})` – `ProviderContainer` with Riverpod retry disabled
  and `addTearDown(container.dispose)`. Use it instead of `ProviderContainer()` directly.
- `loadWidgetTestApp({tester, underTestWidget, container, pumpAndSettle})` – wraps the widget in
  theme + `UncontrolledProviderScope`, sets the tablet landscape surface size and returns a
  `BuildContext`.
- Shared mocks go into `test/mocks/` (`*.mock.dart`), one-off mocks stay in the test file.

## Rules

- No real network, no real HA, no real file system outside temp dirs.
- No sleeps or real timers: use `fake_async`, `tester.pump(duration)` and `withClock` / `Clock.fixed`.
- Every bug fix starts with a failing test.
- New pure logic (`*.util.dart`) is written test-first.
- Coverage target: `domain/` and `packages/ha_client` ≥ 90 %; no fixed number for presentation.

## Architecture tests

`test/architecture/` checks the rules from `docs/architecture.md` by scanning `lib/` (same approach as
`arch_utils.dart` in the coodoo s-broker app; generated files are skipped):

- `layer_rules_test.dart` – dependency rules 1–3 and 7.
- `context_rules_test.dart` – rules 4–6: `data/<ctx>` only used by `domain/<ctx>`, `ha_client` only in
  `lib/data/`, `domain/floorplan` independent of other device contexts.
- `naming_conventions_test.dart` – suffix → class name (table in `docs/architecture.md`).
- `file_location_test.dart` – screens/controllers in `presentation`, repositories/tables in `data`.
- `code_quality_test.dart` – no `print` / `debugPrint`, no relative imports in `lib/`,
  no `DateTime.now()` outside `common/`, no test files in `lib/`, no brand names outside `lib/data/`.

New rules go here instead of into review comments. Known violations are listed explicitly with a reason
and removed once fixed.
