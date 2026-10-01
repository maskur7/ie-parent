import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Pastikan ini sudah ditambahkan di pubspec.yaml
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  // *PENAMBAHAN BARU: State untuk mengontrol visibilitas password*
  bool _isPasswordVisible = false;

  // Definisi warna kustom untuk screen ini (konsisten dengan login_screen.dart)
  static const Color _primaryBlue = Color(0xFF0D47A1); // Biru tua
  static const Color _lightBackground = Color(0xFFEAF2FB); // Background cerah

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    // Memastikan tidak ada proses registrasi yang sedang berjalan
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      await Supabase.instance.client.auth.signUp(
        email: emailController.text.trim(), // Pastikan email di-trim
        password: passwordController.text.trim(), // Pastikan password di-trim
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Registrasi berhasil! Silakan login."),
            backgroundColor: _primaryBlue, // Warna sukses
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(20),
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on AuthException catch (e) { // Tangani AuthException secara spesifik
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registrasi gagal: ${e.message}"),
            backgroundColor: Colors.redAccent, // Warna error
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    } catch (e) { // Tangani error umum lainnya
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi kesalahan: ${e.toString()}"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground, // Background color spesifik untuk RegisterScreen
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan konten horizontal
          children: [
            // Logo Aplikasi
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.asset(
                'assets/images/logo.png', // Pastikan path ini benar
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 25), // Jarak disesuaikan

            // Judul Halaman
            const Text( // Diubah menjadi const jika memungkinkan
              "Daftar Akun IE-Parent",
              style: TextStyle(
                fontSize: 28, // Ukuran font lebih besar
                fontWeight: FontWeight.w800, // Lebih tebal
                color: _primaryBlue, // Warna konsisten
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Buat akun baru untuk mulai menjelajahi aplikasi.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 40), // Jarak lebih jauh sebelum input

            // Input Email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress, // Keyboard type yang sesuai
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Masukkan email Anda",
                prefixIcon: const Icon(Icons.email_outlined), // Ikon email yang konsisten
                // Dekorasi input field yang konsisten
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                labelStyle: TextStyle(color: _primaryBlue.withOpacity(0.8)),
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIconColor: _primaryBlue.withOpacity(0.8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Password (MODIFIKASI: Menambahkan tombol mata)
            TextField(
              controller: passwordController,
              // Menggunakan state _isPasswordVisible
              obscureText: !_isPasswordVisible, 
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Masukkan password Anda",
                prefixIcon: const Icon(Icons.lock_outline), // Ikon password yang konsisten
                // *PENAMBAHAN BARU: Suffix Icon (Ikon Mata)*
                suffixIcon: IconButton(
                  icon: Icon(
                    // Mengganti ikon berdasarkan state _isPasswordVisible
                    _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: _primaryBlue.withOpacity(0.8),
                  ),
                  onPressed: () {
                    // Membalikkan state visibilitas saat ikon diklik
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                // Dekorasi input field yang konsisten
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                labelStyle: TextStyle(color: _primaryBlue.withOpacity(0.8)),
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIconColor: _primaryBlue.withOpacity(0.8),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 25), // Jarak disesuaikan

            // Tombol Daftar / Indikator Loading
            isLoading
                ? SpinKitThreeBounce(color: _primaryBlue, size: 30) // Menggunakan SpinKit konsisten dengan Login
                : SizedBox(
                    width: double.infinity,
                    height: 55, // Tinggi tombol konsisten
                    child: ElevatedButton(
                      onPressed: register,
                      style: ElevatedButton.styleFrom( // Gaya tombol konsisten
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        elevation: 3,
                      ),
                      child: const Text("Daftar"), // Teks tombol
                    ),
                  ),

            const SizedBox(height: 30), // Jarak disesuaikan

            // Link Sudah punya akun?
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/login'),
              child: RichText(
                text: TextSpan(
                  text: "Sudah punya akun? ",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: "Masuk di sini",
                      style: const TextStyle(
                        color: _primaryBlue,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}