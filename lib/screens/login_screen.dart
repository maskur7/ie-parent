import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  // *PENAMBAHAN BARU: State untuk mengontrol visibilitas password*
  bool _isPasswordVisible = false;

  // Definisi warna kustom untuk screen ini
  static const Color _primaryBlue = Color(0xFF0D47A1); // Ini bisa const karena nilainya statis
  static const Color _lightBackground = Color(0xFFEAF2FB); // Ini bisa const karena nilainya statis

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Login gagal: ${e.message}"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    } catch (e) {
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

  Future<void> _resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar( // SnackBar bisa const jika semua argumennya const
          content: const Text("Masukkan email yang valid untuk reset password."),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: const EdgeInsets.all(20),
        ),
      );
      return;
    }

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar( // SnackBar ini tidak bisa const karena _primaryBlue bukan const saat runtime di sini
            content: const Text("Link reset password telah dikirim ke email kamu."),
            backgroundColor: _primaryBlue, // Warna sukses, sesuai tema
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    } on AuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Gagal kirim reset password: ${e.message}"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Terjadi kesalahan: $e"),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(20),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBackground, // Background color spesifik untuk LoginScreen
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Logo Aplikasi
            ClipRRect(
              borderRadius: BorderRadius.circular(30), // const karena nilainya statis
              child: Image.asset( // Image.asset bisa const jika semua argumennya const
                'assets/images/logo.png', // const string
                height: 120, // const double
                width: 120, // const double
                fit: BoxFit.cover, // const enum value
              ),
            ),
            const SizedBox(height: 25), // const karena nilainya statis

            // Judul Halaman
            Text(
              "Masuk ke IE-Parent",
              style: const TextStyle( // TextStyle ini bisa const karena semua propertinya const
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: _primaryBlue,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Selamat datang kembali! Silakan masuk untuk melanjutkan.",
              textAlign: TextAlign.center,
              style: TextStyle( // TextStyle ini tidak bisa const karena Colors.grey[700] bukan const
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 40),

            // Input Email
            TextField(
              controller: emailController,
              // InputDecoration tidak bisa const karena berisi nilai yang tidak const
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Masukkan email Anda",
                prefixIcon: const Icon(Icons.email_outlined), // Icon bisa const
                // OutlineInputBorder tidak bisa const
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                // TextStyle di sini tidak bisa const karena .withOpacity() bukan const
                labelStyle: TextStyle(color: _primaryBlue.withOpacity(0.8)),
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIconColor: _primaryBlue.withOpacity(0.8),
                // enabledBorder dan focusedBorder tidak bisa const
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Input Password (MODIFIKASI: Menambahkan tombol mata)
            TextField(
              controller: passwordController,
              // Menggunakan state _isPasswordVisible
              obscureText: !_isPasswordVisible, 
              // InputDecoration tidak bisa const
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Masukkan password Anda",
                prefixIcon: const Icon(Icons.lock_outline), // Icon bisa const
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
                // OutlineInputBorder tidak bisa const
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                // TextStyle di sini tidak bisa const
                labelStyle: TextStyle(color: _primaryBlue.withOpacity(0.8)),
                hintStyle: TextStyle(color: Colors.grey[500]),
                prefixIconColor: _primaryBlue.withOpacity(0.8),
                // enabledBorder dan focusedBorder tidak bisa const
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
            const SizedBox(height: 15),

            // Tombol Lupa Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _resetPassword,
                // styleFrom bukan const constructor, jadi tidak bisa pakai const di depannya
                style: TextButton.styleFrom(
                  foregroundColor: _primaryBlue,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold), // TextStyle ini bisa const
                ),
                child: const Text("Lupa kata sandi?"), // Text bisa const
              ),
            ),
            const SizedBox(height: 25),

            // Tombol Login / Indikator Loading
            isLoading
                ? SpinKitThreeBounce(color: _primaryBlue, size: 30) // SpinKit bukan const
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: login,
                      // styleFrom bukan const constructor
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder( // RoundedRectangleBorder bisa const
                          borderRadius: BorderRadius.circular(10), // BorderRadius.circular bisa const
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15), // EdgeInsets.symmetric bisa const
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // TextStyle bisa const
                        elevation: 3,
                      ),
                      child: const Text("Login"), // Text bisa const
                    ),
                  ),

            const SizedBox(height: 30),

            // Link Daftar
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/register'),
              child: RichText(
                text: TextSpan(
                  text: "Belum punya akun? ",
                  style: TextStyle( // TextStyle ini tidak bisa const karena Colors.grey[700] bukan const
                    color: Colors.grey[700],
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: "Daftar di sini",
                      style: const TextStyle( // TextStyle ini bisa const karena semua propertinya const
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