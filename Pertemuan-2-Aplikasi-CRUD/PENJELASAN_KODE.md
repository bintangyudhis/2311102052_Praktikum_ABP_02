# 📝 PENJELASAN LENGKAP KODE - APLIKASI CRUD SISWA

## Table of Contents

1. [Struktur Aplikasi](#struktur-aplikasi)
2. [Penjelasan Server.js](#penjelasan-serverjs)
3. [Penjelasan Dashboard.html](#penjelasan-dashboardhtml)
4. [Penjelasan Form.html](#penjelasan-formhtml)
5. [Penjelasan Data.html](#penjelasan-datahtml)
6. [Penjelasan CRUD Operations](#penjelasan-crud-operations)
7. [Penjelasan jQuery](#penjelasan-jquery)
8. [Penjelasan Bootstrap](#penjelasan-bootstrap)

---

## 🏗️ Struktur Aplikasi

### Arsitektur Aplikasi

```
Client (Browser)
    ↓ (HTTP Request)
Halaman HTML (Dashboard, Form, Data)
    ↓ (JavaScript/jQuery)
AJAX Request ke API
    ↓ (HTTP Request)
Express Server (server.js)
    ↓ (Logical Processing)
File JSON (data.json)
    ↓ (JSON Response)
Express Server
    ↓ (HTTP Response)
AJAX Response
    ↓ (JavaScript Processing)
Display ke Halaman HTML
    ↓ (DOM Update)
User Interface
```

---

## 🖥️ Penjelasan Server.js

### 1. Require Dependencies

```javascript
const express = require("express");
const bodyParser = require("body-parser");
const fs = require("fs");
const path = require("path");
```

**Penjelasan:**

- `express` - Web framework untuk membuat API dan route
- `bodyParser` - Middleware untuk parsing request body
- `fs` - File system module untuk baca/tulis file
- `path` - Module untuk handle file path

### 2. Inisialisasi Express

```javascript
const app = express();
const PORT = 3000;
```

**Penjelasan:**

- `app` - Instance Express application
- `PORT` - Port tempat server berjalan (localhost:3000)

### 3. Middleware

```javascript
app.use(express.static("public"));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
```

**Penjelasan:**

- `express.static('public')` - Serve file statis (CSS, JS, images)
- `bodyParser.json()` - Parse JSON request body
- `bodyParser.urlencoded({ extended: true })` - Parse form data

### 4. Fungsi Helper - Read Data

```javascript
function readData() {
  try {
    if (fs.existsSync(DATA_FILE)) {
      const rawData = fs.readFileSync(DATA_FILE, "utf8");
      return JSON.parse(rawData);
    }
    return [];
  } catch (err) {
    console.error("Error reading data:", err);
    return [];
  }
}
```

**Penjelasan:**

- Cek apakah file `data.json` ada
- Jika ada, baca file dan parse dari JSON ke JavaScript object
- Jika error, return array kosong
- Return array berisi semua data siswa

### 5. Fungsi Helper - Write Data

```javascript
function writeData(data) {
  try {
    fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2), "utf8");
    return true;
  } catch (err) {
    console.error("Error writing data:", err);
    return false;
  }
}
```

**Penjelasan:**

- Convert JavaScript object ke JSON string
- Tulis ke file `data.json`
- `null, 2` untuk indentasi yang rapi
- Return true jika sukses, false jika error

### 6. Fungsi Generate ID Unik

```javascript
function generateId() {
  return "_" + Math.random().toString(36).substr(2, 9);
}
```

**Penjelasan:**

- Generate string random untuk ID unik
- Contoh hasil: `_abc12def45`
- Setiap siswa baru mendapat ID berbeda

### 7. Route - GET Halaman

```javascript
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "dashboard.html"));
});

app.get("/form", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "form.html"));
});

app.get("/data", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "data.html"));
});
```

**Penjelasan:**

- Ketika user akses `/` → tampilkan halaman dashboard.html
- Ketika user akses `/form` → tampilkan halaman form.html
- Ketika user akses `/data` → tampilkan halaman data.html
- `path.join()` untuk menggabung path yang benar

### 8. API - READ (GET)

```javascript
app.get("/api/siswa", (req, res) => {
  const data = readData();
  res.json(data);
});
```

**Penjelasan:**

- Endpoint untuk mendapatkan SEMUA data siswa
- Method: GET
- URL: http://localhost:3000/api/siswa
- Response: Array JSON berisi semua siswa
- **Digunakan di**: Halaman data untuk load tabel

### 9. API - READ by ID

```javascript
app.get("/api/siswa/:id", (req, res) => {
  const data = readData();
  const siswa = data.find((s) => s.id === req.params.id);

  if (siswa) {
    res.json({ success: true, data: siswa });
  } else {
    res.status(404).json({ success: false, message: "Data tidak ditemukan" });
  }
});
```

**Penjelasan:**

- Endpoint untuk mendapatkan DATA SATU siswa berdasarkan ID
- `:id` adalah URL parameter yang dinamis
- Cari siswa dengan `find()` method
- Jika ketemu, return data siswa
- Jika tidak ketemu, return error 404
- **Digunakan di**: Klik tombol Edit untuk load data ke form modal

### 10. API - CREATE (POST)

```javascript
app.post("/api/siswa", (req, res) => {
  // Validasi input
  if (!req.body.nama || !req.body.nim || !req.body.email || !req.body.jurusan) {
    return res.status(400).json({
      success: false,
      message: "Semua field harus diisi",
    });
  }

  // Baca data lama
  const data = readData();

  // Buat data baru
  const siswaBaru = {
    id: generateId(),
    nama: req.body.nama,
    nim: req.body.nim,
    email: req.body.email,
    jurusan: req.body.jurusan,
    tanggalTambah: new Date().toLocaleString("id-ID"),
  };

  // Tambahkan ke array
  data.push(siswaBaru);

  // Simpan ke file
  if (writeData(data)) {
    res.json({
      success: true,
      message: "Data siswa berhasil ditambahkan",
      data: siswaBaru,
    });
  } else {
    res.status(500).json({
      success: false,
      message: "Gagal menyimpan data",
    });
  }
});
```

**Penjelasan:**

- Endpoint untuk MENAMBAH data siswa baru
- Method: POST
- URL: http://localhost:3000/api/siswa
- Request Body: JSON { nama, nim, email, jurusan }
- Langkah:
  1. Validasi semua field tidak kosong
  2. Baca data lama dari file
  3. Buat object siswa baru dengan ID unik
  4. Tambahkan ke array data
  5. Tulis ke file (update data.json)
  6. Return response sukses atau gagal
- **Digunakan di**: Klik tombol "Simpan Data" di halaman form

### 11. API - UPDATE (PUT)

```javascript
app.put("/api/siswa/:id", (req, res) => {
  // Validasi input
  if (!req.body.nama || !req.body.nim || !req.body.email || !req.body.jurusan) {
    return res.status(400).json({
      success: false,
      message: "Semua field harus diisi",
    });
  }

  // Baca data lama
  const data = readData();

  // Cari dan update data
  const index = data.findIndex((s) => s.id === req.params.id);

  if (index !== -1) {
    data[index] = {
      ...data[index],
      nama: req.body.nama,
      nim: req.body.nim,
      email: req.body.email,
      jurusan: req.body.jurusan,
      tanggalUpdate: new Date().toLocaleString("id-ID"),
    };

    // Simpan ke file
    if (writeData(data)) {
      res.json({
        success: true,
        message: "Data siswa berhasil diperbarui",
        data: data[index],
      });
    } else {
      res.status(500).json({
        success: false,
        message: "Gagal menyimpan data",
      });
    }
  } else {
    res.status(404).json({
      success: false,
      message: "Data tidak ditemukan",
    });
  }
});
```

**Penjelasan:**

- Endpoint untuk MENGUBAH/EDIT data siswa
- Method: PUT
- URL: http://localhost:3000/api/siswa/{ID}
- Langkah:
  1. Validasi semua field tidak kosong
  2. Baca data lama
  3. Cari index siswa dengan ID yang sesuai
  4. Update field siswa dengan data baru
  5. Tulis ke file (update data.json)
  6. Return response sukses atau gagal
- **Digunakan di**: Klik tombol "Simpan Perubahan" di modal edit

### 12. API - DELETE

```javascript
app.delete("/api/siswa/:id", (req, res) => {
  // Baca data lama
  const data = readData();

  // Cari dan hapus data
  const index = data.findIndex((s) => s.id === req.params.id);

  if (index !== -1) {
    const deletedData = data[index];
    data.splice(index, 1);

    // Simpan ke file
    if (writeData(data)) {
      res.json({
        success: true,
        message: "Data siswa berhasil dihapus",
        data: deletedData,
      });
    } else {
      res.status(500).json({
        success: false,
        message: "Gagal menghapus data",
      });
    }
  } else {
    res.status(404).json({
      success: false,
      message: "Data tidak ditemukan",
    });
  }
});
```

**Penjelasan:**

- Endpoint untuk MENGHAPUS data siswa
- Method: DELETE
- URL: http://localhost:3000/api/siswa/{ID}
- Langkah:
  1. Baca data lama
  2. Cari index siswa dengan ID yang sesuai
  3. Hapus dari array dengan `splice()`
  4. Tulis ke file (update data.json)
  5. Return response sukses atau gagal
- **Digunakan di**: Klik tombol "Hapus" dan konfirmasi di modal

### 13. Server Listen

```javascript
app.listen(PORT, () => {
  console.log(`================================`);
  console.log(`Aplikasi CRUD Siswa Berjalan`);
  console.log(`URL: http://localhost:${PORT}`);
  console.log(`================================`);
  console.log(`Tekan Ctrl+C untuk menghentikan server`);
});
```

**Penjelasan:**

- Server mulai listening di port 3000
- Print message ke console untuk konfirmasi

---

## 🎨 Penjelasan Dashboard.html

### 1. Meta Tags & Head

```html
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Dashboard - Aplikasi CRUD Siswa</title>
```

**Penjelasan:**

- `charset="UTF-8"` - Encoding untuk karakter Indonesia
- `viewport` - Responsive untuk mobile devices
- `title` - Judul di browser tab

### 2. Navbar (Navigation Bar)

```html
<nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top shadow">
  <div class="container-fluid">
    <a class="navbar-brand" href="/">
      <i class="fas fa-graduation-cap"></i> Aplikasi CRUD Siswa
    </a>
    <!-- Menu items -->
    <ul class="navbar-nav ms-auto">
      <li class="nav-item">
        <a class="nav-link active" href="/">🏠 Beranda</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="/form">📝 Input Data</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" href="/data">📊 Lihat Data</a>
      </li>
    </ul>
  </div>
</nav>
```

\*\*Penjelasan:\

- `navbar-dark bg-primary` - Navbar biru dengan text putih
- `sticky-top` - Navbar tetap di atas saat scroll
- `.navbar-brand` - Logo/judul aplikasi
- `.navbar-nav ms-auto` - Menu di sebelah kanan
- Tiga link: Beranda, Input Data, Lihat Data

### 3. Main Content - Cards

```html
<div class="row mb-5">
  <div class="col-md-4 mb-4">
    <div class="card shadow-sm border-0 h-100 hover-card">
      <div class="card-body text-center">
        <div class="mb-3">
          <i class="fas fa-pen-fancy fa-3x text-success"></i>
        </div>
        <h5 class="card-title">Form Input Data</h5>
        <p class="card-text text-muted small">
          Tambahkan data siswa baru dengan form yang user-friendly
        </p>
        <a href="/form" class="btn btn-success btn-sm">
          <i class="fas fa-arrow-right"></i> Buka Form
        </a>
      </div>
    </div>
  </div>
  <!-- Card 2 dan 3 sama struktur -->
</div>
```

**Penjelasan:**

- `row mb-5` - Grid row dengan margin bottom
- `col-md-4` - Kolom 4 dari 12 (1/3 lebar) untuk medium screen
- `card shadow-sm border-0` - Card dengan shadow tapi tanpa border
- `h-100` - Height 100% untuk height sama semua card
- `text-center` - Text di tengah
- Icon dari Font Awesome
- Button untuk navigate ke halaman lain

---

## 📝 Penjelasan Form.html

### 1. Form Element

```html
<form id="formSiswa" class="needs-validation">
  <!-- Field Nama -->
  <div class="mb-3">
    <label for="nama" class="form-label fw-bold">
      <i class="fas fa-user"></i> Nama Siswa <span class="text-danger">*</span>
    </label>
    <input
      type="text"
      class="form-control form-control-lg"
      id="nama"
      placeholder="Masukkan nama lengkap siswa"
      required
    />
  </div>

  <!-- Field NIM -->
  <div class="mb-3">
    <label for="nim" class="form-label fw-bold">
      <i class="fas fa-id-card"></i> NIM <span class="text-danger">*</span>
    </label>
    <input
      type="text"
      class="form-control form-control-lg"
      id="nim"
      placeholder="Masukkan NIM"
      required
    />
  </div>

  <!-- Field Email -->
  <div class="mb-3">
    <label for="email" class="form-label fw-bold">
      <i class="fas fa-envelope"></i> Email <span class="text-danger">*</span>
    </label>
    <input
      type="email"
      class="form-control form-control-lg"
      id="email"
      placeholder="Masukkan email"
      required
    />
  </div>

  <!-- Field Jurusan -->
  <div class="mb-4">
    <label for="jurusan" class="form-label fw-bold">
      <i class="fas fa-book"></i> Jurusan <span class="text-danger">*</span>
    </label>
    <select class="form-select form-select-lg" id="jurusan" required>
      <option value="">-- Pilih Jurusan --</option>
      <option value="Teknik Informatika">Teknik Informatika</option>
      <option value="Sistem Informasi">Sistem Informasi</option>
      <option value="Manajemen Informatika">Manajemen Informatika</option>
      <option value="Teknik Komputer">Teknik Komputer</option>
      <option value="Ilmu Komputer">Ilmu Komputer</option>
    </select>
  </div>

  <!-- Buttons -->
  <div class="d-grid gap-2 d-sm-flex justify-content-sm-end">
    <button type="reset" class="btn btn-secondary btn-lg" id="btnReset">
      <i class="fas fa-redo"></i> Reset
    </button>
    <button type="submit" class="btn btn-primary btn-lg" id="btnSubmit">
      <i class="fas fa-save"></i> Simpan Data
    </button>
  </div>
</form>
```

**Penjelasan Bootstrap:**

- `form-label fw-bold` - Label dengan text bold/tebal
- `form-control form-control-lg` - Input field besar
- `form-select form-select-lg` - Select dropdown besar
- `required` - HTML5 validation (field wajib diisi)
- `text-danger` - Red color untuk asterisk (\*)
- `d-grid gap-2 d-sm-flex` - Grid layout yang berubah ke flex di small screen
- `justify-content-sm-end` - Button di sebelah kanan

### 2. jQuery Form Handler

```javascript
$("#formSiswa").on("submit", function (e) {
  e.preventDefault(); // Cegah default form submit

  // Ambil nilai input
  const nama = $("#nama").val().trim();
  const nim = $("#nim").val().trim();
  const email = $("#email").val().trim();
  const jurusan = $("#jurusan").val().trim();

  // Validasi input
  if (!nama || !nim || !email || !jurusan) {
    showAlert("Semua field harus diisi!", "danger");
    return;
  }

  // Disable submit button saat proses
  $("#btnSubmit")
    .prop("disabled", true)
    .html('<i class="fas fa-spinner fa-spin"></i> Menyimpan...');

  // AJAX POST ke API
  $.ajax({
    url: "/api/siswa", // API endpoint
    type: "POST", // Method HTTP
    contentType: "application/json", // Type content
    data: JSON.stringify({
      // Data untuk dikirim
      nama: nama,
      nim: nim,
      email: email,
      jurusan: jurusan,
    }),
    success: function (response) {
      // Jika berhasil
      if (response.success) {
        showAlert(response.message, "success");
        $("#formSiswa")[0].reset(); // Clear form

        // Reset button
        $("#btnSubmit")
          .prop("disabled", false)
          .html('<i class="fas fa-save"></i> Simpan Data');
      }
    },
    error: function (xhr) {
      // Jika error
      const errorMsg = xhr.responseJSON?.message || "Terjadi kesalahan";
      showAlert(errorMsg, "danger");

      // Reset button
      $("#btnSubmit")
        .prop("disabled", false)
        .html('<i class="fas fa-save"></i> Simpan Data');
    },
  });
});
```

**Penjelasan jQuery:**

- `.on('submit', function...)` - Event handler form submit
- `e.preventDefault()` - Cegah default form submit ke server
- `$('#nama').val()` - Get value dari input #nama
- `.trim()` - Hapus whitespace di awal dan akhir
- `$.ajax()` - Async HTTP request
- `success` - Fungsi yang dijalankan jika response sukses
- `error` - Fungsi yang dijalankan jika error
- `.prop('disabled', true)` - Disable button
- `.html()` - Set HTML content

---

## 📊 Penjelasan Data.html

### 1. Toolbar

```html
<div class="card-body border-bottom bg-light">
  <div class="row g-3">
    <div class="col-md-6">
      <button class="btn btn-success btn-lg" onclick="location.href='/form'">
        <i class="fas fa-plus-circle"></i> Tambah Data Baru
      </button>
    </div>
    <div class="col-md-6 text-end">
      <button class="btn btn-info btn-lg" id="btnRefresh">
        <i class="fas fa-sync-alt"></i> Refresh Data
      </button>
    </div>
  </div>
</div>
```

**Penjelasan:**

- Button "Tambah Data Baru" navigate ke halaman /form
- Button "Refresh Data" untuk reload tabel
- `text-end` - Align button ke sebelah kanan

### 2. DataTable HTML

```html
<table id="tableSiswa" class="table table-striped table-hover">
  <thead class="table-primary text-white">
    <tr>
      <th width="5%">No</th>
      <th>Nama</th>
      <th>NIM</th>
      <th>Email</th>
      <th>Jurusan</th>
      <th width="15%">Aksi</th>
    </tr>
  </thead>
  <tbody>
    <!-- Data akan diambil dari JSON API -->
  </tbody>
</table>
```

**Penjelasan:**

- `id="tableSiswa"` - ID untuk inisialisasi DataTable
- `table table-striped table-hover` - Bootstrap table class
- `table-primary text-white` - Header warna biru dengan text putih
- `tbody` - Body tabel yang akan di-populate dengan $.ajax

### 3. DataTable Initialization

```javascript
table = $("#tableSiswa").DataTable({
  language: {
    url: "https://cdn.datatables.net/plug-ins/1.13.7/i18n/id.json",
  },
  columnDefs: [
    { orderable: false, targets: [0, 5] }, // No & Aksi columns tidak sortable
  ],
  order: [[1, "asc"]], // Sort by kolom nama (index 1)
  pageLength: 10, // 10 rows per page
  lengthMenu: [
    [5, 10, 25, 50],
    [5, 10, 25, 50],
  ], // Pilihan rows
  dom: "lBfrtip", // Layout DataTable
  buttons: [
    "copy",
    "csv",
    "excel",
    "print", // Export buttons
  ],
});
```

**Penjelasan jQuery DataTable:**

- `language.url` - Bahasa Indonesia untuk label DataTable
- `columnDefs` - Konfigurasi kolom (no. 0 dan 5 tidak sortable)
- `order` - Sorting default (kolom 1 = Nama, arah ascending)
- `pageLength` - Jumlah row per halaman
- `lengthMenu` - Pilihan jumlah row
- `dom` - Layout elements
- `buttons` - Export buttons (copy, csv, excel, print)

### 4. Load Data Function

```javascript
function loadData() {
  $.ajax({
    url: "/api/siswa", // GET dari API
    type: "GET",
    dataType: "json", // Expected response format
    success: function (response) {
      table.clear(); // Clear tabel

      let no = 1;
      $.each(response, function (index, siswa) {
        // Template aksi buttons
        const aksi = `
          <button class="btn btn-sm btn-warning" onclick="editData('${siswa.id}')">
            <i class="fas fa-edit"></i> Edit
          </button>
          <button class="btn btn-sm btn-danger" onclick="konfirmasiHapus('${siswa.id}')">
            <i class="fas fa-trash"></i> Hapus
          </button>
        `;

        // Tambah row ke tabel
        table.row
          .add([
            no++, // No urut
            siswa.nama, // Nama
            siswa.nim, // NIM
            siswa.email, // Email
            siswa.jurusan, // Jurusan
            aksi, // Aksi buttons
          ])
          .draw(false);
      });

      table.draw(); // Redraw tabel
      $("#totalData").text(response.length); // Update counter
    },
    error: function () {
      showAlert("Gagal memuat data", "danger");
    },
  });
}
```

**Penjelasan:**

- `$.ajax()` - GET request ke `/api/siswa`
- `table.clear()` - Clear semua row yang ada
- `$.each()` - Loop setiap siswa dari response
- `table.row.add()` - Tambah baris baru ke tabel
- Template string untuk buttons edit dan delete
- `table.draw()` - Render tabel dengan data baru

### 5. Edit Data Function

```javascript
function editData(id) {
  $.ajax({
    url: "/api/siswa/" + id, // GET detail siswa
    type: "GET",
    dataType: "json",
    success: function (response) {
      if (response.success) {
        const siswa = response.data;

        // Isi form modal dengan data
        $("#editId").val(siswa.id);
        $("#editNama").val(siswa.nama);
        $("#editNim").val(siswa.nim);
        $("#editEmail").val(siswa.email);
        $("#editJurusan").val(siswa.jurusan);

        // Buka modal
        modalEdit.show();
      }
    },
    error: function () {
      showAlert("Gagal memuat data", "danger");
    },
  });
}
```

**Penjelasan:**

- GET request ke `/api/siswa/{id}` untuk ambil detail siswa
- Set value form dengan data siswa
- Show modal edit

### 6. Update Data Function

```javascript
function updateData() {
  const id = $("#editId").val();
  const nama = $("#editNama").val().trim();
  const nim = $("#editNim").val().trim();
  const email = $("#editEmail").val().trim();
  const jurusan = $("#editJurusan").val().trim();

  // Validasi
  if (!nama || !nim || !email || !jurusan) {
    showAlert("Semua field harus diisi", "danger");
    return;
  }

  // AJAX PUT ke API
  $.ajax({
    url: "/api/siswa/" + id, // PUT ke /api/siswa/{id}
    type: "PUT",
    contentType: "application/json",
    data: JSON.stringify({
      nama: nama,
      nim: nim,
      email: email,
      jurusan: jurusan,
    }),
    success: function (response) {
      if (response.success) {
        showAlert(response.message, "success");
        modalEdit.hide();
        loadData(); // Reload tabel
      }
    },
    error: function () {
      showAlert("Gagal mengupdate data", "danger");
    },
  });
}
```

**Penjelasan:**

- GET data dari form
- Validasi semua field
- AJAX PUT request ke API
- Update data.json di server
- Reload tabel setelah sukses

### 7. Delete Data Function

```javascript
function hapusData() {
  if (!deleteId) return;

  $.ajax({
    url: "/api/siswa/" + deleteId, // DELETE /api/siswa/{id}
    type: "DELETE",
    dataType: "json",
    success: function (response) {
      if (response.success) {
        showAlert(response.message, "success");
        modalHapus.hide();
        loadData(); // Reload tabel
        deleteId = null;
      }
    },
    error: function () {
      showAlert("Gagal menghapus data", "danger");
    },
  });
}
```

**Penjelasan:**

- AJAX DELETE request ke API
- Hapus data dari data.json di server
- Reload tabel setelah sukses

---

## 🔧 Penjelasan CRUD Operations

### Flow Diagram

```
CREATE (Tambah)
================
1. User buka halaman /form
2. Isi form dengan data siswa
3. Klik "Simpan Data"
4. jQuery submit form (AJAX POST)
5. Server baca data lama + tambah data baru
6. Server tulis ke data.json
7. Server return success message
8. Client tampilkan alert & clear form

READ (Baca)
===========
1. User buka halaman /data
2. Page load, jQuery .ajax() GET /api/siswa
3. Server baca data.json, return JSON array
4. Client masukkan ke DataTable
5. DataTable render dengan sorting, filtering, pagination

UPDATE (Edit)
=============
1. User klik tombol "Edit" di tabel
2. jQuery GET /api/siswa/{id}
3. Server return data siswa yang dipilih
4. Client tampilkan modal dengan form pre-filled
5. User edit field dan klik "Simpan Perubahan"
6. jQuery PUT /api/siswa/{id} dengan data baru
7. Server update data.json
8. Server return success message
9. Client reload tabel

DELETE (Hapus)
==============
1. User klik tombol "Hapus" di tabel
2. Tampilkan modal konfirmasi
3. User klik "Hapus" di modal
4. jQuery DELETE /api/siswa/{id}
5. Server hapus dari data.json
6. Server return success message
7. Client reload tabel
```

---

## 🎯 Penjelasan jQuery

### jQuery Selectors

```javascript
$("#nama"); // Select element dengan ID "nama"
$(".btn"); // Select semua element dengan class "btn"
$('input[type="email"]'); // Select input dengan type email
```

### jQuery Methods - DOM Manipulation

```javascript
$("#nama").val(); // Get value input
$("#nama").val("Bintang"); // Set value input
$("#nama").html(); // Get HTML content
$("#nama").html("<b>Bintang</b>"); // Set HTML content
$("#nama").text(); // Get text content
$("#nama").addClass("active"); // Add class
$("#nama").removeClass("active"); // Remove class
$("#nama").prop("disabled", true); // Set property
```

### jQuery Events

```javascript
$("#btnSubmit").on("click", function () {}); // Click event
$("#formSiswa").on("submit", function () {}); // Submit event
$("#nama").on("change", function () {}); // Change event
$("#nama").on("keyup", function () {}); // Keyup event
```

### jQuery AJAX

```javascript
$.ajax({
  url: "/api/siswa", // Endpoint URL
  type: "GET", // HTTP method
  dataType: "json", // Expected response type
  data: { filter: "active" }, // Query parameters (GET)
  contentType: "application/json", // Request content type (POST)
  data: JSON.stringify({
    // Request body (POST)
    nama: "Bintang",
  }),
  success: function (response) {
    // Success callback
    console.log(response);
  },
  error: function (xhr) {
    // Error callback
    console.log(xhr.status);
  },
});
```

### jQuery Utility Functions

```javascript
$.each(array, function (index, item) {}); // Loop array
JSON.stringify(obj); // Convert object to JSON string
JSON.parse(jsonString); // Convert JSON string to object
```

---

## 🎨 Penjelasan Bootstrap

### Grid System

```html
<div class="container">
  <div class="row">
    <div class="col-12">Full width</div>
  </div>
  <div class="row">
    <div class="col-md-6">Half width (medium screen)</div>
    <div class="col-md-6">Half width (medium screen)</div>
  </div>
  <div class="row">
    <div class="col-md-4">Third (medium screen)</div>
    <div class="col-md-4">Third (medium screen)</div>
    <div class="col-md-4">Third (medium screen)</div>
  </div>
</div>
```

### Spacing Classes

```html
<div class="mb-3">Margin bottom 3</div>
<div class="mt-4">Margin top 4</div>
<div class="px-5">Padding left & right 5</div>
<div class="py-2">Padding top & bottom 2</div>
```

### Text Classes

```html
<div class="text-center">Text center</div>
<div class="text-end">Text right</div>
<div class="fw-bold">Bold text</div>
<div class="text-muted">Muted text</div>
<div class="text-danger">Danger text (red)</div>
<div class="text-success">Success text (green)</div>
```

### Component Classes

```html
<!-- Buttons -->
<button class="btn btn-primary">Primary button</button>
<button class="btn btn-danger btn-lg">Large danger button</button>
<button class="btn btn-sm">Small button</button>

<!-- Cards -->
<div class="card">
  <div class="card-header">Header</div>
  <div class="card-body">Body content</div>
  <div class="card-footer">Footer</div>
</div>

<!-- Alerts -->
<div class="alert alert-success">Success message</div>
<div class="alert alert-danger">Error message</div>

<!-- Forms -->
<input class="form-control" type="text" />
<select class="form-select">
  <option>Option 1</option>
</select>

<!-- Tables -->
<table class="table table-striped table-hover">
  <thead class="table-primary">
    ...
  </thead>
  <tbody>
    ...
  </tbody>
</table>

<!-- Modals -->
<div class="modal fade" id="myModal">
  <div class="modal-dialog">
    <div class="modal-content">...</div>
  </div>
</div>
```

### Responsive Classes

```html
<!-- Breakpoints -->
<!-- Extra small (mobile): < 576px -->
<!-- Small (landscape): >= 576px -->
<!-- Medium (tablets): >= 768px -->
<!-- Large (desktops): >= 992px -->
<!-- Extra large: >= 1200px -->

<div class="col-12 col-md-6 col-lg-4">
  12 kolom mobile, 6 kolom tablet, 4 kolom desktop
</div>

<!-- Display property -->
<div class="d-none d-md-block">Hidden di mobile, visible di tablet</div>

<!-- Flexbox -->
<div class="d-flex justify-content-between align-items-center">
  <div>Left</div>
  <div>Right</div>
</div>
```

---

## Kesimpulan

**Server.js**: Handle backend logic, read/write file JSON, provide API endpoints

**Form.html**: User input data, jQuery form handling, AJAX POST request

**Data.html**: Display data dengan jQuery DataTable, CRUD buttons, modals for edit/delete

**JavaScript/jQuery**: Handle all frontend interactions, AJAX calls, DOM updates

**Bootstrap**: Responsive design, pre-built components, styling

**JSON**: Data format untuk API request/response

Semua komponen bekerja bersama untuk create aplikasi CRUD yang fully functional
