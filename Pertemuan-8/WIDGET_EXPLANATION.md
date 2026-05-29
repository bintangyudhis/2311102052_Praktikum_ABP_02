# 📱 Penjelasan Detail Setiap Widget

## Daftar Isi

1. [Root Widget (MyApp)](#root-widget-myapp)
2. [Page Widget (PhotoCapturePage)](#page-widget-photocapturepage)
3. [State Management (\_PhotoCapturePageState)](#state-management-_photocapturepagestate)
4. [UI Components](#ui-components)
5. [Notification System](#notification-system)

---

## Root Widget (MyApp)

### 📌 MyApp (StatelessWidget)

**Fungsi**: Adalah widget root dari aplikasi yang mengatur konfigurasi global.

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

**Penjelasan Properti**:
| Properti | Fungsi |
|----------|--------|
| `title` | Judul aplikasi yang ditampilkan di task manager |
| `debugShowCheckedModeBanner` | Menghilangkan banner "DEBUG" di pojok kanan atas |
| `colorScheme` | Mengatur palet warna aplikasi berdasarkan seed color biru (#2563EB) |
| `useMaterial3` | Menggunakan Material Design 3 untuk UI modern |
| `home` | Widget halaman utama yang ditampilkan saat aplikasi dimulai |

---

## Page Widget (PhotoCapturePage)

### 📌 PhotoCapturePage (StatefulWidget)

**Fungsi**: Halaman utama aplikasi yang menampilkan UI untuk mengambil dan memilih foto.

```dart
class PhotoCapturePage extends StatefulWidget {
  const PhotoCapturePage({super.key});

  @override
  State<PhotoCapturePage> createState() => _PhotoCapturePageState();
}
```

**Alasan StatefulWidget**:

- Perlu menyimpan state foto yang dipilih (`_selectedImage`)
- State berubah saat pengguna mengambil atau memilih foto
- UI perlu di-rebuild saat state berubah

**Hubungan dengan State Class**:

- `PhotoCapturePage` adalah widget class (immutable)
- `_PhotoCapturePageState` adalah state class yang mengelola data dan UI

---

## State Management (\_PhotoCapturePageState)

### 📌 Properties (Data yang Disimpan)

```dart
class _PhotoCapturePageState extends State<PhotoCapturePage> {
  File? _selectedImage;                    // Menyimpan foto yang dipilih
  final ImagePicker _picker = ImagePicker(); // Instance untuk picking foto
}
```

| Property         | Tipe          | Fungsi                                                          |
| ---------------- | ------------- | --------------------------------------------------------------- |
| `_selectedImage` | `File?`       | Menyimpan path file foto yang dipilih. Null jika belum ada foto |
| `_picker`        | `ImagePicker` | Object untuk mengakses kamera dan galeri device                 |

---

### 📌 initState() - Inisialisasi State

```dart
@override
void initState() {
  super.initState();
  _requestPermissions();
}
```

**Fungsi**: Dipanggil sekali saat widget pertama kali dibuat.

**Yang Dilakukan**:

- Memanggil `_requestPermissions()` untuk meminta izin kamera dan galeri
- Memastikan aplikasi memiliki izin yang diperlukan sebelum pengguna menggunakan fitur

---

### 📌 \_requestPermissions() - Meminta Izin

```dart
Future<void> _requestPermissions() async {
  await Permission.camera.request();      // Minta izin kamera
  await Permission.photos.request();      // Minta izin galeri/photos
}
```

**Fungsi**: Menampilkan dialog izin kepada pengguna.

**Proses**:

1. `Permission.camera.request()` - Meminta akses kamera
2. `Permission.photos.request()` - Meminta akses galeri foto
3. Dialog sistem akan ditampilkan kepada pengguna
4. User dapat approve atau reject

**Alasan `async/await`**:

- Meminta izin adalah operasi asynchronous
- Aplikasi harus menunggu respons user

---

### 📌 \_capturePhotoFromCamera() - Ambil Foto dari Kamera

```dart
Future<void> _capturePhotoFromCamera() async {
  try {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,  // Gunakan kamera, bukan galeri
    );

    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);  // Simpan path foto
      });

      await _showNotification(
        'Foto Berhasil Diambil',
        'Foto dari kamera telah disimpan dan ditampilkan!',
      );
    }
  } catch (e) {
    _showErrorSnackBar('Error: $e');
  }
}
```

**Alur Eksekusi**:

```
┌─────────────────────────────────┐
│ 1. Buka Kamera                  │
└──────────────┬──────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│ 2. User Ambil Foto              │
└──────────────┬───────────────────┘
               │
               ▼
┌──────────────────────────────────┐
│ 3. Check: Apakah ada foto?       │
└──────────┬───────────────┬───────┘
           │               │
         YES              NO
           │               │
           ▼               ▼
   ┌──────────────┐   └─ Return
   │ 4. Save File │      (Cancel)
   └──────┬───────┘
          │
          ▼
   ┌──────────────────┐
   │ 5. setState()    │
   │ Update UI        │
   └──────┬───────────┘
          │
          ▼
   ┌──────────────────┐
   │ 6. Show          │
   │ Notification     │
   └──────────────────┘
```

**Detail Masing-masing Langkah**:

1. **Buka Kamera**: `_picker.pickImage(source: ImageSource.camera)` membuka app kamera
2. **User Ambil Foto**: User dapat mengambil foto dengan kamera device
3. **Cek Foto**: `if (photo != null)` - Memastikan foto berhasil diambil (tidak di-cancel)
4. **Simpan File**: `File(photo.path)` mengkonversi XFile ke File object
5. **Update UI**: `setState()` memberi tahu Flutter bahwa state berubah, rebuild UI
6. **Notifikasi**: Tampilkan notifikasi sukses kepada user

**Error Handling**:

```dart
catch (e) {
  _showErrorSnackBar('Error: $e');  // Tampilkan error jika ada exception
}
```

---

### 📌 \_selectPhotoFromGallery() - Pilih dari Galeri

```dart
Future<void> _selectPhotoFromGallery() async {
  try {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,  // Gunakan galeri, bukan kamera
    );

    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });

      await _showNotification(
        'Foto Berhasil Dipilih',
        'Foto dari galeri telah dipilih dan ditampilkan!',
      );
    }
  } catch (e) {
    _showErrorSnackBar('Error: $e');
  }
}
```

**Perbedaan dengan Camera**:

- `source: ImageSource.gallery` membuka galeri device
- Bukan membuka kamera aplikasi
- User memilih foto dari galeri yang sudah ada

**Kemiripan**:

- Sama-sama menggunakan `ImagePicker`
- Sama-sama update state dengan `setState()`
- Sama-sama menampilkan notifikasi

---

### 📌 \_showErrorSnackBar() - Tampilkan Error

```dart
void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}
```

**Fungsi**: Menampilkan pesan error di bawah layar.

**Komponen**:

- `ScaffoldMessenger.of(context)` - Akses ScaffoldMessenger untuk menampilkan SnackBar
- `SnackBar` - Widget untuk menampilkan notifikasi sementara
- `backgroundColor: Colors.red` - Warna merah untuk menunjukkan error

**Kapan Digunakan**:

- Saat ada exception di `_capturePhotoFromCamera()`
- Saat ada exception di `_selectPhotoFromGallery()`

---

## UI Components

### 📌 build() - Membangun Interface

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(...),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(...)
      ),
    ),
  );
}
```

**Struktur Dasar**:

```
Scaffold
├── AppBar
│   ├── title: Text('Ambil & Pilih Foto')
│   └── backgroundColor
└── body: SingleChildScrollView
    └── Padding
        └── Column
            ├── Container (Tombol)
            ├── SizedBox
            └── Image atau Placeholder
```

---

### 📌 AppBar - Header

```dart
appBar: AppBar(
  title: const Text('Ambil & Pilih Foto'),
  centerTitle: true,
  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
  elevation: 0,
),
```

| Properti          | Fungsi                                                    |
| ----------------- | --------------------------------------------------------- |
| `title`           | Teks judul di header                                      |
| `centerTitle`     | Teks judul diletakkan di tengah, bukan kiri               |
| `backgroundColor` | Warna background menggunakan primary container dari theme |
| `elevation`       | Shadow di bawah AppBar (0 = tanpa shadow)                 |

---

### 📌 Tombol - Camera Button

```dart
ElevatedButton.icon(
  onPressed: _capturePhotoFromCamera,
  icon: const Icon(Icons.camera_alt),
  label: const Text('Ambil Foto dari Kamera'),
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 12),
    backgroundColor: const Color(0xFF2563EB),
    foregroundColor: Colors.white,
  ),
),
```

**Analisis**:

| Bagian                | Fungsi                                |
| --------------------- | ------------------------------------- |
| `ElevatedButton.icon` | Tombol dengan ikon dan teks           |
| `onPressed`           | Callback function saat tombol ditekan |
| `icon`                | Ikon kamera (Icons.camera_alt)        |
| `label`               | Teks tombol                           |
| `backgroundColor`     | Warna tombol (biru #2563EB)           |
| `foregroundColor`     | Warna teks dan ikon (putih)           |

**Tipe Button**:

- `ElevatedButton` - Tombol dengan elevation (3D effect)
- Ada juga `TextButton`, `OutlinedButton` sebagai alternatif

---

### 📌 Tombol - Gallery Button

```dart
ElevatedButton.icon(
  onPressed: _selectPhotoFromGallery,
  icon: const Icon(Icons.image),
  label: const Text('Pilih Foto dari Galeri'),
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 12),
    backgroundColor: const Color(0xFF7C3AED),  // Ungu
    foregroundColor: Colors.white,
  ),
),
```

**Perbedaan**:

- Callback: `_selectPhotoFromGallery` (bukan camera)
- Icon: `Icons.image` (bukan camera)
- Label: "Pilih Foto dari Galeri"
- BackgroundColor: Ungu (#7C3AED) untuk membedakan

---

### 📌 Foto Display - Jika Ada Foto

```dart
if (_selectedImage != null)
  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Foto yang Dipilih:', style: TextStyle(fontSize: 16)),
      const SizedBox(height: 12),
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          height: 300,
          width: double.infinity,
        ),
      ),
      const SizedBox(height: 12),
      Text('Ukuran: ${_selectedImage!.lengthSync()} bytes'),
    ],
  )
```

**Penjelasan**:

| Komponen                      | Fungsi                                    |
| ----------------------------- | ----------------------------------------- |
| `if (_selectedImage != null)` | Hanya tampilkan jika ada foto             |
| `Column`                      | Arrange widget secara vertikal            |
| `ClipRRect`                   | Membuat sudut rounded pada image          |
| `Image.file`                  | Widget untuk menampilkan gambar dari file |
| `fit: BoxFit.cover`           | Gambar fill container, mungkin ter-crop   |
| `height: 300`                 | Tinggi gambar 300 pixels                  |
| `width: double.infinity`      | Lebar gambar penuh container              |
| `lengthSync()`                | Mendapatkan ukuran file dalam bytes       |

---

### 📌 Placeholder - Jika Belum Ada Foto

```dart
else
  Container(
    height: 200,
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: Colors.grey[300]!,
        width: 2,
        style: BorderStyle.solid,
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported_outlined, size: 48),
          const SizedBox(height: 12),
          Text('Belum ada foto yang dipilih'),
        ],
      ),
    ),
  )
```

**Penjelasan**:

| Properti                             | Fungsi                                  |
| ------------------------------------ | --------------------------------------- |
| `height: 200`                        | Placeholder tinggi 200 pixels           |
| `color: Colors.grey[100]`            | Warna background abu-abu muda           |
| `borderRadius: 12`                   | Sudut membulat                          |
| `Border.all`                         | Border pada semua sisi                  |
| `Icons.image_not_supported_outlined` | Ikon gambar tidak tersedia              |
| `Center`                             | Pusatkan konten vertikal dan horizontal |

---

## Notification System

### 📌 \_initializeNotifications() - Setup Notifikasi

```dart
Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}
```

**Platform-specific Settings**:

| Platform | Icon                             | Function                            |
| -------- | -------------------------------- | ----------------------------------- |
| Android  | `@mipmap/ic_launcher`            | Default app icon untuk notification |
| iOS      | `DarwinInitializationSettings()` | Default settings untuk iOS          |

**Dipanggil**:

- Di `main()` sebelum `runApp()` untuk setup awal

---

### 📌 \_showNotification() - Tampilkan Notifikasi

```dart
Future<void> _showNotification(String title, String body) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'photo_channel',           // Channel ID
        'Photo Notifications',     // Channel Name
        channelDescription: 'Notifications for photo events',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      );

  const DarwinNotificationDetails iOSPlatformChannelSpecifics =
      DarwinNotificationDetails();

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    ios: iOSPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.show(
    0,                          // Notification ID
    title,                      // Judul notifikasi
    body,                       // Isi notifikasi
    platformChannelSpecifics,   // Platform-specific settings
    payload: 'item x',          // Data tambahan
  );
}
```

**Android Channel Details**:

| Properti             | Nilai                            | Fungsi                                      |
| -------------------- | -------------------------------- | ------------------------------------------- |
| `id`                 | 'photo_channel'                  | ID unik channel                             |
| `name`               | 'Photo Notifications'            | Nama channel di settings                    |
| `channelDescription` | 'Notifications for photo events' | Deskripsi channel                           |
| `importance`         | `Importance.max`                 | Level kepentingan (max = paling penting)    |
| `priority`           | `Priority.high`                  | Priority notifikasi (high = tampil di atas) |
| `showWhen`           | `true`                           | Tampilkan timestamp kapan notifikasi        |

**Notification Display**:

```
┌─────────────────────────────────┐
│ 📱 Foto Berhasil Diambil        │  <- title
│ Foto dari kamera telah disimpan │  <- body
│ dan ditampilkan!                 │
│                                 │
│ Tapped to ... dismiss ▼          │
└─────────────────────────────────┘
```

**Kapan Ditampilkan**:

1. Saat `_capturePhotoFromCamera()` berhasil
2. Saat `_selectPhotoFromGallery()` berhasil

---

## 🔄 State Update Flow

```
User Action
    │
    ├─── Tap "Ambil Foto dari Kamera"
    │        │
    │        ├─→ _capturePhotoFromCamera()
    │        │    │
    │        │    ├─→ Open Camera
    │        │    │
    │        │    ├─→ User Ambil Foto
    │        │    │
    │        │    ├─→ setState(_selectedImage = newFile)
    │        │    │
    │        │    ├─→ UI Re-render (build() dipanggil)
    │        │    │
    │        │    └─→ Show Notification
    │        │
    └─── Tap "Pilih Foto dari Galeri"
         │
         ├─→ _selectPhotoFromGallery()
         │    │
         │    ├─→ Open Gallery
         │    │
         │    ├─→ User Pilih Foto
         │    │
         │    ├─→ setState(_selectedImage = newFile)
         │    │
         │    ├─→ UI Re-render (build() dipanggil)
         │    │
         │    └─→ Show Notification
```

---

## 📚 Kesimpulan Widget Hierarchy

```
MyApp (Stateless)
    ↓
MaterialApp
    ├── title: 'Camera & Gallery App'
    ├── theme: Material Design 3
    └── home: PhotoCapturePage
        ↓
        PhotoCapturePage (Stateful)
            ↓
            _PhotoCapturePageState
                ├── Properties:
                │   ├── _selectedImage (File?)
                │   └── _picker (ImagePicker)
                │
                ├── Methods:
                │   ├── initState()
                │   ├── _requestPermissions()
                │   ├── _capturePhotoFromCamera()
                │   ├── _selectPhotoFromGallery()
                │   ├── _showErrorSnackBar()
                │   └── build()
                │
                └── UI:
                    ├── Scaffold
                    ├── AppBar
                    └── body:
                        ├── ElevatedButton (Camera)
                        ├── ElevatedButton (Gallery)
                        ├── Image (if photo selected)
                        └── Placeholder (if no photo)
```

---

**Catatan**: Setiap widget dirancang untuk memiliki single responsibility principle dan mudah di-maintain.
