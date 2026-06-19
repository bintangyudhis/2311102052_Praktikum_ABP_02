# Laporan Praktikum: State Management Cubit

**Nama/NIM:** ................................................  
**Mata Kuliah:** Praktikum ABP - Pertemuan 11

## Tujuan dan Hasil

Aplikasi **Katalog Kita** menampilkan enam produk. Pengguna dapat menambah produk berulang kali, mengurangi produk, membuka detail keranjang, dan melihat jumlah item serta total harga berubah secara real-time.

### Screenshot aplikasi

| Daftar produk (awal) | Setelah produk ditambahkan |
|---|---|
| ![Daftar produk](screenshots/daftar-produk.png) | ![Keranjang terisi](screenshots/keranjang-terisi.png) |

> Ambil dua screenshot dengan menjalankan aplikasi, lalu simpan sebagai
> `screenshots/daftar-produk.png` dan `screenshots/keranjang-terisi.png`.
> Screenshot kedua diambil setelah menekan tombol tambah beberapa kali.

## Implementasi Cubit2

State management memakai paket `flutter_bloc` dengan pola **Cubit**. `CartCubit`
mewarisi `Cubit<List<Product>>`; state-nya adalah daftar produk dalam keranjang.
Metode `addProduct()` menghasilkan list baru yang berisi item tambahan, sedangkan
`removeProduct()` menyalin state, menghapus satu item berdasarkan ID, kemudian
memanggil `emit()`. Karena setiap perubahan menghasilkan state baru, widget yang
mendengarkan state dapat diperbarui secara konsisten.

`BlocProvider` ditempatkan di root `ProductApp`, sehingga satu instance
`CartCubit` tersedia bagi seluruh halaman. `BlocBuilder<CartCubit, List<Product>>`
digunakan pada badge AppBar, grid produk, ringkasan bawah, dan bottom sheet.
Ketika Cubit memanggil `emit`, bagian-bagian tersebut otomatis dibangun ulang:
kuantitas per produk, jumlah total item, serta total harga langsung menampilkan
nilai terbaru tanpa `setState()`.

Alur aplikasi:

1. Tombol **+** memanggil `context.read<CartCubit>().addProduct(product)`.
2. Cubit membuat state list baru dan melakukan `emit`.
3. `BlocBuilder` menerima state terbaru lalu memperbarui jumlah item.
4. Tombol **-** atau ikon hapus memanggil `removeProduct(product)` dan alur yang sama berulang.

Struktur utama proyek adalah `models/product.dart` untuk data enam produk,
`cubit/cart_cubit.dart` untuk logika state, dan `pages/product_page.dart` untuk
antarmuka. Widget test memeriksa perubahan 0 -> 1 -> 2 -> 1 item dan perubahan
total harga, sehingga perilaku utama keranjang ikut terdokumentasi.

