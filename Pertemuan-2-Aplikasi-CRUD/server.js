
// APLIKASI CRUD SISWA - MAIN SERVER
// Framework: Express.js
// Database: File JSON (data.json)


const express = require("express");
const bodyParser = require("body-parser");
const fs = require("fs");

const path = require("path");

// Inisialisasi Express
const app = express();
const PORT = 3000;

// Path file database JSON
const DATA_FILE = path.join(__dirname, "data.json");


// MIDDLEWARE


// Middleware untuk membaca static files (CSS, JS, dll)
app.use(express.static("public"));

// Middleware untuk parsing request body (JSON dan form)
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));


// FUNGSI HELPER - BACA/TULIS DATA JSON


// Fungsi untuk membaca data dari file JSON
function readData() {
  try {
    if (fs.existsSync(DATA_FILE)) {
      const rawData = fs.readFileSync(DATA_FILE, "utf8");
      return JSON.parse(rawData);
    }
    return []; // Jika file tidak ada, return array kosong
  } catch (err) {
    console.error("Error reading data:", err);
    return [];
  }
}

// Fungsi untuk menyimpan data ke file JSON
function writeData(data) {
  try {
    fs.writeFileSync(DATA_FILE, JSON.stringify(data, null, 2), "utf8");
    return true;
  } catch (err) {
    console.error("Error writing data:", err);
    return false;
  }
}

// Fungsi untuk generate ID unik
function generateId() {
  return "_" + Math.random().toString(36).substr(2, 9);
}


// RUTE HALAMAN UTAMA


// Halaman 1: Beranda / Dashboard
app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "dashboard.html"));
});

// Halaman 2: Form Input Data
app.get("/form", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "form.html"));
});

// Halaman 3: Tabel Data Siswa
app.get("/data", (req, res) => {
  res.sendFile(path.join(__dirname, "views", "data.html"));
});


// API ROUTE UNTUK CRUD OPERATIONS


// API 1: GET - Ambil semua data siswa (JSON format)
app.get("/api/siswa", (req, res) => {
  const data = readData();
  res.json(data);
});

// API 2: GET - Ambil satu data siswa berdasarkan ID
app.get("/api/siswa/:id", (req, res) => {
  const data = readData();
  const siswa = data.find((s) => s.id === req.params.id);

  if (siswa) {
    res.json({ success: true, data: siswa });
  } else {
    res.status(404).json({ success: false, message: "Data tidak ditemukan" });
  }
});

// API 3: POST - Tambah data siswa baru (CREATE)
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
  const siswaBarU = {
    id: generateId(),
    nama: req.body.nama,
    nim: req.body.nim,
    email: req.body.email,
    jurusan: req.body.jurusan,
    tanggalTambah: new Date().toLocaleString("id-ID"),
  };

  // Tambahkan ke array
  data.push(siswaBarU);

  // Simpan ke file
  if (writeData(data)) {
    res.json({
      success: true,
      message: "Data siswa berhasil ditambahkan",
      data: siswaBarU,
    });
  } else {
    res.status(500).json({
      success: false,
      message: "Gagal menyimpan data",
    });
  }
});

// API 4: PUT - Update data siswa (UPDATE)
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

// API 5: DELETE - Hapus data siswa (DELETE)
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


// ERROR HANDLING - 404 NOT FOUND


app.use((req, res) => {
  res.status(404).send("<h1>404 - Halaman Tidak Ditemukan</h1>");
});


// START SERVER


app.listen(PORT, () => {
  console.log(`================================`);
  console.log(`Aplikasi CRUD Siswa Berjalan`);
  console.log(`URL: http://localhost:${PORT}`);
  console.log(`================================`);
  console.log(`Tekan Ctrl+C untuk menghentikan server`);
});
