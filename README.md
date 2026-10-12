# CarePill

> An AI-powered medication manager for older adults: it helps them remember which
> medicine to take and when, with alarm-grade reminders — managing medication is as
> easy as "say a sentence, take a photo". No account, all data stays on the device,
> and the model provider is added by the user.

[`docs/`](docs/README.md) is the single source of truth for the product and its
implementation (planning → architecture → data → reminders → AI → UI; read the
relevant document before changing code).

## Current Status

- M0 skeleton ✅: Riverpod + go_router + Drift + OpenAI-compatible AI client + notification pipeline + senior-friendly theme.
- Android seed-user release ✅ (pending real-device matrix acceptance): plan edits immediately reschedule tasks and reminders, WorkManager daily compensation, notifications restored after reboot, AI check-ins on a fixed clock with date boundaries, backup overwrite/rollback/secret retention, and a complete first-run onboarding round trip.
- M2 partially done ✅: photo recognition (vision-capability gating + draft confirmation), voice (system TTS/STT), statistics and AI weekly reports, backup export/import.
- Barcode drug lookup ✅: scan locally or type a product barcode → free openFDA lookup → verify and fill in → save; coverage is mainly the US market, and the limits for drugs sold in China and for traceability codes are described in the [note](docs/11-药品条码查询.md).
- See "Current Progress" in docs/README.md.

## Development Setup

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # Drift/freezed/slang codegen
flutter analyze          # must report zero issues
dart run tools/check_layering.dart   # layering dependency check (docs/04 §7)
flutter test             # unit + widget tests
flutter run              # Android device/emulator (launch platform, docs/09 Q1)
```

### Notes for Windows Machines

- Running the desktop build requires Developer Mode (symlink permission): `start ms-settings:developers`;
  Android builds are unaffected.
- Android builds require JDK 17+ (Gradle enforces this); on mainland-China networks, keep the
  Aliyun mirrors in `android/settings.gradle.kts` / `android/build.gradle.kts`.

### Chinese/English Localization

- Uses the third-party [`slang`](https://pub.dev/packages/slang) / `slang_flutter` packages; Chinese is the fallback language.
- Copy lives in `lib/i18n/zh.i18n.json` and `lib/i18n/en.i18n.json`. Run `dart run slang` after editing; never hand-edit `strings*.g.dart`. CI and `build_runner` share the same `build.yaml` configuration.
- On first launch the app picks Chinese or English to match the device language, falling back to Chinese for anything else. Both the onboarding pages and "Settings → 语言 / Language" can switch it, and the choice is stored on the device; restoring a medication backup does not change the language.
- Slang generates plain Dart resources shared by screens, background reminders, and services. `MaterialApp` subscribes to Slang's language stream, and widgets that use the global `tr` subscribe to Flutter locale changes in `build` via `Localizations.localeOf(context)` so retained routes and constant subwidgets refresh.
- Switching the language reschedules pending reminders; TTS/STT use the matching language, and AI chat and weekly-report prompts tell the model to answer in the selected language. Drug names, free-form unit input, and past conversations keep their original text; stored date values and enum JSON values are unchanged.
- iOS permission prompts provide `InfoPlist.strings` for `en` / `zh-Hans`, chosen by the system language setting; the system dialogs still need verification on macOS / iOS. System speech still depends on the language packs installed on the device.
- Regression tests: `flutter test test/i18n_test.dart test/i18n_widget_test.dart`, covering resource completeness, interpolation, plurals, language persistence, and large-font layouts at two phone sizes.

## Icon and Splash Assets

The source artwork is `icon.png` in the project root. After replacing it, run `dart run tools/generate_brand_assets.dart` to generate the Android/iOS icons, the native splash screens, and the in-app `BrandMark` images — no extra icon-generation plugin is needed. Android notifications use a separate monochrome asset, `ic_notification`. Both adding and editing an AI provider go through a four-step setup wizard with official key-application links, recommended models, a pre-save test, and a "save now, test later" option.

The notification small icon and sound are preserved by `android/app/src/main/res/raw/keep.xml`, so resources that Dart accesses by name survive Release resource shrinking. After building, run `dart run tools/check_release_resources.dart` to check the final APK; Release acceptance must cover a cold start after a force stop. Notifications and WorkManager initialize after Flutter's first frame; failures or timeouts are logged, and the foreground app stays usable.

## CI

`.github/workflows/ci.yml`: `flutter analyze --fatal-infos` + layering check + `flutter test` + Manifest receiver check + Debug/Release APK builds + Release merged-manifest speech-permission check + final APK notification-resource check.

## Disclaimer

AI answers are generated by the model service the user adds themselves and are for reference only; follow your doctor's advice when taking medication.

## Agent Multi-turn Conversation and Voice Updates

- History and tool results are persisted per turn, with failed-retry, summarization, and a context budget; write-operation receipts support deduplication and conflict-detecting undo.
- Explicit long-term memory is managed separately, and clearing the chat keeps the memory. The database is upgraded to v2, and backup v2 can import v1/v2 while still not exporting keys or chats by default.
- Hold to record and release to send automatically (300 ms accidental-touch guard, swipe up to cancel); voice questions are spoken back automatically according to the TTS toggle. Audio is released when the app is backgrounded or the page is left.
- Verification records and the pending real-device matrix: [Agent v2 acceptance record](docs/10-Agent修复验收记录.md). Whether system speech works offline depends on the device engine and its language packs.
