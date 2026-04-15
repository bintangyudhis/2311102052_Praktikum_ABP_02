<?php

header('Content-Type: application/json');

$profil = [
    'nama' => 'Budi',
    'pekerjaan' => 'Web Developer',
    'lokasi' => 'Jakarta',
];

echo json_encode($profil);
