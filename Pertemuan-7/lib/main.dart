import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Praktikum Modul Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const WidgetDemoPage(),
    );
  }
}

class WidgetDemoPage extends StatelessWidget {
  const WidgetDemoPage({super.key});

  final List<String> dataMahasiswa = const [
    'Bintang Yudhistira',
    'Anisa Putri',
    'Dimas Pratama',
    'Nadia Safira',
    'Raka Wijaya',
  ];

  final List<String> mataKuliah = const [
    'Pemrograman Mobile',
    'Basis Data',
    'Interaksi Manusia Komputer',
    'Algoritma Pemrograman',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas Praktikum Modul Flutter'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle('Container'),
          Container(
            height: 96,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Kotak Berwarna',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('GridView'),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            children: List.generate(
              6,
              (index) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.primaries[index + 2],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Item ${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('ListView'),
          SizedBox(
            height: 168,
            child: ListView(
              children: const [
                _SimpleListTile(label: 'A'),
                _SimpleListTile(label: 'B'),
                _SimpleListTile(label: 'C'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('ListView.builder'),
          SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: dataMahasiswa.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(dataMahasiswa[index]),
                    subtitle: const Text('Data dari array'),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('ListView.separated'),
          SizedBox(
            height: 232,
            child: ListView.separated(
              itemCount: mataKuliah.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(mataKuliah[index]),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Stack'),
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                Positioned(
                  left: 28,
                  top: 28,
                  child: Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Positioned(
                  right: 28,
                  bottom: 28,
                  child: Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      color: const Color(0xFF38BDF8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const Center(
                  child: Text(
                    'Tampilan Bertumpuk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SimpleListTile extends StatelessWidget {
  const _SimpleListTile({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.label),
        title: Text('Item $label'),
      ),
    );
  }
}
