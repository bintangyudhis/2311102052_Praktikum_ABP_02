# 🎯 Fitur Aplikasi - Dokumentasi Lengkap

## Ringkasan Fitur

Aplikasi Flutter ini menyediakan 3 fitur utama:

1. ✅ Ambil Foto dari Kamera
2. ✅ Pilih Foto dari Galeri
3. ✅ Tampilkan Notifikasi Lokal

---

## Fitur 1: Ambil Foto dari Kamera 📷

### Deskripsi

Pengguna dapat membuka kamera perangkat langsung dari aplikasi untuk mengambil foto baru.

### Bagaimana Cara Kerja

```
┌──────────────────────────────────────────────┐
│ 1. User Tap Tombol "Ambil Foto dari Kamera" │
└─────────────────┬──────────────────────────┘
                  │
┌─────────────────┴──────────────────────────┐
│ 2. ImagePicker membuka Camera App         │
└─────────────────┬──────────────────────────┘
                  │
┌─────────────────┴──────────────────────────┐
│ 3. User Ambil Foto dengan Kamera          │
└─────────────────┬──────────────────────────┘
                  │
┌─────────────────┴──────────────────────────┐
│ 4. File Foto Dikembalikan ke App           │
└─────────────────┬──────────────────────────┘
                  │
┌─────────────────┴──────────────────────────┐
│ 5. setState() Update _selectedImage         │
└─────────────────┬──────────────────────────┘
                  │
┌─────────────────┴──────────────────────────┐
│ 6. UI Rebuild - Foto Ditampilkan           │
└─────────────────┬──────────────────────────┘
                  │
┌─────────────────┴──────────────────────────┐
│ 7. Notifikasi "Foto Berhasil Diambil"      │
└──────────────────────────────────────────────┘
```

### Implementasi Kode

```dart
Future<void> _capturePhotoFromCamera() async {
  try {
    // Buka kamera langsung
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,  // ← Penting: gunakan camera
    );

    // Cek apakah user tidak membatalkan
    if (photo != null) {
      // Update state dengan foto baru
      setState(() {
        _selectedImage = File(photo.path);
      });

      // Tampilkan notifikasi sukses
      await _showNotification(
        'Foto Berhasil Diambil',
        'Foto dari kamera telah disimpan dan ditampilkan!',
      );
    }
  } catch (e) {
    // Tampilkan error jika ada masalah
    _showErrorSnackBar('Error: $e');
  }
}
```

### UI Button

```dart
ElevatedButton.icon(
  onPressed: _capturePhotoFromCamera,
  icon: const Icon(Icons.camera_alt),          // Ikon kamera
  label: const Text('Ambil Foto dari Kamera'),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF2563EB),   // Biru
  ),
)
```

### Dependencies Digunakan

- **image_picker**: `ImagePicker().pickImage(source: ImageSource.camera)`
- **permission_handler**: Untuk akses kamera

### Permissions Diperlukan

**Android** (AndroidManifest.xml):

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

**iOS** (Info.plist):

```xml
<key>NSCameraUsageDescription</key>
<string>Aplikasi membutuhkan akses ke kamera untuk mengambil foto</string>

<key>NSMicrophoneUsageDescription</key>
<string>Aplikasi membutuhkan akses ke mikrofon untuk merekam video</string>
```

### Fitur Tambahan

- ✅ Foto ditampilkan langsung setelah diambil
- ✅ Notifikasi otomatis ditampilkan
- ✅ Error handling jika ada masalah

---

## Fitur 2: Pilih Foto dari Galeri 📁

### Deskripsi

Pengguna dapat memilih foto yang sudah ada di galeri perangkat.

### Bagaimana Cara Kerja

```
┌────────────────────────────────────────────┐
│ 1. User Tap Tombol "Pilih Foto dari Galeri"│
└─────────────────┬────────────────────────┘
                  │
┌─────────────────┴────────────────────────┐
│ 2. ImagePicker membuka Gallery App       │
└─────────────────┬────────────────────────┘
                  │
┌─────────────────┴────────────────────────┐
│ 3. User Pilih Foto dari Galeri           │
└─────────────────┬────────────────────────┘
                  │
┌─────────────────┴────────────────────────┐
│ 4. File Foto Dikembalikan ke App         │
└─────────────────┬────────────────────────┘
                  │
┌─────────────────┴────────────────────────┐
│ 5. setState() Update _selectedImage       │
└─────────────────┬────────────────────────┘
                  │
┌─────────────────┴────────────────────────┐
│ 6. UI Rebuild - Foto Ditampilkan         │
└─────────────────┬────────────────────────┘
                  │
┌─────────────────┴────────────────────────┐
│ 7. Notifikasi "Foto Berhasil Dipilih"    │
└────────────────────────────────────────────┘
```

### Implementasi Kode

```dart
Future<void> _selectPhotoFromGallery() async {
  try {
    // Buka galeri
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,  // ← Penting: gunakan gallery
    );

    // Cek apakah user tidak membatalkan
    if (photo != null) {
      // Update state dengan foto baru
      setState(() {
        _selectedImage = File(photo.path);
      });

      // Tampilkan notifikasi sukses
      await _showNotification(
        'Foto Berhasil Dipilih',
        'Foto dari galeri telah dipilih dan ditampilkan!',
      );
    }
  } catch (e) {
    // Tampilkan error jika ada masalah
    _showErrorSnackBar('Error: $e');
  }
}
```

### UI Button

```dart
ElevatedButton.icon(
  onPressed: _selectPhotoFromGallery,
  icon: const Icon(Icons.image),                // Ikon gambar
  label: const Text('Pilih Foto dari Galeri'),
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF7C3AED),   // Ungu
  ),
)
```

### Dependencies Digunakan

- **image_picker**: `ImagePicker().pickImage(source: ImageSource.gallery)`
- **permission_handler**: Untuk akses galeri

### Permissions Diperlukan

**Android** (AndroidManifest.xml):

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

**iOS** (Info.plist):

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Aplikasi membutuhkan akses ke galeri untuk memilih foto</string>

<key>NSPhotoLibraryAddUsageDescription</key>
<string>Aplikasi membutuhkan izin untuk menyimpan foto ke galeri</string>
```

### Fitur Tambahan

- ✅ Foto ditampilkan langsung setelah dipilih
- ✅ Notifikasi otomatis ditampilkan
- ✅ Error handling jika ada masalah

---

## Fitur 3: Tampilkan Notifikasi Lokal 🔔

### Deskripsi

Setelah foto berhasil diambil atau dipilih, aplikasi menampilkan notifikasi lokal kepada pengguna.

### Bagaimana Cara Kerja

```
Foto Berhasil Diambil/Dipilih
           │
           ▼
┌──────────────────────────┐
│ Trigger Notifikasi       │
│ _showNotification()      │
└──────────┬───────────────┘
           │
┌──────────┴─────────────────────────┐
│ Android: Create Notification        │
│ • Channel ID: photo_channel         │
│ • Channel Name: Photo Notifications │
│ • Priority: High                    │
│ • Importance: Max                   │
└──────────┬─────────────────────────┘
           │
┌──────────┴────────────────────────────┐
│ iOS: Create DarwinNotification       │
│ • Default settings                   │
└──────────┬────────────────────────────┘
           │
           ▼
    ┌─────────────────┐
    │ Display          │
    │ Notification     │
    └──────────────────┘
```

### Implementasi Kode

```dart
Future<void> _showNotification(String title, String body) async {
  // Android-specific configuration
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'photo_channel',           // Channel ID unik
        'Photo Notifications',     // Channel name yang terlihat user
        channelDescription: 'Notifications for photo events',
        importance: Importance.max,        // Tingkat penting maksimal
        priority: Priority.high,            // Prioritas tinggi
        showWhen: true,                     // Tampilkan waktu
      );

  // iOS-specific configuration
  const DarwinNotificationDetails iOSPlatformChannelSpecifics =
      DarwinNotificationDetails();

  // Kombinasi konfigurasi untuk semua platform
  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );

  // Tampilkan notifikasi
  await flutterLocalNotificationsPlugin.show(
    0,                            // Notification ID
    title,                        // Judul (contoh: "Foto Berhasil Diambil")
    body,                         // Isi pesan
    platformChannelSpecifics,
    payload: 'item x',            // Data tambahan (opsional)
  );
}
```

### Konfigurasi Awal

Konfigurasi dilakukan di `main()` sebelum aplikasi berjalan:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ← PENTING: Initialize notifications
  await _initializeNotifications();

  cameras = await availableCameras();
  runApp(const MyApp());
}

Future<void> _initializeNotifications() async {
  // Konfigurasi Android
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Konfigurasi iOS
  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  // Kombinasi konfigurasi
  const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  // Initialize plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
```

### Notifikasi yang Ditampilkan

**Saat Ambil Foto dari Kamera:**

```
┌─────────────────────────────────────────┐
│ 📱 Foto Berhasil Diambil                │
│ Foto dari kamera telah disimpan dan     │
│ ditampilkan!                             │
└─────────────────────────────────────────┘
```

**Saat Pilih Foto dari Galeri:**

```
┌─────────────────────────────────────────┐
│ 📱 Foto Berhasil Dipilih                │
│ Foto dari galeri telah dipilih dan      │
│ ditampilkan!                             │
└─────────────────────────────────────────┘
```

### Dependencies Digunakan

- **flutter_local_notifications**: Untuk menampilkan notifikasi lokal

### Konfigurasi Platform

**Android**:

- Channel ID: `photo_channel`
- Channel Name: `Photo Notifications`
- Importance: MAX
- Priority: HIGH
- Icon: Default app icon (`@mipmap/ic_launcher`)

**iOS**:

- Menggunakan DarwinNotificationDetails (standar iOS)
- Notifikasi muncul di notification center iOS

### Fitur Tambahan

- ✅ Notifikasi dengan judul dan deskripsi
- ✅ Platform-specific customization
- ✅ Icon notifikasi menggunakan app icon
- ✅ Timestamp otomatis ditampilkan

---

## Integrasi Ketiga Fitur

### User Journey

```
┌─────────────────────────────────┐
│     Start Aplikasi              │
└──────────────┬──────────────────┘
               │
          ┌────┴─────┐
          │           │
     Camera        Gallery
          │           │
    ┌────┴──┐    ┌──┴────┐
    │        │    │       │
  Open    Take  Open    Pick
 Camera   Photo Gallery  Photo
    │        │    │       │
    └────┬───┘    └───┬───┘
         │            │
         └─────┬──────┘
               │
        ┌──────┴──────────────┐
        │                     │
    Update State        Show Notification
   _selectedImage       "Foto Berhasil..."
        │                     │
        └─────┬───────────────┘
              │
        ┌─────┴──────────┐
        │                │
    Rebuild UI      User Sees
    - Foto tampil   - Foto updated
    - Info ukuran   - Notifikasi
                    - Pesan sukses
```

---

## Troubleshooting per Fitur

### Fitur 1: Kamera tidak membuka

**Penyebab**:

- Emulator tidak mendukung kamera
- Permission camera tidak diberikan
- `ImageSource.camera` salah

**Solusi**:

```dart
// Gunakan device fisik
flutter run -d <device_id>

// Atau periksa permission
await Permission.camera.request();
```

### Fitur 2: Galeri tidak membuka

**Penyebab**:

- Permission galeri tidak diberikan
- `ImageSource.gallery` salah

**Solusi**:

```dart
// Periksa permission
await Permission.photos.request();

// Pastikan menggunakan ImageSource.gallery
final XFile? photo = await _picker.pickImage(
  source: ImageSource.gallery,  // ← Benar
);
```

### Fitur 3: Notifikasi tidak muncul

**Penyebab**:

- Notifikasi tidak diinisialisasi di `main()`
- Channel ID salah
- Device dalam silent mode

**Solusi**:

```dart
// Pastikan initialize di main()
await _initializeNotifications();

// Periksa channel ID di build
const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
  'photo_channel',  // ← Sama dengan saat initialize
  'Photo Notifications',
);
```

---

## 📊 Feature Comparison Table

| Fitur                | Kamera                  | Galeri                  | Notifikasi           |
| -------------------- | ----------------------- | ----------------------- | -------------------- |
| **Button Color**     | Biru (#2563EB)          | Ungu (#7C3AED)          | -                    |
| **Icon**             | camera_alt              | image                   | 📱                   |
| **Trigger**          | User tap                | User tap                | Auto setelah foto    |
| **Source**           | ImageSource.camera      | ImageSource.gallery     | Notification channel |
| **Notification**     | "Foto Berhasil Diambil" | "Foto Berhasil Dipilih" | Custom message       |
| **Platform Support** | Android + iOS           | Android + iOS           | Android + iOS        |

---

## Kesimpulan

Ketiga fitur bekerja bersama untuk memberikan pengalaman pengguna yang lengkap:

1. **Kamera** - Ambil foto baru
2. **Galeri** - Gunakan foto yang sudah ada
3. **Notifikasi** - Konfirmasi tindakan berhasil

Semua fitur dirancang dengan error handling yang baik dan user experience yang optimal.
