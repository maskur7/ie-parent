import 'package:flutter/material.dart';

class OthersScreen extends StatelessWidget {
  const OthersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> features = [
      {'icon': Icons.menu_book, 'label': 'Edukasi', 'route': '/edukasi'},
      {'icon': Icons.track_changes, 'label': 'Tracking', 'route': '/tracking'},
      {'icon': Icons.quiz, 'label': 'Tes Gaya Belajar', 'route': '/test'},
      {'icon': Icons.school, 'label': 'Rencana Belajar', 'route': '/plan'},
      {'icon': Icons.shopping_bag, 'label': 'Belanja', 'route': '/belanja'},
      {'icon': Icons.monitor_heart, 'label': 'Pemantauan', 'route': '/tracking'},
      {'icon': Icons.integration_instructions, 'label': 'Platform', 'route': '/platform'},
      // Tambahkan fitur lainnya sesuai kebutuhan
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lainnya'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: features.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final item = features[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, item['route']);
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item['icon'],
                      size: 36,
                      color: const Color(0xFF005F6B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item['label'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
