import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  final _changePasswordFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  String email = '';
  String joinDate = '';
  String role = '';
  bool isLoading = false;

  // --- DEFINE COLOR PALETTE (Consistency with home_page.dart) ---
  final Color _primaryColor = const Color(0xFF4A90E2); // Biru yang dominan di home
  final Color _secondaryColor = const Color(0xFFF5A623); // Oranye untuk aksen
  final Color _backgroundColor = const Color(0xFFF7F7F7); // Latar belakang yang sangat terang
  final Color _cardColor = Colors.white; // Putih bersih untuk card
  final Color _textColorDark = const Color(0xFF333333); // Abu-abu gelap untuk judul
  final Color _textColorMedium = const Color(0xFF666666); // Abu-abu sedang untuk deskripsi
  final Color _textColorLight = Colors.white; // Putih untuk teks pada background gelap
  final Color _successColor = Colors.green.shade600; // Untuk notifikasi sukses
  final Color _errorColor = Colors.red.shade600; // Untuk notifikasi error

  // Warna baru untuk AppBar background
  final Color _appBarBackgroundColor = const Color.fromARGB(255, 30, 104, 214);


  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null).then((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    setState(() => isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        setState(() {
          email = user.email ?? 'Tidak ada email';
          final parsedDate = DateTime.parse(user.createdAt).toLocal();
          joinDate = DateFormat('d MMMM yyyy', 'id_ID').format(parsedDate); // Ditambahkan 'yyyy'
        });

        final response = await supabase
            .from('users')
            .select('name, phone, role')
            .eq('id', user.id)
            .maybeSingle();

        if (response != null) {
          setState(() {
            nameController.text = response['name'] ?? 'Nama Pengguna';
            phoneController.text = response['phone'] ?? 'Tidak ada No. HP';
            role = response['role'] ?? 'Pengguna Biasa';
          });
        } else {
          setState(() {
            nameController.text = 'Pengguna Baru';
            phoneController.text = 'N/A';
            role = 'Pengguna Biasa';
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Anda belum login. Silakan login terlebih dahulu.'),
              backgroundColor: _errorColor,
            ),
          );
          Navigator.pushReplacementNamed(context, '/login');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat profil: $e'),
            backgroundColor: _errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        await supabase.from('users').upsert({
          'id': user.id,
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profil berhasil diperbarui'),
              backgroundColor: _successColor,
            ),
          );
        }
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error Supabase: ${e.message}'),
            backgroundColor: _errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memperbarui profil: $e'),
            backgroundColor: _errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _changePassword() async {
    if (!_changePasswordFormKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final AuthResponse response = await supabase.auth.signInWithPassword(
        email: email,
        password: oldPasswordController.text.trim(),
      );

      if (response.user == null) {
        throw 'Password lama tidak cocok atau autentikasi gagal.';
      }

      await supabase.auth.updateUser(
        UserAttributes(password: newPasswordController.text.trim()),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Password berhasil diubah'),
            backgroundColor: _successColor,
          ),
        );

        oldPasswordController.clear();
        newPasswordController.clear();
      }
    } on AuthException catch (e) {
      String errorMessage = 'Gagal mengganti password.';
      if (e.message.contains('invalid_grant')) {
        errorMessage = 'Password lama salah. Silakan coba lagi.';
      } else {
        errorMessage = 'Auth Error: ${e.message}';
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: _errorColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: $e'),
            backgroundColor: _errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _buildCustomTextFormField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.nunito(color: _textColorMedium),
        hintStyle: GoogleFonts.nunito(color: _textColorMedium.withOpacity(0.7)),
        filled: true,
        fillColor: _backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _backgroundColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _errorColor, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: GoogleFonts.nunito(color: _textColorDark, fontSize: 16),
      validator: validator,
    );
  }

  Widget _buildCustomElevatedButton({
    required VoidCallback onPressed,
    required String label,
    required IconData icon,
    required Color buttonColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: Icon(icon, color: _textColorLight),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _textColorLight,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 4,
          shadowColor: buttonColor.withOpacity(0.3),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          "Profil Saya",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColorLight, // <--- Warna teks judul diubah menjadi putih
            ),
          ),
        ),
        backgroundColor: _appBarBackgroundColor, // <--- Warna AppBar background baru
        elevation: 0, // <--- Hapus elevasi AppBar agar menyatu dengan header
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: _textColorLight), // <--- Warna ikon logout diubah menjadi putih
            tooltip: 'Keluar',
            onPressed: isLoading
                ? null
                : () async {
                    setState(() => isLoading = true);
                    try {
                      await supabase.auth.signOut();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Berhasil keluar.'),
                            backgroundColor: _successColor,
                          ),
                        );
                        Navigator.pushReplacementNamed(context, '/login');
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Gagal keluar: $e'),
                            backgroundColor: _errorColor,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() => isLoading = false);
                      }
                    }
                  },
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- Profil Header Card ---
                  // Card ini akan berada di bawah AppBar, jadi tidak perlu lagi latar belakang terpisah
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    shadowColor: Colors.black.withOpacity(0.1),
                    color: _cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: _primaryColor.withOpacity(0.1),
                            child: Icon(Icons.person, size: 50, color: _primaryColor),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            nameController.text.isNotEmpty ? nameController.text : 'Nama Pengguna',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _textColorDark,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Chip(
                            label: Text(
                              role,
                              style: GoogleFonts.nunito(
                                textStyle: TextStyle(
                                  color: _primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            backgroundColor: _primaryColor.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            email,
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                color: _textColorMedium,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Text(
                            'Bergabung sejak $joinDate',
                            style: GoogleFonts.nunito(
                              textStyle: TextStyle(
                                color: _textColorMedium.withOpacity(0.7),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Form Edit Profil ---
                  Text(
                    "Edit Profil",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _textColorDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.08),
                    color: _cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCustomTextFormField(
                              controller: nameController,
                              labelText: 'Nama Lengkap',
                              validator: (value) =>
                                  value!.isEmpty ? 'Nama tidak boleh kosong' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildCustomTextFormField(
                              controller: phoneController,
                              labelText: 'Nomor Telepon',
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Nomor HP tidak boleh kosong';
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                  return 'Nomor HP hanya boleh angka';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildCustomElevatedButton(
                              onPressed: _updateProfile,
                              label: "Simpan Perubahan",
                              icon: Icons.save,
                              buttonColor: _primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- Ganti Password ---
                  Text(
                    "Ganti Password",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: _textColorDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.08),
                    color: _cardColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _changePasswordFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCustomTextFormField(
                              controller: oldPasswordController,
                              labelText: 'Password Lama',
                              obscureText: true,
                              validator: (value) =>
                                  value!.isEmpty ? 'Password lama tidak boleh kosong' : null,
                            ),
                            const SizedBox(height: 16),
                            _buildCustomTextFormField(
                              controller: newPasswordController,
                              labelText: 'Password Baru',
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password baru tidak boleh kosong';
                                }
                                if (value.length < 6) {
                                  return 'Password minimal 6 karakter';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _buildCustomElevatedButton(
                              onPressed: _changePassword,
                              label: "Ubah Password",
                              icon: Icons.lock_reset,
                              buttonColor: _secondaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}