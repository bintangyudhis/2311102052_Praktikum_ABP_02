# 📖 Panduan Instalasi dan Setup

## Daftar Isi

- [Prasyarat](#prasyarat)
- [Instalasi Dependencies](#instalasi-dependencies)
- [Konfigurasi Platform](#konfigurasi-platform)
- [Menjalankan Aplikasi](#menjalankan-aplikasi)
- [Build untuk Release](#build-untuk-release)
- [Troubleshooting](#troubleshooting)

---

## ✅ Prasyarat

### Software yang Harus Diinstall

1. **Flutter SDK** (versi 3.10.7 atau lebih baru)
   - Download dari: https://flutter.dev/docs/get-started/install

2. **Dart SDK** (sudah included dalam Flutter)

3. **IDE/Editor**
   - Android Studio dengan Flutter plugin
   - VS Code dengan Flutter dan Dart extensions
   - Atau editor lainnya

4. **Platform Specific Tools**
   - **Android**: Android SDK (API 21+)
   - **iOS**: Xcode (macOS only)

### Verifikasi Instalasi

```bash
# Cek versi Flutter
flutter --version

# Cek environment setup
flutter doctor

# Output yang diharapkan: No issues found!
```

---

## 📦 Instalasi Dependencies

### 1. Buka Project Directory

```bash
cd d:\KULIAH\Semester\ 6\Praktikum\ ABP\Pertemuan-8
```

### 2. Install Dependencies dari pubspec.yaml

```bash
flutter pub get
```

**Output yang diharapkan**:

```
Running "flutter pub get" in bintangyudhistira_tugas7a...
...
Got dependencies in 5 seconds.
```

### 3. Verify Dependencies

```bash
flutter pub outdated
```

### Dependencies yang Diinstall

| Package                       | Version | Fungsi                |
| ----------------------------- | ------- | --------------------- |
| `image_picker`                | ^1.0.0  | Akses kamera & galeri |
| `camera`                      | ^0.10.0 | Camera API            |
| `flutter_local_notifications` | ^16.0.0 | Notifikasi lokal      |
| `permission_handler`          | ^11.0.0 | Manajemen permissions |

---

## ⚙️ Konfigurasi Platform

### Android Configuration

#### 1. AndroidManifest.xml

**File**: `android/app/src/main/AndroidManifest.xml`

Pastikan permissions sudah ditambahkan:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Tambahan permissions -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />

    <application>
        ...
    </application>
</manifest>
```

#### 2. build.gradle.kts

**File**: `android/build.gradle.kts`

Pastikan menggunakan gradle versi terbaru:

```kotlin
plugins {
    id "com.android.application" version "7.3.0"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
}
```

#### 3. Minimal API Level

**File**: `android/app/build.gradle.kts`

```kotlin
android {
    compileSdk 34

    defaultConfig {
        minSdkVersion 21  // ← Minimal API 21
        targetSdkVersion 34
    }
}
```

### iOS Configuration

#### 1. Info.plist

**File**: `ios/Runner/Info.plist`

Pastikan permissions sudah ditambahkan:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    ...

    <!-- Camera & Photo Permissions -->
    <key>NSCameraUsageDescription</key>
    <string>Aplikasi membutuhkan akses ke kamera untuk mengambil foto</string>

    <key>NSPhotoLibraryUsageDescription</key>
    <string>Aplikasi membutuhkan akses ke galeri untuk memilih foto</string>

    <key>NSPhotoLibraryAddUsageDescription</key>
    <string>Aplikasi membutuhkan izin untuk menyimpan foto ke galeri</string>

    <key>NSMicrophoneUsageDescription</key>
    <string>Aplikasi membutuhkan akses ke mikrofon untuk merekam video</string>

    ...
</dict>
</plist>
```

#### 2. Podfile Configuration

**File**: `ios/Podfile`

Pastikan minimal iOS deployment target:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        'PERMISSION_CAMERA=1',
        'PERMISSION_PHOTOS=1',
      ]
    end
  end
end
```

#### 3. Deployment Target

Minimal iOS 11.0

---

## 🚀 Menjalankan Aplikasi

### 1. Daftar Device yang Tersedia

```bash
flutter devices
```

**Output contoh**:

```
2 connected devices:

Android SDK built for x86   • emulator-5554   • android-x86    • Android 11 (API 30)
iPhone 14 Pro Max           • ios-simulator   • ios            • iOS 16.0
```

### 2. Jalankan di Emulator/Device

**Android Emulator**:

```bash
flutter run -d emulator-5554
```

**iOS Simulator**:

```bash
flutter run -d ios-simulator
```

**Device Fisik**:

```bash
# Android
flutter run -d <device-id>

# iOS - hubungkan device dan
flutter run -d ios
```

**Jalankan dengan profiling**:

```bash
flutter run --profile
flutter run --release
```

### 3. Hot Reload & Hot Restart

Saat aplikasi sudah berjalan:

**Hot Reload** (update code tanpa reset state):

```
Tekan 'r' di terminal
```

**Hot Restart** (update code dengan reset state):

```
Tekan 'R' di terminal
```

### 4. Debug

```bash
flutter run -v  # Verbose output
flutter run -d <device-id> --verbose
```

---

## 📱 Testing di Device

### Testing Checklist

- [ ] **Kamera**
  - [ ] Tap tombol "Ambil Foto dari Kamera"
  - [ ] Kamera membuka
  - [ ] Ambil foto
  - [ ] Foto ditampilkan di app
  - [ ] Notifikasi muncul

- [ ] **Galeri**
  - [ ] Tap tombol "Pilih Foto dari Galeri"
  - [ ] Galeri membuka
  - [ ] Pilih foto
  - [ ] Foto ditampilkan di app
  - [ ] Notifikasi muncul

- [ ] **Permissions**
  - [ ] First run: Dialog permission muncul
  - [ ] Approve: Features berfungsi
  - [ ] Reject: Error message muncul

- [ ] **UI/UX**
  - [ ] Placeholder tampil dengan baik
  - [ ] Foto ditampilkan dengan ukuran sempurna
  - [ ] Informasi ukuran file ditampilkan
  - [ ] Layout responsive di berbagai ukuran screen

---

## 📦 Build untuk Release

### Build APK (Android)

```bash
# Debug APK
flutter build apk

# Release APK
flutter build apk --release

# APK yang dapat dibagi (split by ABI)
flutter build apk --split-per-abi
```

**Output**:

```
✓ Built build/app/outputs/flutter-apk/app-release.apk (21.3 MB).
```

### Build AAB (Android App Bundle)

```bash
flutter build appbundle --release
```

**Untuk upload ke Play Store**

### Build iOS

```bash
# Debug
flutter build ios

# Release
flutter build ios --release
```

**Output**: `build/ios/iphoneos/Runner.app`

### Build Web

```bash
flutter build web --release
```

**Output**: `build/web/`

---

## 🐛 Troubleshooting

### 1. Error: "flutter: command not found"

**Solusi**:

```bash
# Tambahkan Flutter ke PATH
export PATH="$PATH:`pwd`/flutter/bin"

# Atau di Windows, tambahkan ke environment variables
# Variable Name: PATH
# Value: C:\path\to\flutter\bin
```

Verifikasi:

```bash
flutter --version
```

---

### 2. Error: "CocoaPods could not find compatible versions"

**Solusi**:

```bash
cd ios
pod repo update
pod install
cd ..
flutter pub get
flutter run
```

---

### 3. Error: "Permission denied" saat menjalankan gradlew

**Solusi**:

```bash
# Linux/Mac
chmod +x android/gradlew

# Windows - buka Command Prompt sebagai Administrator
cd android
gradlew.bat
```

---

### 4. Error: "Gradle build failed"

**Solusi**:

```bash
# Clean build
flutter clean
flutter pub get
flutter run

# Atau jika masih error
rm -rf build/
flutter pub get
flutter run
```

---

### 5. Error: "Emulator not starting"

**Solusi**:

```bash
# List emulators
flutter emulators

# Start emulator
flutter emulators --launch <emulator_name>

# Atau gunakan Android Studio
```

---

### 6. Error: "iPhone Simulator not available"

**Solusi**:

```bash
# Mac only - buka Xcode
open -a Simulator

# Atau dari command line
xcrun simctl list devices
```

---

### 7. Error: "Camera not opening"

**Penyebab & Solusi**:

| Error                  | Penyebab               | Solusi                                         |
| ---------------------- | ---------------------- | ---------------------------------------------- |
| "PERMISSION DENIED"    | No permission granted  | Approve di dialog permission                   |
| "CAMERA_ACCESS_DENIED" | Blocked di settings    | Settings > Apps > Permissions > Camera > Allow |
| "CAMERA_NOT_AVAILABLE" | Emulator tidak support | Gunakan device fisik                           |

---

### 8. Error: "Notification not showing"

**Penyebab & Solusi**:

```dart
// SALAH - Tidak initialize
void main() {
  runApp(const MyApp());  // ❌ Missing initialization
}

// BENAR - Initialize notifications
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeNotifications();  // ✅ Initialize
  runApp(const MyApp());
}
```

---

### 9. Error: "Image picker not working"

**Penyebab & Solusi**:

```dart
// SALAH - Wrong import
import 'package:image_picker/image_picker.dart';  // ❌ Tapi package tidak installed

// BENAR - Pastikan install di pubspec.yaml
// dependencies:
//   image_picker: ^1.0.0

flutter pub get
```

---

### 10. Device tidak terdeteksi

**Solusi**:

```bash
# List devices
flutter devices

# Android - pastikan debug mode on
# iOS - pastikan developer certificate valid

# Reconnect device
# Atau restart device & computer

# Reset adb cache
adb kill-server
adb start-server
```

---

## 📊 Verifikasi Setup Berhasil

Jalankan perintah berikut dan pastikan semua OK:

```bash
flutter doctor
```

**Output yang diharapkan**:

```
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, ...)
[✓] Android toolchain - develop for Android devices (...)
[✓] Xcode - develop for iOS and macOS (...)  # Jika Mac
[✓] Android Studio (...)
[✓] VS Code (...)  # Jika pakai VS Code
[✓] Connected device (...)

No issues found!
```

---

## ✨ Setup Selesai!

Aplikasi siap dijalankan. Gunakan perintah:

```bash
flutter run
```

Untuk mulai development. Enjoy! 🎉

---

## 📚 Referensi

- [Flutter Documentation](https://flutter.dev/docs)
- [Image Picker Documentation](https://pub.dev/packages/image_picker)
- [Camera Plugin](https://pub.dev/packages/camera)
- [Local Notifications](https://pub.dev/packages/flutter_local_notifications)
- [Permission Handler](https://pub.dev/packages/permission_handler)

---

**Last Updated**: 2026
