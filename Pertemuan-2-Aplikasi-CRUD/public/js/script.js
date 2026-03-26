
// HELPER JAVASCRIPT FUNCTIONS


// Fungsi untuk format tanggal
function formatTanggal(tanggal) {
  if (!tanggal) return "-";
  const date = new Date(tanggal);
  return date.toLocaleDateString("id-ID", {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

// Fungsi untuk validasi email
function isValidEmail(email) {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

// Fungsi untuk memberi loading animation
function setLoading(element, isLoading) {
  if (isLoading) {
    $(element)
      .prop("disabled", true)
      .html('<i class="fas fa-spinner fa-spin"></i> Loading...');
  } else {
    $(element).prop("disabled", false);
  }
}

// Log untuk development
console.log(
  "%cAplikasi CRUD Siswa",
  "color: green; font-size: 20px; font-weight: bold;",
);
console.log(
  "%cBerbasis Node.js + Express + Bootstrap + jQuery",
  "color: blue; font-size: 14px;",
);
