# 📚 Aplikasi CRUD Siswa - Node.js + Express + Bootstrap

Aplikasi web manajemen data siswa yang lengkap dengan fitur CRUD (Create, Read, Update, Delete) menggunakan **Node.js**, **Express**, **Bootstrap 5**, dan **jQuery** dengan jQuery DataTable.

---

## 📋 Fitur Utama

✅ **3 Halaman Fungsional:**

- Halaman Dashboard / Beranda
- Halaman Form Input Data
- Halaman Tabel Data Siswa

✅ **CRUD Lengkap:**

- **CREATE** - Tambah data siswa baru
- **READ** - Tampilkan semua data siswa dalam tabel
- **UPDATE** - Edit data siswa yang sudah ada
- **DELETE** - Hapus data siswa

✅ **Fitur Tambahan:**

- jQuery DataTable dengan sorting, filtering, pagination
- Data JSON untuk request/response
- Form validation
- Alert notifications
- Responsive design dengan Bootstrap 5
- Font Awesome icons

---

## 🔧 Teknologi Yang Digunakan

| Kategori       | Teknologi                      |
| -------------- | ------------------------------ |
| **Backend**    | Node.js, Express.js            |
| **Frontend**   | HTML5, Bootstrap 5, jQuery 3.6 |
| **Plugin**     | jQuery DataTable, Font Awesome |
| **Database**   | JSON File (data.json)          |
| **API Format** | RESTful JSON                   |

---

## 📁 Struktur Folder

```
aplikasi-crud-nodejs/
├── server.js                 # Main server file (Express)
├── package.json             # Dependencies
├── data.json                # Database JSON
├── views/                   # HTML Pages
│   ├── dashboard.html       # Halaman 1: Beranda
│   ├── form.html           # Halaman 2: Form Input
│   └── data.html           # Halaman 3: Tabel Data
├── public/
│   ├── css/
│   │   └── style.css       # Custom styling
│   └── js/
│       └── script.js       # Helper functions
└── routes/
    └── api.js              # API endpoints (siap di-develop)
```

---

## 🚀 Cara Instalasi & Menjalankan

### 1. Install Node.js

Download dari: https://nodejs.org/

### 2. Clone/Extract Folder Aplikasi

```bash
# Buka Command Prompt atau PowerShell
cd d:\KULIAH\Semester\ 6\Praktikum\ ABP\aplikasi-crud-nodejs
```

### 3. Install Dependencies

```bash
npm install
```

Output akan seperti ini:

```
added 50 packages in 15s
```

### 4. Jalankan Server

```bash
npm start
```

Output akan seperti ini:

```
================================
Aplikasi CRUD Siswa Berjalan
URL: http://localhost:3000
================================
Tekan Ctrl+C untuk menghentikan server
```

### 5. Buka Browser

Akses: **http://localhost:3000**

---

## 📖 Penjelasan Kode

### A. Server.js - Backend Logic

```javascript
// 1. Inisialisasi Express
const express = require("express");
const app = express();

// 2. Middleware untuk parsing JSON
app.use(express.json());

// 3. Route untuk halaman utama
app.get("/", (req, res) => {
  res.sendFile("views/dashboard.html");
});

// 4. API untuk READ data
app.get("/api/siswa", (req, res) => {
  const data = readData(); // Baca dari data.json
  res.json(data);
});

// 5. API untuk CREATE data
app.post("/api/siswa", (req, res) => {
  const data = readData();
  const siswaBarU = {
    id: generateId(),
    nama: req.body.nama,
    nim: req.body.nim,
    email: req.body.email,
    jurusan: req.body.jurusan,
  };
  data.push(siswaBarU);
  writeData(data);
  res.json({ success: true, data: siswaBarU });
});
```

**Penjelasan:**

- Menggunakan Express.js sebagai framework
- Membaca dan menulis data ke file JSON
- API menggunakan metode: GET, POST, PUT, DELETE

---

### B. Form.html - Halaman Input

```html
<!-- Form dengan 4 field input -->
<form id="formSiswa">
  <input type="text" id="nama" placeholder="Nama" />
  <input type="text" id="nim" placeholder="NIM" />
  <input type="email" id="email" placeholder="Email" />
  <select id="jurusan">
    <option>Teknik Informatika</option>
    <!-- ... -->
  </select>
  <button type="submit">Simpan</button>
</form>

<!-- jQuery untuk handle submit -->
<script>
  $("#formSiswa").on("submit", function (e) {
    e.preventDefault();

    const data = {
      nama: $("#nama").val(),
      nim: $("#nim").val(),
      email: $("#email").val(),
      jurusan: $("#jurusan").val(),
    };

    // AJAX POST ke API
    $.ajax({
      url: "/api/siswa",
      type: "POST",
      data: JSON.stringify(data),
      success: function (response) {
        alert("Data berhasil disimpan!");
        $("#formSiswa")[0].reset();
      },
    });
  });
</script>
```

**Penjelasan:**

- Form berisi 4 field yang wajib diisi
- Menggunakan jQuery untuk handle form submission
- AJAX POST ke `/api/siswa`
- Response dalam format JSON

---

### C. Data.html - Halaman Tabel (jQuery DataTable)

```html
<!-- Tabel dengan data dari JSON -->
<table id="tableSiswa">
  <thead>
    <tr>
      <th>No</th>
      <th>Nama</th>
      <th>NIM</th>
      <th>Email</th>
      <th>Jurusan</th>
      <th>Aksi</th>
    </tr>
  </thead>
  <tbody></tbody>
</table>

<!-- Inisialisasi DataTable -->
<script>
  table = $("#tableSiswa").DataTable({
    ajax: "/api/siswa", // Load dari JSON API
    columns: [
      { data: "id" },
      { data: "nama" },
      { data: "nim" },
      { data: "email" },
      { data: "jurusan" },
    ],
  });
</script>
```

**Penjelasan:**

- Menggunakan jQuery DataTable plugin
- Fitur: sorting, filtering, pagination
- Data diload dari JSON API endpoint `/api/siswa`
- Setiap baris memiliki tombol Edit dan Hapus

---

### D. CRUD Operations dengan jQuery

#### 1. CREATE (Tambah Data)

```javascript
$.ajax({
  url: "/api/siswa",
  type: "POST",
  data: JSON.stringify({ nama, nim, email, jurusan }),
  success: function (response) {
    loadData(); // Refresh tabel
  },
});
```

#### 2. READ (Baca Data)

```javascript
$.ajax({
  url: "/api/siswa",
  type: "GET",
  success: function (data) {
    // Tampilkan di tabel
    table.clear().rows.add(data).draw();
  },
});
```

#### 3. UPDATE (Edit Data)

```javascript
$.ajax({
  url: "/api/siswa/" + id,
  type: "PUT",
  data: JSON.stringify({ nama, nim, email, jurusan }),
  success: function (response) {
    loadData(); // Refresh tabel
  },
});
```

#### 4. DELETE (Hapus Data)

```javascript
$.ajax({
  url: "/api/siswa/" + id,
  type: "DELETE",
  success: function (response) {
    loadData(); // Refresh tabel
  },
});
```

---

## 🎨 Bootstrap Components Yang Digunakan

- **Navbar** - Menu navigasi dengan responsive
- **Card** - Container untuk konten
- **Form Controls** - Input, Select, Textarea
- **Buttons** - Berbagai style (primary, success, danger, dll)
- **Tables** - Untuk menampilkan data grid
- **Modals** - Dialog untuk edit dan hapus
- **Alerts** - Notifikasi pesan
- **Grid System** - Responsive layout dengan columns

---

## 📊 RESTful API Endpoints

| Method | Endpoint         | Fungsi                 | Request Body                     |
| ------ | ---------------- | ---------------------- | -------------------------------- |
| GET    | `/`              | Buka halaman dashboard | -                                |
| GET    | `/form`          | Buka halaman form      | -                                |
| GET    | `/data`          | Buka halaman tabel     | -                                |
| GET    | `/api/siswa`     | Ambil semua data       | -                                |
| GET    | `/api/siswa/:id` | Ambil 1 data by ID     | -                                |
| POST   | `/api/siswa`     | Tambah data baru       | JSON (nama, nim, email, jurusan) |
| PUT    | `/api/siswa/:id` | Update data by ID      | JSON (nama, nim, email, jurusan) |
| DELETE | `/api/siswa/:id` | Hapus data by ID       | -                                |

---

## 🧪 Testing CRUD Operations

### Test Create dengan cURL:

```bash
curl -X POST http://localhost:3000/api/siswa \
  -H "Content-Type: application/json" \
  -d '{"nama":"Bintang","nim":"2311102052","email":"bintang@email.com","jurusan":"Teknik Informatika"}'
```

### Test Read dengan cURL:

```bash
curl http://localhost:3000/api/siswa
```

### Test Update dengan cURL:

```bash
curl -X PUT http://localhost:3000/api/siswa/{ID} \
  -H "Content-Type: application/json" \
  -d '{"nama":"Bintang Baru","nim":"2311102099","email":"bintangbaru@email.com","jurusan":"Sistem Informasi"}'
```

### Test Delete dengan cURL:

```bash
curl -X DELETE http://localhost:3000/api/siswa/{ID}
```

---

## ⚡ Fitur jQuery Yang Digunakan

✅ **jQuery Methods:**

- `.on()` - Event handler
- `.ajax()` - Async request ke server
- `.val()` - Get/Set value input
- `.find()` - Cari element
- `.each()` - Loop array
- `.html()` - Set/Get HTML content
- `.prop()` - Get/Set property

✅ **jQuery Plugins:**

- **DataTable** - Enhanced table dengan sorting, filtering, pagination
- **Bootstrap JS** - Modal, tooltip, dropdown

---

## 🎯 Catatan Penting

1. **Database**: File `data.json` menyimpan semua data siswa. Kapan saja file ini bisa di-backup atau di-replace.

2. **ID Generation**: Setiap siswa baru mendapat ID unik yang di-generate otomatis menggunakan `_` + random string.

3. **Date Format**: Tanggal disimpan dengan format `toLocaleString('id-ID')` untuk format Indonesia.

4. **Validation**:
   - Form validation di frontend (HTML5 required)
   - Server validation di backend (check field kosong)

5. **Error Handling**: Semua API call mempunyai error handling dengan alert message.

---

## 🐛 Troubleshooting

### Error: "Cannot find module 'express'"

**Solusi**: Run `npm install`

### Error: "Port 3000 already in use"

**Solusi**: Ubah port di server.js baris `const PORT = 3000;` ke port lain (3001, 3002, dll)

### Data tidak muncul di tabel

**Solusi**: Refresh browser atau klik tombol Refresh Data

### Form tidak bisa submit

**Solusi**: Buka browser console (F12) dan cek error message

---

## 📦 Mengubah Database Ke SQLite (Opsional)

Jika ingin database lebih proper, bisa upgrade ke SQLite:

```bash
npm install sqlite3
```

Kemudian modifikasi `server.js` untuk menggunakan sqlite3 library.

---

## 🎓 Kesimpulan

Aplikasi ini mendemonstrasikan:

- ✅ 3 halaman fungsional
- ✅ Fitur CRUD lengkap
- ✅ Menggunakan Node.js + Express
- ✅ Bootstrap untuk UI
- ✅ jQuery untuk interaksi
- ✅ jQuery DataTable untuk tabel
- ✅ JSON format untuk data
- ✅ RESTful API design
- ✅ Responsive design
- ✅ Error handling

---

**Author**: Bintang Yudhistira  
**NIM**: 2311102052  
**Mata Kuliah**: Praktikum ABP  
**Dibuat**: Maret 2024
