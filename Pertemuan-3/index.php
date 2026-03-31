<?php
// Array data mahasiswa
$mahasiswa = [
    ['nama' => 'Bintang Yudhistira', 'nim' => '2311102052', 'nilai_tugas' => 85, 'nilai_uts' => 80, 'nilai_uas' => 90],
    ['nama' => 'Muhammad Rusman', 'nim' => '2311102053', 'nilai_tugas' => 60, 'nilai_uts' => 65, 'nilai_uas' => 55],
    ['nama' => 'Naufal Thoriq Muzzafar', 'nim' => '2311102054', 'nilai_tugas' => 95, 'nilai_uts' => 85, 'nilai_uas' => 88],
    ['nama' => 'Fasa adelia', 'nim' => '2311102055', 'nilai_tugas' => 45, 'nilai_uts' => 50, 'nilai_uas' => 60]
];

// Function hitung nilai akhir
function hitungNilaiAkhir($tugas, $uts, $uas)
{
    return $tugas * 0.3 + $uts * 0.3 + $uas * 0.4;
}

// Tentukan grade
function tentukanGrade($nilai)
{
    if ($nilai >= 85) return 'A';
    elseif ($nilai >= 70) return 'B';
    elseif ($nilai >= 60) return 'C';
    elseif ($nilai >= 50) return 'D';
    else return 'E';
}

// Status kelulusan
function statusKelulusan($nilai)
{
    return ($nilai >= 60) ? 'Lulus' : 'Tidak Lulus';
}

// Summary
$total_nilai = 0;
$nilai_tertinggi = 0;
foreach ($mahasiswa as $key => $mhs) {
    $nilai_akhir = hitungNilaiAkhir($mhs['nilai_tugas'], $mhs['nilai_uts'], $mhs['nilai_uas']);
    $mahasiswa[$key]['nilai_akhir'] = $nilai_akhir;
    $mahasiswa[$key]['grade'] = tentukanGrade($nilai_akhir);
    $mahasiswa[$key]['status'] = statusKelulusan($nilai_akhir);
    $total_nilai += $nilai_akhir;
    if ($nilai_akhir > $nilai_tertinggi) $nilai_tertinggi = $nilai_akhir;
}
$rata_rata = $total_nilai / count($mahasiswa);
?>

<!DOCTYPE html>
<html lang="id">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sistem Penilaian Mahasiswa</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 20px;
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #0f2027, #203a43, #2c5364);
            color: #f0f0f0;
        }

        .container {
            max-width: 1100px;
            margin: 0 auto;
        }

        h1 {
            text-align: center;
            margin-bottom: 10px;
            font-size: 2.4rem;
            color: #fff;
        }

        h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #cce0ff;
            font-weight: 400;
        }

        /* Tabel */
        .table-wrapper {
            overflow-x: auto;
            border-radius: 16px;
            margin-bottom: 30px;
            border: 1px solid rgba(255, 255, 255, 0.15);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 600px;
        }

        th,
        td {
            padding: 14px 18px;
            text-align: center;
        }

        th {
            background: rgba(255, 255, 255, 0.05);
            color: #cce0ff;
            font-weight: 600;
        }

        tbody tr {
            background: rgba(255, 255, 255, 0.05);
            transition: 0.3s;
        }

        tbody tr:nth-child(odd) {
            background: rgba(255, 255, 255, 0.02);
        }

        tbody tr:hover {
            background: rgba(0, 255, 255, 0.1);
            transform: translateY(-2px);
        }

        /* Badge grade/status */
        .grade-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 12px;
            font-weight: 700;
            color: #fff;
            background: linear-gradient(135deg, #00f5ff, #00c3ff);
            box-shadow: 0 2px 8px rgba(0, 255, 255, 0.4);
        }

        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 12px;
            font-weight: 600;
            color: #fff;
        }

        .status-lulus {
            background: #22c55e;
            box-shadow: 0 2px 8px rgba(34, 197, 94, 0.4);
        }

        .status-gagal {
            background: #f43f5e;
            box-shadow: 0 2px 8px rgba(244, 63, 94, 0.4);
        }

        /* Summary Cards */
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .summary-card {
            background: rgba(0, 255, 255, 0.1);
            border-radius: 16px;
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 6px 16px rgba(0, 255, 255, 0.3);
            transition: 0.3s;
        }

        .summary-card:hover {
            box-shadow: 0 10px 20px rgba(0, 255, 255, 0.5);
        }

        .summary-title {
            color: #a5b4fc;
            font-size: 0.8rem;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .summary-value {
            font-size: 1.8rem;
            font-weight: 700;
        }

        .icon-square {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #00f5ff;
            color: #0b1120;
            font-size: 1.2rem;
            box-shadow: 0 4px 12px rgba(0, 255, 255, 0.4);
        }

        @media(max-width:768px) {
            .summary-card {
                flex-direction: column;
                text-align: center;
            }
        }
    </style>
</head>

<body>
    <div class="container">
        <h1>Sistem Penilaian</h1>
        <h2>Rekapitulasi Nilai Akhir & Status Mahasiswa</h2>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Nama Mahasiswa</th>
                        <th>NIM</th>
                        <th>Tugas</th>
                        <th>UTS</th>
                        <th>UAS</th>
                        <th>Nilai Akhir</th>
                        <th>Grade</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <?php $no = 1;
                    foreach ($mahasiswa as $mhs): ?>
                        <tr>
                            <td><?= $no++ ?></td>
                            <td><?= htmlspecialchars($mhs['nama']) ?></td>
                            <td><?= htmlspecialchars($mhs['nim']) ?></td>
                            <td><?= $mhs['nilai_tugas'] ?></td>
                            <td><?= $mhs['nilai_uts'] ?></td>
                            <td><?= $mhs['nilai_uas'] ?></td>
                            <td><?= number_format($mhs['nilai_akhir'], 2) ?></td>
                            <td><span class="grade-badge"><?= $mhs['grade'] ?></span></td>
                            <td><span class="status-badge <?= ($mhs['status'] == 'Lulus') ? 'status-lulus' : 'status-gagal' ?>"><?= $mhs['status'] ?></span></td>
                        </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>

        <div class="summary-grid">
            <div class="summary-card">
                <div>
                    <div class="summary-title">Rata-rata Kelas</div>
                    <div class="summary-value"><?= number_format($rata_rata, 2) ?></div>
                </div>
                <div class="icon-square">📊</div>
            </div>
            <div class="summary-card">
                <div>
                    <div class="summary-title">Nilai Tertinggi</div>
                    <div class="summary-value"><?= number_format($nilai_tertinggi, 2) ?></div>
                </div>
                <div class="icon-square">🥇</div>
            </div>
        </div>

    </div>
</body>

</html>