import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.icon,
    required this.color,
  });
  final int id;
  final String name;
  final String description;
  final int price;
  final IconData icon;
  final Color color;
}

const products = <Product>[
  Product(
    id: 1,
    name: 'Headphone',
    description: 'Suara jernih untuk menemani aktivitasmu',
    price: 349000,
    icon: Icons.headphones_rounded,
    color: Color(0xFFE8D9FF),
  ),
  Product(
    id: 2,
    name: 'Smart Watch',
    description: 'Pantau kebugaran sepanjang hari',
    price: 599000,
    icon: Icons.watch_rounded,
    color: Color(0xFFD6EEFF),
  ),
  Product(
    id: 3,
    name: 'Kamera Mini',
    description: 'Abadikan momen dalam ukuran ringkas',
    price: 799000,
    icon: Icons.photo_camera_rounded,
    color: Color(0xFFFFE1D5),
  ),
  Product(
    id: 4,
    name: 'Speaker',
    description: 'Musik portabel dengan bass bertenaga',
    price: 279000,
    icon: Icons.speaker_rounded,
    color: Color(0xFFD9F5E5),
  ),
  Product(
    id: 5,
    name: 'Game Controller',
    description: 'Kontrol presisi untuk sesi bermain',
    price: 429000,
    icon: Icons.sports_esports_rounded,
    color: Color(0xFFFFEDC7),
  ),
  Product(
    id: 6,
    name: 'Power Bank',
    description: 'Daya cadangan praktis 10.000 mAh',
    price: 219000,
    icon: Icons.battery_charging_full_rounded,
    color: Color(0xFFE2E5FF),
  ),
];
