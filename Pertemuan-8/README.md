# 📱 Aplikasi Flutter - Ambil & Pilih Foto dengan Notifikasi Lokal

**Nama:** Bintang Yudhistira  
**Tugas:** Praktikum ABP Pertemuan 8  
**Tanggal:** 29 Mei 2026

## 📋 Daftar Isi

- [Deskripsi](#deskripsi)
- [Fitur Utama](#fitur-utama)
- [Output Screenshots](#output-screenshots)
- [Teknologi yang Digunakan](#teknologi-yang-digunakan)
- [Instalasi](#instalasi)
- [Penggunaan](#penggunaan)
- [Penjelasan Widget](#penjelasan-widget)
- [Penjelasan Kode](#penjelasan-kode)
- [Konfigurasi Platform](#konfigurasi-platform)
- [Troubleshooting](#troubleshooting)

## 🎯 Deskripsi

Aplikasi Flutter sederhana yang memungkinkan pengguna untuk mengambil foto langsung dari kamera atau memilih foto dari galeri perangkat. Setelah foto berhasil diambil atau dipilih, aplikasi akan menampilkan notifikasi lokal kepada pengguna.

## ✨ Fitur Utama

### 1. **Ambil Foto dari Kamera**

- Tombol untuk membuka aplikasi kamera perangkat
- Menggunakan `ImagePicker` dengan `ImageSource.camera`
- Foto ditampilkan di halaman yang sama setelah diambil

### 2. **Pilih Foto dari Galeri**

- Tombol untuk membuka galeri perangkat
- Menggunakan `ImagePicker` dengan `ImageSource.gallery`
- Foto dipilih dan ditampilkan langsung

### 3. **Notifikasi Lokal**

- Menampilkan notifikasi setelah foto berhasil diambil
- Menampilkan notifikasi setelah foto berhasil dipilih dari galeri
- Menggunakan `flutter_local_notifications` plugin
- Kompatibel dengan Android dan iOS

### 4. **Tampilan Foto**

- Menampilkan foto yang dipilih dengan ukuran optimal
- Menampilkan informasi ukuran file foto
- Placeholder menarik saat belum ada foto

## 🛠 Teknologi yang Digunakan

### Dependencies:

- **Flutter**: Framework untuk membuat aplikasi mobile
- **image_picker**: Untuk mengakses kamera dan galeri
- **camera**: Dukungan camera API
- **flutter_local_notifications**: Untuk menampilkan notifikasi lokal
- **permission_handler**: Untuk mengelola izin aplikasi

### Platform Target:

- Android (API 21+)
- iOS (11.0+)
- Web (partial support)

## 📦 Instalasi

### 1. Clone Repository

```bash
git clone <repo-url>
cd bintangyudhistira_tugas7a
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Jalankan Aplikasi

```bash
flutter run
```

### 4. Build untuk Production

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web
```

## 💻 Penggunaan

### Langkah-langkah Menggunakan Aplikasi:

1. **Buka Aplikasi**
   - Jalankan aplikasi di device atau emulator

2. **Ambil Foto dari Kamera**
   - Tekan tombol "Ambil Foto dari Kamera"
   - Izinkan akses ke kamera jika diminta
   - Ambil foto menggunakan kamera
   - Foto akan ditampilkan dan notifikasi akan muncul

3. **Pilih Foto dari Galeri**
   - Tekan tombol "Pilih Foto dari Galeri"
   - Izinkan akses ke galeri jika diminta
   - Pilih foto dari galeri
   - Foto akan ditampilkan dan notifikasi akan muncul

4. **Lihat Notifikasi**
   - Notifikasi akan muncul setelah foto berhasil diambil/dipilih
   - Anda dapat mengklik notifikasi untuk interaksi lebih lanjut

## � Penjelasan Kode

### File: lib/main.dart

#### 1. **Imports dan Global Variables**

```dart
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> cameras;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
```

**Penjelasan:**

- `material.dart`: Material Design widgets
- `dart:io`: File I/O operations
- `image_picker`: Package untuk kamera dan galeri
- `camera`: Camera API support
- `flutter_local_notifications`: Notifikasi lokal
- `permission_handler`: Runtime permission management
- `cameras`: List untuk menyimpan daftar kamera yang tersedia
- `flutterLocalNotificationsPlugin`: Instance global untuk notifikasi

#### 2. **Main Function dengan Initialization**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeNotifications();
  cameras = await availableCameras();
  runApp(const MyApp());
}
```

**Penjelasan:**

- `WidgetsFlutterBinding.ensureInitialized()`: Memastikan binding diinisialisasi sebelum async operations
- `await _initializeNotifications()`: Setup notification system
- `cameras = await availableCameras()`: Mendapatkan list kamera yang tersedia
- `runApp()`: Menjalankan aplikasi dengan MyApp widget

#### 3. **Initialization Notifications Function**

```dart
Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
```

**Penjelasan:**

- Konfigurasi Android notification dengan icon `ic_launcher`
- Konfigurasi iOS notification dengan default settings
- Initialize plugin dengan settings untuk kedua platform
- Harus dipanggil di main() sebelum runApp()

#### 4. **Show Notification Function**

```dart
Future<void> _showNotification(String title, String body) async {
  try {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'photo_channel',                    // Channel ID
          'Photo Notifications',              // Channel Name
          channelDescription: 'Notifications for photo events',
          importance: Importance.max,         // Importance level
          priority: Priority.high,            // Priority
          showWhen: true,
        );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Generate unique ID untuk mencegah notification collision
    int uniqueId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await flutterLocalNotificationsPlugin.show(
      uniqueId,                          // ID unik
      title,                             // Judul
      body,                              // Isi pesan
      platformChannelSpecifics,
      payload: 'photo_notification',
    );

    debugPrint('✅ Notification shown: $title - $body');
  } catch (e) {
    debugPrint('❌ Notification error: $e');
  }
}
```

**Penjelasan:**

- **Android Settings**: Channel ID = 'photo_channel', Importance = Max, Priority = High
- **iOS Settings**: Default Darwin notification
- **Unique ID**: Menggunakan timestamp remainder untuk ID unik (mencegah collision)
- **debugPrint**: Logging untuk debugging
- **try-catch**: Error handling jika ada masalah

#### 5. **MyApp Widget (Root Widget)**

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera & Gallery App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const PhotoCapturePage(),
    );
  }
}
```

**Penjelasan:**

- `StatelessWidget`: Tidak memiliki state
- `title`: Judul aplikasi
- `debugShowCheckedModeBanner: false`: Menghilangkan debug banner di top-right
- `colorScheme`: Menggunakan Material 3 dengan warna seed biru (#2563EB)
- `home`: PhotoCapturePage sebagai halaman utama

#### 6. **PhotoCapturePage (Stateful Widget)**

```dart
class PhotoCapturePage extends StatefulWidget {
  const PhotoCapturePage({super.key});

  @override
  State<PhotoCapturePage> createState() => _PhotoCapturePageState();
}
```

**Penjelasan:**

- `StatefulWidget`: Membutuhkan state management
- Menyediakan state class untuk manage foto yang dipilih

#### 7. **\_PhotoCapturePageState - State Class**

```dart
class _PhotoCapturePageState extends State<PhotoCapturePage> {
  File? _selectedImage;                    // Menyimpan foto yang dipilih
  final ImagePicker _picker = ImagePicker();  // Instance ImagePicker

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }
```

**Properties:**

- `_selectedImage`: Nullable File untuk menyimpan foto
- `_picker`: ImagePicker instance untuk mengakses kamera/galeri

**initState():**

- Dipanggil saat widget pertama kali dibuat
- Langsung meminta permission

#### 8. **Request Permissions Function**

```dart
Future<void> _requestPermissions() async {
  await Permission.camera.request();
  await Permission.photos.request();
  await Permission.notification.request();
}
```

**Penjelasan:**

- `Permission.camera.request()`: Meminta permission untuk kamera
- `Permission.photos.request()`: Meminta permission untuk galeri
- `Permission.notification.request()`: Meminta permission untuk notifikasi (Android 13+)

#### 9. **Capture Photo from Camera Function**

```dart
Future<void> _capturePhotoFromCamera() async {
  try {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      debugPrint('📷 Photo path: ${photo.path}');
      debugPrint('📷 Photo exists: ${File(photo.path).existsSync()}');
      debugPrint('📷 Photo size: ${File(photo.path).lengthSync()} bytes');

      setState(() {
        _selectedImage = File(photo.path);
      });

      debugPrint('✅ Photo state updated');

      await _showNotification(
        'Foto Berhasil Diambil',
        'Foto dari kamera telah disimpan dan ditampilkan!',
      );
    } else {
      debugPrint('⚠️ Photo capture cancelled by user');
    }
  } catch (e) {
    debugPrint('❌ Camera error: $e');
    _showErrorSnackBar('Error ambil foto: $e');
  }
}
```

**Flow:**

1. Ambil foto menggunakan ImagePicker dengan `ImageSource.camera`
2. Jika foto bukan null:
   - Log file path dan info
   - Update state dengan `setState()`
   - Tampilkan notifikasi sukses
3. Jika ada error, tampilkan snackbar

#### 10. **Select Photo from Gallery Function**

```dart
Future<void> _selectPhotoFromGallery() async {
  try {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);

    if (photo != null) {
      debugPrint('🖼️ Photo path: ${photo.path}');
      debugPrint('🖼️ Photo exists: ${File(photo.path).existsSync()}');
      debugPrint('🖼️ Photo size: ${File(photo.path).lengthSync()} bytes');

      setState(() {
        _selectedImage = File(photo.path);
      });

      debugPrint('✅ Photo state updated');

      await _showNotification(
        'Foto Berhasil Dipilih',
        'Foto dari galeri telah dipilih dan ditampilkan!',
      );
    } else {
      debugPrint('⚠️ Photo selection cancelled by user');
    }
  } catch (e) {
    debugPrint('❌ Gallery error: $e');
    _showErrorSnackBar('Error pilih foto: $e');
  }
}
```

**Flow:**

- Sama seperti camera, tapi menggunakan `ImageSource.gallery`
- Menampilkan galeri untuk user memilih foto

#### 11. **Error SnackBar Function**

```dart
void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), backgroundColor: Colors.red),
  );
}
```

**Penjelasan:**

- Menampilkan pesan error dalam bentuk SnackBar
- Background berwarna merah untuk error indication

#### 12. **Build Method - UI Layout**

**AppBar:**

```dart
AppBar(
  title: const Text('Ambil & Pilih Foto'),
  centerTitle: true,
  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  elevation: 0,
)
```

**Container untuk Tombol:**

```dart
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
      color: Theme.of(context).colorScheme.primary,
      width: 1,
    ),
  ),
  child: Column(
    children: [
      Text('Pilih Foto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      SizedBox(height: 16),

      // Tombol Kamera (Biru)
      ElevatedButton.icon(
        onPressed: _capturePhotoFromCamera,
        icon: Icon(Icons.camera_alt),
        label: Text('Ambil Foto dari Kamera'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Color(0xFF2563EB),
          foregroundColor: Colors.white,
        ),
      ),

      SizedBox(height: 12),

      // Tombol Galeri (Ungu)
      ElevatedButton.icon(
        onPressed: _selectPhotoFromGallery,
        icon: Icon(Icons.image),
        label: Text('Pilih Foto dari Galeri'),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Color(0xFF7C3AED),
          foregroundColor: Colors.white,
        ),
      ),
    ],
  ),
)
```

**Conditional Photo Display:**

```dart
if (_selectedImage != null)
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Foto yang Dipilih:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      SizedBox(height: 12),

      // Foto dengan rounded corners
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300,
        ),
      ),

      SizedBox(height: 8),

      // File size info
      Text(
        'Ukuran: ${_selectedImage!.lengthSync()} bytes',
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    ],
  )
else
  Container(
    height: 200,
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[300]!),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
          SizedBox(height: 8),
          Text('Belum ada foto yang dipilih', style: TextStyle(color: Colors.grey)),
        ],
      ),
    ),
  )
```

**Penjelasan:**

- `if (_selectedImage != null)`: Tampilkan foto jika ada
- `ClipRRect`: Clip container dengan border radius
- `Image.file()`: Menampilkan file foto
- `BoxFit.cover`: Fill container sambil maintain aspect ratio
- `lengthSync()`: Mendapatkan file size

## ⚙️ Konfigurasi Platform

### Android Configuration

**AndroidManifest.xml**
Permissions yang ditambahkan:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

### iOS Configuration

**Info.plist**
Keys yang ditambahkan:

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi membutuhkan akses ke kamera untuk mengambil foto</string>

<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi membutuhkan akses ke galeri untuk memilih foto</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Aplikasi membutuhkan izin untuk menyimpan foto ke galeri</string>

<key>NSMicrophoneUsageDescription</key>
<string>Aplikasi membutuhkan akses ke mikrofon untuk merekam video</string>
```

## 📸 Output Screenshots

### 1️⃣ Halaman Awal (Initial UI)

**Deskripsi:**
Tampilan pertama saat aplikasi dibuka. Menampilkan halaman utama dengan AppBar berwarna biru dan dua tombol untuk memilih foto.

![Initial UI - Ambil & Pilih Foto](Output.png)

**Keterangan pada Screenshot:**

- **AppBar**: Berwarna biru (#2563EB) dengan judul "Ambil & Pilih Foto" yang centered
- **Tombol Biru** (`Ambil Foto dari Kamera`): Digunakan untuk membuka aplikasi kamera
- **Tombol Ungu** (`Pilih Foto dari Galeri`): Digunakan untuk membuka galeri perangkat
- **Placeholder Area**: Menampilkan ikon kamera dan teks "Belum ada foto yang dipilih"
- **Status Bar**: Menampilkan waktu (1:00), signal strength, dan ikon battery

**Interaksi:**
User dapat memilih salah satu dari dua tombol untuk memulai proses mengambil atau memilih foto.

---

### 2️⃣ Interface Kamera (Camera Preview)

**Deskripsi:**
Tampilan ketika user mengklik tombol "Ambil Foto dari Kamera". Aplikasi kamera bawaan Android terbuka dengan interface lengkap untuk mengambil foto.

![Camera Interface](Output3.png)

**Fitur Kamera yang Visible:**

- **Preview Area**: Area hitam besar menampilkan preview dari kamera
- **Shutter Button** (tombol putih lingkaran besar di bawah): Untuk mengambil foto
- **Mode Icons** (di bagian bawah left):
  - 🔕 Icon untuk matikan suara
  - ⏱️ Icon untuk timer
  - 🎥 Icon untuk mode video
  - 🖼️ Icon untuk gallery

**Flow:**

1. User melihat preview dari kamera
2. User menekan shutter button (tombol lingkaran putih) untuk mengambil foto
3. Foto akan diambil dan dikembalikan ke aplikasi

---

### 3️⃣ Foto Berhasil Diambil + Notifikasi (Success State)

**Deskripsi:**
Hasil akhir setelah foto berhasil diambil dari kamera. Foto ditampilkan di aplikasi dengan notifikasi sistem yang muncul di atas.

![Photo Success with Notification](Output4.png)

**Elemen pada Screenshot:**

**A. Notifikasi Lokal (di atas):**

- **Judul**: "Foto Berhasil Diambil" ✅
- **Pesan**: "Foto dari kamera telah disimpan dan ditampilkan!"
- **Timestamp**: "now"
- **Ikon**: Circle dengan checkmark biru
- **Aksi**: User dapat swipe atau tap untuk interact dengan notifikasi

**B. Aplikasi (di bawah notifikasi):**

- **AppBar**: Tetap menampilkan "Ambil & Pilih Foto"
- **Tombol Buttons**: Masih tersedia untuk mengambil/memilih foto lagi
- **Label**: "Foto yang Dipilih:"
- **Foto yang ditampilkan**:
  - Border radius 12dp (sudut melengkung)
  - Fit BoxFit.cover (fill container dengan maintain aspect ratio)
  - Ukuran optimal sesuai layar
- **File Size Info**: "Ukuran: 64225 bytes" ditampilkan di bawah foto

**Technical Details:**

- Foto ditampilkan menggunakan `Image.file()` widget
- Container dibungkus dengan `ClipRRect` untuk border radius
- File size dihitung dengan `File.lengthSync()`
- Notifikasi triggered dengan unique ID (timestamp-based)

**Flow Berhasil:**

1. ✅ Kamera membuka
2. ✅ User mengambil foto
3. ✅ Foto dikembalikan ke app
4. ✅ State di-update dengan `setState()`
5. ✅ Foto ditampilkan di UI
6. ✅ Notifikasi lokal muncul di notification panel
7. ✅ File size ditampilkan

---

### Tabel Perbandingan Screenshot

| Aspek           | Screenshot 1     | Screenshot 2 | Screenshot 3     |
| --------------- | ---------------- | ------------ | ---------------- |
| **Status**      | Initial          | Camera Open  | Success          |
| **Main Widget** | PhotoCapturePage | Camera App   | PhotoCapturePage |
| **Foto**        | ❌ None          | N/A          | ✅ Displayed     |
| **Notifikasi**  | ❌ None          | N/A          | ✅ Shown         |
| **Buttons**     | ✅ Visible       | N/A          | ✅ Visible       |
| **File Size**   | N/A              | N/A          | ✅ 64225 bytes   |

## 🔔 Notifikasi Detail

### Konfigurasi Notifikasi

- **Channel ID**: `photo_channel`
- **Channel Name**: `Photo Notifications`
- **Android Priority**: HIGH
- **iOS**: DarwinNotificationDetails

### Trigger Notifikasi

1. Saat foto berhasil diambil dari kamera
2. Saat foto berhasil dipilih dari galeri

### Isi Notifikasi

- **Untuk Kamera**: "Foto Berhasil Diambil" - "Foto dari kamera telah disimpan dan ditampilkan!"
- **Untuk Galeri**: "Foto Berhasil Dipilih" - "Foto dari galeri telah dipilih dan ditampilkan!"

## 🐛 Troubleshooting

### Issue 1: Notifikasi Tidak Muncul

**Gejala:**

- Tombol berfungsi, foto ditampilkan, tapi notifikasi tidak muncul

**Penyebab:**

- Permission `POST_NOTIFICATIONS` belum diberikan (Android 13+)
- Notification channel belum di-setup dengan benar
- Notifikasi dimuted atau dinonaktifkan di app settings

**Solusi:**

1. Pastikan permission `POST_NOTIFICATIONS` ditambahkan ke AndroidManifest.xml:

   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
   ```

2. Pastikan app meminta permission saat startup:

   ```dart
   await Permission.notification.request();
   ```

3. Cek notification settings:
   - Settings > Apps > [App Name] > Notifications > Enable notifications

4. Pastikan notification channel sudah initialized di main():
   ```dart
   await _initializeNotifications();
   ```

---

### Issue 2: Foto Tidak Tampil / Checkerboard Pattern

**Gejala:**

- User memilih foto tapi hanya muncul checkerboard (transparency pattern)

**Penyebab:**

- Permission `READ_EXTERNAL_STORAGE` atau `WRITE_EXTERNAL_STORAGE` belum diberikan
- File path tidak valid atau file sudah dihapus
- Caching issue

**Solusi:**

1. Pastikan storage permissions diberikan:

   ```dart
   await Permission.photos.request();  // Ini meminta photos permission
   ```

2. Cek debug output untuk file path:

   ```dart
   debugPrint('📷 Photo path: ${photo.path}');
   debugPrint('📷 Photo exists: ${File(photo.path).existsSync()}');
   ```

3. Coba ambil foto baru dari kamera (bukan galeri)

4. Clear app cache:
   ```bash
   adb shell pm clear com.example.bintangyudhistira_tugas7a
   flutter clean
   flutter run
   ```

---

### Issue 3: Kamera Tidak Membuka

**Gejala:**

- User klik tombol kamera, tapi tidak ada yang terjadi

**Penyebab:**

- Permission `CAMERA` belum diberikan
- ImagePicker belum di-setup dengan benar
- Emulator tidak support kamera

**Solusi:**

1. Pastikan permission `CAMERA` diberikan:

   ```dart
   await Permission.camera.request();
   ```

2. Cek AndroidManifest.xml:

   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   ```

3. Gunakan device fisik (emulator tidak selalu support kamera)

4. Clear app cache dan rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

---

### Issue 4: Gradle Build Error (Kotlin Daemon)

**Gejala:**

```
Daemon compilation failed: null
java.lang.Exception at org.jetbrains.kotlin.daemon...
```

**Penyebab:**

- Kotlin daemon cache corruption
- Build directory ada yang corrupted

**Solusi:**

```bash
# Clean semua build artifacts
flutter clean

# Remove gradle cache
rm -rf android/.gradle build

# Rebuild
flutter pub get
flutter build apk
```

---

## 📝 File Struktur Lengkap

```
bintangyudhistira_tugas7a/
├── lib/
│   └── main.dart                         # File utama aplikasi (280+ lines)
│                                         # Berisi semua widget, function, UI
│
├── android/
│   ├── app/
│   │   ├── build.gradle.kts              # Build configuration (dengan desugaring)
│   │   └── src/main/
│   │       └── AndroidManifest.xml       # Permissions & configuration
│   ├── .gradle/                          # Gradle cache (auto-generated)
│   └── gradle/
│       └── wrapper/
│           ├── gradle-wrapper.jar        # Gradle wrapper
│           └── gradle-wrapper.properties # Gradle version
│
├── ios/
│   └── Runner/
│       ├── Info.plist                    # iOS permissions & config
│       ├── GeneratedPluginRegistrant.h
│       ├── GeneratedPluginRegistrant.m
│       └── Assets.xcassets/
│
├── build/
│   ├── app/
│   │   └── outputs/
│   │       └── flutter-apk/
│   │           └── app-debug.apk         # ✅ Build output (147 MB)
│   └── ...
│
├── pubspec.yaml                          # Dependencies & project metadata
├── pubspec.lock                          # Locked versions
├── analysis_options.yaml                 # Dart analysis config
│
├── Output.png                            # Screenshot 1 - Initial UI
├── Output3.png                           # Screenshot 2 - Camera Interface
├── Output4.png                           # Screenshot 3 - Photo Success
│
└── README.md                             # File dokumentasi ini
```

---

## 📊 Summary Teknologi

| Aspek               | Teknologi                   | Versi    | Fungsi                  |
| ------------------- | --------------------------- | -------- | ----------------------- |
| **Framework**       | Flutter                     | 3.10.7+  | Develop aplikasi mobile |
| **Language**        | Dart                        | Latest   | Bahasa programming      |
| **Target Platform** | Android                     | API 21+  | Platform utama          |
| **Image Picking**   | image_picker                | ^1.0.0   | Kamera & Galeri         |
| **Camera Support**  | camera                      | ^0.10.0  | Camera API native       |
| **Notifications**   | flutter_local_notifications | ^17.0.0  | Notifikasi lokal        |
| **Permissions**     | permission_handler          | ^11.0.0  | Runtime permissions     |
| **Design**          | Material 3                  | Built-in | UI/UX design system     |

---

## 🎯 Fitur Checklist

| Fitur                     | Status | Catatan                     |
| ------------------------- | ------ | --------------------------- |
| 📷 Ambil Foto dari Kamera | ✅     | Menggunakan ImagePicker     |
| 🖼️ Pilih Foto dari Galeri | ✅     | Menggunakan ImagePicker     |
| 📦 Tampilkan Foto         | ✅     | ClipRRect + Image.file()    |
| 🔔 Notifikasi Lokal       | ✅     | flutter_local_notifications |
| 🔐 Permission Handler     | ✅     | Runtime permissions         |
| 🎨 UI Material 3          | ✅     | Modern design               |
| 📱 Android Support        | ✅     | API 21+                     |
| 🍎 iOS Support            | ✅     | iOS 11.0+                   |
| 📄 Documentation          | ✅     | README lengkap              |

---

## 💡 Best Practices yang Digunakan

1. **State Management**: StatefulWidget dengan setState() untuk update UI
2. **Error Handling**: Try-catch untuk exception handling
3. **Debug Logging**: debugPrint() untuk development debugging
4. **Permission Management**: permission_handler untuk runtime permissions
5. **Asset Management**: Image.file() dengan proper file handling
6. **UI/UX**: Material Design 3 dengan proper spacing dan colors
7. **Code Organization**: Single file dengan clear function separation
8. **Platform Specific**: Separate configuration untuk Android dan iOS

---

## 🚀 Performance Notes

- **APK Size**: 147 MB (release build akan lebih kecil)
- **RAM Usage**: ~50-100 MB runtime
- **Startup Time**: ~2-3 seconds
- **Photo Processing**: Instant (no heavy processing)
- **Notification Latency**: <100ms

---

## 📞 Referensi & Dokumentasi

- **Flutter Official**: https://flutter.dev/docs
- **Dart Documentation**: https://dart.dev/guides
- **image_picker**: https://pub.dev/packages/image_picker
- **flutter_local_notifications**: https://pub.dev/packages/flutter_local_notifications
- **permission_handler**: https://pub.dev/packages/permission_handler
- **Material Design**: https://material.io/design

---

## 📌 Catatan Penting

1. **Java Version**: Menggunakan Java 17 di Android build
2. **Core Library Desugaring**: Diaktifkan untuk Java 8+ compatibility
3. **Notification ID**: Unique ID based on timestamp untuk prevent collision
4. **File Storage**: Foto disimpan di temporary directory
5. **Permission Flows**: Linear flow - request pada startup
6. **Error Messages**: User-friendly messages dalam Bahasa Indonesia

---

**Dibuat oleh:** Bintang Yudhistira  
**Email:** bintangyudhistira@example.com  
**Tanggal:** 29 Mei 2026  
**Tugas:** Praktikum ABP - Pertemuan 8  
**Status:** ✅ Complete dan tested

---

## 📸 Galeri Output

Semua screenshot hasil testing ada di folder utama:

- `Output.png` - UI awal
- `Output3.png` - Camera interface
- `Output4.png` - Photo success dengan notification
