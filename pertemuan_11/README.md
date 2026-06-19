# Katalog Kita - Flutter Cubit

Aplikasi daftar produk dan keranjang sederhana untuk praktikum state management.

## Menjalankan

```bash
flutter pub get
flutter run
```

## Struktur

- `lib/models/product.dart` - model dan enam data produk.
- `lib/cubit/cart_cubit.dart` - state serta operasi tambah/hapus.
- `lib/pages/product_page.dart` - daftar produk, badge, dan keranjang.
- `test/widget_test.dart` - tes perubahan state melalui interaksi UI.
- `LAPORAN.md` - laporan singkat maksimal dua halaman.

## Menguji

```bash
flutter analyze
flutter test
```

