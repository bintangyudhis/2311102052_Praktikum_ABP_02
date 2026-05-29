import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

late List<CameraDescription> cameras;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeNotifications();
  cameras = await availableCameras();
  runApp(const MyApp());
}

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

Future<void> _showNotification(String title, String body) async {
  try {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'photo_channel',
          'Photo Notifications',
          channelDescription: 'Notifications for photo events',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    // Use unique ID based on timestamp to ensure notifications are shown
    int uniqueId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await flutterLocalNotificationsPlugin.show(
      uniqueId,
      title,
      body,
      platformChannelSpecifics,
      payload: 'photo_notification',
    );

    debugPrint('✅ Notification shown: $title - $body');
  } catch (e) {
    debugPrint('❌ Notification error: $e');
  }
}

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

class PhotoCapturePage extends StatefulWidget {
  const PhotoCapturePage({super.key});

  @override
  State<PhotoCapturePage> createState() => _PhotoCapturePageState();
}

class _PhotoCapturePageState extends State<PhotoCapturePage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.notification.request();
  }

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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil & Pilih Foto'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section untuk tombol ambil dan pilih foto
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Pilih Foto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _selectPhotoFromGallery,
                      icon: const Icon(Icons.image),
                      label: const Text('Pilih Foto dari Galeri'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: const Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Section untuk menampilkan foto
              if (_selectedImage != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Foto yang Dipilih:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                    Text(
                      'Ukuran: ${_selectedImage!.lengthSync()} bytes',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                )
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
                        Icon(
                          Icons.image_not_supported_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Belum ada foto yang dipilih',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
