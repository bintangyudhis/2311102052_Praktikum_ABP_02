# 🎯 Quick Reference Guide - Ambil & Pilih Foto App

## Struktur Proyek

```
bintangyudhistira_tugas7a/
├── lib/
│   └── main.dart                  # ⭐ File utama aplikasi
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml    # Konfigurasi Android
├── ios/
│   └── Runner/
│       └── Info.plist             # Konfigurasi iOS
├── pubspec.yaml                   # Dependencies & metadata
├── README.md                       # Dokumentasi lengkap
├── WIDGET_EXPLANATION.md          # Penjelasan detail setiap widget
├── FEATURES.md                    # Penjelasan fitur aplikasi
├── SETUP.md                       # Panduan instalasi & setup
└── this file (QUICK_REFERENCE.md) # Cheat sheet ini
```

---

## 🚀 Quick Start

### 1️⃣ Install Dependencies

```bash
flutter pub get
```

### 2️⃣ Run Aplikasi

```bash
flutter run
```

### 3️⃣ Build APK

```bash
flutter build apk --release
```

---

## 📱 Main Features

### Feature 1: Ambil Foto dari Kamera 📷

```dart
// Implementasi di _capturePhotoFromCamera()
final XFile? photo = await _picker.pickImage(
  source: ImageSource.camera,
);
```

**Button Color**: Biru (#2563EB)
**Notification**: "Foto Berhasil Diambil"

### Feature 2: Pilih Foto dari Galeri 📁

```dart
// Implementasi di _selectPhotoFromGallery()
final XFile? photo = await _picker.pickImage(
  source: ImageSource.gallery,
);
```

**Button Color**: Ungu (#7C3AED)
**Notification**: "Foto Berhasil Dipilih"

### Feature 3: Tampilkan Notifikasi 🔔

```dart
// Implementasi di _showNotification()
await flutterLocalNotificationsPlugin.show(
  0,
  title,
  body,
  platformChannelSpecifics,
);
```

**Channel ID**: `photo_channel`
**Platform**: Android & iOS

---

## 📁 File Penting & Fungsinya

| File                          | Fungsi              | Konfigurasi                                 |
| ----------------------------- | ------------------- | ------------------------------------------- |
| `lib/main.dart`               | Kode aplikasi utama | Camera, Gallery, Notifications              |
| `pubspec.yaml`                | Daftar dependencies | image_picker, camera, notifications         |
| `android/AndroidManifest.xml` | Permissions Android | CAMERA, READ/WRITE_EXTERNAL_STORAGE         |
| `ios/Info.plist`              | Permissions iOS     | NSCameraUsageDescription, NSPhotoLibrary... |

---

## 🔧 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.0.0 # Ambil & pilih foto
  camera: ^0.10.0 # Camera API
  flutter_local_notifications: ^16.0.0 # Notifikasi lokal
  permission_handler: ^11.0.0 # Manajemen permissions
```

---

## 📋 Permissions Checklist

### Android

- ✅ `android.permission.CAMERA`
- ✅ `android.permission.READ_EXTERNAL_STORAGE`
- ✅ `android.permission.WRITE_EXTERNAL_STORAGE`
- ✅ `android.permission.RECORD_AUDIO`

### iOS

- ✅ `NSCameraUsageDescription`
- ✅ `NSPhotoLibraryUsageDescription`
- ✅ `NSPhotoLibraryAddUsageDescription`
- ✅ `NSMicrophoneUsageDescription`

---

## 🎨 UI Components

### AppBar

```dart
AppBar(
  title: const Text('Ambil & Pilih Foto'),
  centerTitle: true,
  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  elevation: 0,
)
```

### Camera Button

```dart
ElevatedButton.icon(
  onPressed: _capturePhotoFromCamera,
  icon: const Icon(Icons.camera_alt),
  label: const Text('Ambil Foto dari Kamera'),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2563EB),  // Biru
  ),
)
```

### Gallery Button

```dart
ElevatedButton.icon(
  onPressed: _selectPhotoFromGallery,
  icon: const Icon(Icons.image),
  label: const Text('Pilih Foto dari Galeri'),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF7C3AED),  // Ungu
  ),
)
```

### Image Display

```dart
ClipRRect(
  borderRadius: BorderRadius.circular(12),
  child: Image.file(_selectedImage!, fit: BoxFit.cover),
)
```

---

## 🔄 State Management

### Variables

```dart
File? _selectedImage;              // Foto yang dipilih
final ImagePicker _picker = ImagePicker();  // Instance picker
```

### Update State

```dart
setState(() {
  _selectedImage = File(photo.path);
});
```

### Initialize

```dart
@override
void initState() {
  super.initState();
  _requestPermissions();  // Minta permission saat init
}
```

---

## 🔔 Notification Setup

### Initialize di main()

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeNotifications();  // ← PENTING
  runApp(const MyApp());
}
```

### Show Notification

```dart
await _showNotification(
  'Foto Berhasil Diambil',
  'Foto dari kamera telah disimpan!',
);
```

---

## ⚙️ Code Flow

```
User Launch App
        ↓
   main() runs
        ↓
Initialize Notifications
Request Permissions
        ↓
   MyApp displays
        ↓
PhotoCapturePage shown
        ↓
User taps camera/gallery button
        ↓
_capturePhotoFromCamera() / _selectPhotoFromGallery()
        ↓
setState() updates _selectedImage
        ↓
build() rebuilds UI
        ↓
Image displayed + Notification shown
```

---

## 🐛 Common Issues & Solutions

| Issue                           | Solution                                               |
| ------------------------------- | ------------------------------------------------------ |
| **Foto tidak ditampilkan**      | Check: file path valid, setState() called              |
| **Notifikasi tidak muncul**     | Check: \_initializeNotifications() dipanggil di main() |
| **Kamera tidak buka**           | Check: CAMERA permission di AndroidManifest.xml        |
| **Galeri tidak buka**           | Check: READ_EXTERNAL_STORAGE permission                |
| **App crash saat click button** | Check: try-catch block dalam function                  |

---

## 📊 Testing Checklist

- [ ] App launches successfully
- [ ] AppBar displays "Ambil & Pilih Foto"
- [ ] Camera button visible (blue color)
- [ ] Gallery button visible (purple color)
- [ ] Permission dialog appears on first use
- [ ] Camera opens when button tapped
- [ ] Gallery opens when button tapped
- [ ] Photo displays after selection
- [ ] File size information shows
- [ ] Notification appears after selection
- [ ] Placeholder shows when no photo selected

---

## 📚 Documentation Files

| File                    | Konten                                            |
| ----------------------- | ------------------------------------------------- |
| `README.md`             | Penjelasan lengkap project, teknologi, cara pakai |
| `WIDGET_EXPLANATION.md` | Detail penjelasan setiap widget & fungsinya       |
| `FEATURES.md`           | Penjelasan mendalam setiap fitur                  |
| `SETUP.md`              | Panduan instalasi, konfigurasi, troubleshooting   |
| `QUICK_REFERENCE.md`    | Cheat sheet ini - referensi cepat                 |

---

## 🎯 Key Points

✅ **Must Remember**:

1. Initialize notifications di `main()` before `runApp()`
2. Request permissions di `initState()`
3. Use `setState()` saat update `_selectedImage`
4. Check permissions di AndroidManifest.xml & Info.plist
5. Add error handling dengan try-catch

❌ **Don't**:

1. Forget to add permissions di manifest files
2. Skip notification initialization
3. Use `setState()` outside state class
4. Mix `ImageSource.camera` dan `ImageSource.gallery`
5. Show same notification ID multiple times

---

## 🔗 Links & References

### Official Documentation

- [Flutter](https://flutter.dev)
- [image_picker](https://pub.dev/packages/image_picker)
- [camera](https://pub.dev/packages/camera)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [permission_handler](https://pub.dev/packages/permission_handler)

### Useful Commands

```bash
flutter run                    # Run app
flutter run -v                 # Verbose mode
flutter clean                  # Clean build
flutter pub get               # Get dependencies
flutter build apk --release   # Build release APK
flutter devices               # List devices
flutter doctor                # Check setup
```

---

## 📞 Getting Help

If you encounter issues:

1. **Check Logs**

   ```bash
   flutter run -v
   ```

2. **Check Documentation**
   - See `README.md` for full explanation
   - See `FEATURES.md` for feature details
   - See `WIDGET_EXPLANATION.md` for code details

3. **Check Permissions**
   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/Info.plist`

4. **Check Dependencies**
   ```bash
   flutter pub get
   flutter pub outdated
   ```

---

## ✨ Project Status

- ✅ Camera integration
- ✅ Gallery integration
- ✅ Photo display
- ✅ Notifications
- ✅ Android support
- ✅ iOS support
- ✅ Error handling
- ✅ Permission management

---

**Ready to Use!** 🎉

Jalankan `flutter run` untuk mulai testing aplikasi.

---

**Last Updated**: 2026
**Author**: Bintang Yudhistira
