import 'package:flutter/material.dart';

class PlatformScreen extends StatelessWidget {
  const PlatformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blue.shade700;
    const accentColor = Colors.orangeAccent;

    return Scaffold(
      appBar: AppBar(
        title: const Text('VIParent'),
        backgroundColor: const Color.fromARGB(255, 30, 104, 214),
        foregroundColor: Colors.black,
        elevation: 1,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/vipplatform.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              // Box 1: Create Influence Earn
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: primaryColor.withOpacity(0.3)),
                ),
                child: const Column(
                  children: [
                    Text(
                      'Create',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Influence',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Earn',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              // Box 2: Info & Ajak Join
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar sekarang untuk join komunitas orang tua terbesar di Asia Tenggara.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Dapatkan uang dengan menulis review, mempromosikan produk favoritmu, ikut survey dan poll, atau buat konten untuk komunitas!\n\nYuk, gabung sekarang di komunitas orang tua terbesar di Asia Tenggara.',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Tombol Aksi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // aksi lanjut
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Ikut sekarang',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
