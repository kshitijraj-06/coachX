# Pose Detection Setup Guide

## HTTP Security Configuration

### Problem
WebView cannot load insecure HTTP URLs by default on Android.

### Solution Implemented

#### 1. Network Security Config
Created `android/app/src/main/res/xml/network_security_config.xml`:
- Allows cleartext (HTTP) traffic
- Permits localhost and local network IPs
- Trusts system and user certificates

#### 2. AndroidManifest.xml
Updated with:
- `android:usesCleartextTraffic="true"`
- `android:networkSecurityConfig="@xml/network_security_config"`

#### 3. Flutter Dependencies
Added to `pubspec.yaml`:
```yaml
webview_flutter_android: ^3.16.0
http: ^1.2.0
```

## Quick Start

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Start Python Server
```bash
cd lib/Pose_Detection
python web_camera.py
```

### 3. Update Server IP
In `posePage.dart` and `poseAnalyzer.dart`, update:
```dart
'http://YOUR_LOCAL_IP:5000'
```

### 4. Run Flutter App
```bash
flutter run
```

## Allowed Domains
- `localhost`
- `127.0.0.1`
- `10.5.89.22` (current network IP)
- `192.168.0.0` subnet

## Add New IP Address
Edit `network_security_config.xml`:
```xml
<domain includeSubdomains="true">YOUR_IP_HERE</domain>
```

## Testing
1. Start Python server
2. Note the IP address shown
3. Open app and navigate to Pose Trainer
4. WebView should load without security errors

## Troubleshooting

### WebView shows blank page
- Check Python server is running
- Verify IP address matches
- Check network connectivity

### Security error persists
- Clean and rebuild: `flutter clean && flutter build apk`
- Verify network_security_config.xml exists
- Check AndroidManifest.xml has networkSecurityConfig attribute

### Camera not working
- Grant camera permissions in app settings
- Use HTTPS for production (HTTP works for local testing)
