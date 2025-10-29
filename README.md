# Twilio Programmable Video for Flutter (Community)

A community-maintained Flutter plugin that wraps Twilio Programmable Video (WebRTC) for Android, iOS and Web. This repo hosts the full monorepo (plugin, platform interface, web implementation, and example app) updated to run on modern Flutter (3.24+).

> This project is not affiliated with Twilio. Please open issues here rather than contacting Twilio Support.

---

## Highlights

- Works with Flutter 3.24+
- Android: minSdk 23, target/compile SDK 35, Kotlin 2.2.20, AGP 8.7.3
- iOS: platform iOS 12+
- Web: Twilio Video JS (see Web setup)
- Features: join/leave rooms, publish/subscribe audio/video/data, device selection, event streams, example app

---

## Monorepo layout

- `programmable_video/` — the Flutter plugin used by apps
- `programmable_video_platform_interface/` — platform interface (do not depend on in apps)
- `programmable_video_web/` — web implementation
- `programmable_video/example/` — full example app (Android/iOS/Web)

---

## Quick start

Add the plugin to your app directly from your GitHub fork (recommended):

```yaml path=null start=null
dependencies:
  twilio_programmable_video:
    git:
      url: https://github.com/your-org/programmable-video.git
      path: programmable_video
      ref: main # or your tag/branch
```

Request a Room token from your backend and connect:

```dart path=null start=null
import 'package:twilio_programmable_video/twilio_programmable_video.dart';

Future<Room> connect(String token, String roomName) async {
  final sources = await CameraSource.getSources();
  final capturer = CameraCapturer(
    sources.firstWhere((s) => s.isFrontFacing),
  );
  final room = await TwilioProgrammableVideo.connect(
    ConnectOptions(
      token,
      roomName: roomName,
      audioTracks: [LocalAudioTrack(true)],
      videoTracks: [LocalVideoTrack(true, capturer)],
      preferredAudioCodecs: [OpusCodec()],
      preferredVideoCodecs: [H264Codec()],
    ),
  );
  return room;
}
```

---

## Platform setup

### Android

1) Permissions in `android/app/src/main/AndroidManifest.xml`:

```xml path=null start=null
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.BLUETOOTH"/>
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>
```

2) ProGuard / R8 rules in `android/app/proguard-rules.pro`:

```proguard path=null start=null
-keep class tvi.webrtc.** { *; }
-keep class com.twilio.video.** { *; }
-keep class com.twilio.common.** { *; }
-keepattributes InnerClasses
```

3) Gradle configuration (already wired in the example):
- minSdkVersion 23
- compileSdkVersion 35
- targetSdkVersion 35
- Kotlin 2.2.20
- Android Gradle Plugin 8.7.3

If you add Firebase (as in the example), place your `google-services.json` in `android/app/`.

### iOS

- Set the platform to iOS 12+ (Podfile):

```ruby path=null start=null
platform :ios, '12.0'
```

- Add permissions in `ios/Runner/Info.plist`:

```xml path=null start=null
<key>NSCameraUsageDescription</key>
<string>Need camera for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>Need microphone for audio in calls</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```

- If you need background audio while in-room, enable "Audio, AirPlay, Picture in Picture" background mode.

Run:

```bash path=null start=null
cd ios && pod install && cd -
```

### Web

Add Twilio Video JS to `web/index.html`:

```html path=null start=null
<script src="//media.twiliocdn.com/sdk/js/video/releases/2.14.0/twilio-video.min.js"></script>
```

The plugin validates the JS SDK version (major must match; minor must be <= plugin’s supported minor).

---

## Example app (this repo)

Build and run the included example:

```bash path=null start=null
# Android
flutter pub get
flutter build apk -v
# iOS
flutter pub get
flutter build ios --no-codesign
# Web
flutter run -d chrome
```

The example demonstrates joining rooms, participant management, media devices, and data tracks. Provide your own access tokens.

---

## API overview

Key classes you’ll use:
- `TwilioProgrammableVideo` — static utilities and configuration
- `ConnectOptions` — how you join a room
- `Room` — lifecycle and events (connected/disconnected/reconnecting)
- `LocalAudioTrack`, `LocalVideoTrack`, `CameraCapturer`
- `RemoteParticipant` and track subscription events
- `LocalDataTrack` / `RemoteDataTrack` for low-latency messaging

See `programmable_video/lib/` for all APIs and the example code for end-to-end usage.

---

## Compatibility matrix

| Component | Version |
|---|---|
| Flutter | 3.24+ |
| Dart | 3.5+ |
| Android minSdk | 23 |
| Android target/compile | 35 |
| Kotlin | 2.2.20 |
| Android Gradle Plugin | 8.7.3 |
| iOS platform | 12.0+ |

> If your app pins different versions, align with the above to avoid build failures.

---

## Troubleshooting

- AGP/Kotlin version conflicts: ensure your app does not override the plugin’s AGP/Kotlin versions.
- Google Services error: add `google-services.json` to `android/app/` or remove the plugin if not needed.
- ProGuard warnings from WebRTC/Twilio jars are informational; ensure the rules above are present.
- Web SDK version check fails: update the script tag to a supported version (e.g., 2.14.0).

---

## Contributing

Contributions are welcome! Please follow the existing code style in each package and open merge requests. See CONTRIBUTING.md (coming soon / or in original project).

---

## License

MIT (same as original community project). See LICENSE.
