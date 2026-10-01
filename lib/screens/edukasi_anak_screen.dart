import 'package:flutter/material.dart';

class EdukasiAnakScreen extends StatelessWidget {
  final List<String> materiEdukasi;

  const EdukasiAnakScreen({super.key, required this.materiEdukasi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Materi Edukasi Anak',
          style: TextStyle(
            color: Colors.black, // Mengatur warna teks menjadi putih
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 104, 214),
      ),
      body: ListView.builder(
        itemCount: materiEdukasi.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                materiEdukasi[index],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        },
      ),
    );
  }
}