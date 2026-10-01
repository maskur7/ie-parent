import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Tambahkan impor ini

// Import screens lain yang diperlukan oleh BottomNavigationBar dan navigasi
import 'tracking_screen.dart';
import 'education_screen.dart';
import 'profile_screen.dart';
import 'shopping_screen.dart';
import 'edukasi_hamil_screen.dart';
import 'edukasi_anak_screen.dart';

// Impor screens yang namanya telah disesuaikan
import 'test_learning_style_screen.dart';
import 'plan_screen.dart';
import 'others_screen.dart';
import 'platform_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = ''; // State untuk menyimpan teks pencarian

  // Tambahkan instance SupabaseClient
  final SupabaseClient supabase = Supabase.instance.client;
  // Tambahkan variabel state untuk menyimpan nama pengguna
  String? _userName;

  // Palette warna yang diperbarui untuk tampilan yang lebih modern dan elegan
  final Color _primaryColor = const Color(0xFF64B5F6); // Biru muda yang segar
  final Color _accentColor = const Color(0xFF1E88E5); // Biru yang lebih dalam untuk aksen
  final Color _cardColor = Colors.white;
  final Color _backgroundColor = const Color(0xFFF5F9FF); // Background lebih soft
  final Color _textColorPrimary = const Color(0xFF2C3E50); // Dark blue-grey untuk teks utama
  final Color _textColorSecondary = const Color(0xFF7F8C8D); // Slate untuk teks sekunder

  // Warna untuk gradient dan aksen
  final Color _gradientStart = const Color(0xFF64B5F6);
  final Color _gradientEnd = const Color(0xFF1E88E5);

  // Daftar halaman yang akan ditampilkan oleh BottomNavigationBar
  late final List<Widget> _pages;

  // Data dummy untuk pencarian (fitur utama, kategori edukasi, dan menu lainnya)
  final List<Map<String, dynamic>> _searchableItems = [
    // Fitur Utama
    {'type': 'fitur', 'title': 'Tes Gaya Belajar', 'keywords': 'tes gaya belajar, anak, pendidikan, psikologi, minat', 'targetWidget': TestLearningStyleScreen()},
    {'type': 'fitur', 'title': 'Rencana Belajar', 'keywords': 'rencana belajar, jadwal, anak, kurikulum, kegiatan', 'targetWidget': const PlanScreen()},
    {'type': 'fitur', 'title': 'Tracking', 'keywords': 'tracking, pantau, kemajuan, pertumbuhan, anak, monitor', 'targetWidget': const TrackingScreen()},
    {'type': 'fitur', 'title': 'Edukasi', 'keywords': 'edukasi, parenting, materi, artikel, tips, pengasuhan', 'targetWidget': const EducationScreen()},
    // Kategori Edukasi
    {'type': 'kategori', 'title': 'Edukasi Kehamilan', 'keywords': 'hamil, kehamilan, nutrisi, janin, kesehatan ibu, ibu hamil, persiapan', 'targetWidget': const EdukasiHamilScreen(materiEdukasi: [])},
    {'type': 'kategori', 'title': 'Edukasi Anak', 'keywords': 'anak, tumbuh kembang, mendidik, stimulasi, balita, bayi, pola asuh', 'targetWidget': const EdukasiAnakScreen(materiEdukasi: [])},
    // Menu Lainnya
    {'type': 'menu', 'title': 'Belanja', 'keywords': 'belanja, produk, ibu, bayi, perlengkapan, toko, kebutuhan', 'targetWidget': const ShoppingScreen()},
    {'type': 'menu', 'title': 'Profil', 'keywords': 'profil, akun, pengaturan, data diri, privasi', 'targetWidget': const ProfileScreen()},
    {'type': 'menu', 'title': 'Lainnya', 'keywords': 'lainnya, fitur lain, dashboard, menu utama', 'targetWidget': const OthersScreen()},
    {'type': 'menu', 'title': 'Platform', 'keywords': 'platform, aplikasi, tentang, bantuan, info', 'targetWidget': const PlatformScreen()},
  ];

  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    // Inisialisasi _pages di initState setelah _HomeScreenState dibuat
    _pages = [
      _buildHomeContent(),
      const TrackingScreen(),
      const EducationScreen(),
      const ProfileScreen(),
    ];

    _searchController.addListener(_onSearchChanged);
    _searchResults = [];

    _fetchUserName(); // Panggil metode untuk mengambil nama pengguna
    print('initState: Memulai pengambilan nama pengguna.'); // Debug print
  }

  // Metode baru untuk mengambil nama pengguna dari Supabase
  Future<void> _fetchUserName() async {
    print('fetchUserName: Dipanggil.'); // Debug print
    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        print('fetchUserName: Pengguna terautentikasi dengan ID: ${user.id}'); // Debug print
        // Logika yang sama dengan ProfileScreen untuk mendapatkan nama dari tabel 'users'
        final response = await supabase.from('users').select('name').eq('id', user.id).maybeSingle();
        if (response != null && response['name'] != null) {
          setState(() {
            _userName = response['name'] as String;
          });
          print('fetchUserName: Nama pengguna berhasil diambil: $_userName'); // Debug print
        } else {
          print('fetchUserName: Data nama tidak ditemukan di tabel users atau response null.'); // Debug print
          if (response != null) {
              print('fetchUserName: Response: $response'); // Untuk melihat isi response jika tidak null tapi tanpa nama
          }
        }
      } else {
        print('fetchUserName: Pengguna tidak terautentikasi (currentUser is null).'); // Debug print
      }
    } catch (e) {
      // Tangani error, bisa dengan mencetak ke konsol atau menampilkan SnackBar
      print('fetchUserName: Error mengambil nama pengguna untuk home screen: $e'); // Debug print
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _handleSearch(_searchController.text);
  }

  // Fungsi untuk menangani tap pada item BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Jika berpindah dari tab home, kosongkan pencarian
      if (index != 0) {
        _searchController.clear();
        _searchText = '';
        _searchResults = []; // Kosongkan hasil pencarian saat berpindah tab
      }
    });
  }

  // Fungsi untuk menangani penekanan tombol 'Back' pada perangkat
  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      // Jika bukan di halaman Beranda, kembali ke Beranda
      setState(() {
        _selectedIndex = 0;
      });
      return false; // Jangan keluar dari aplikasi
    }
    // Jika sudah di halaman Beranda, izinkan keluar dari aplikasi
    return true;
  }

  // Fungsi untuk melakukan pencarian
  void _handleSearch(String query) {
    setState(() {
      _searchText = query;
      if (query.isEmpty) {
        _searchResults = []; // Kosongkan hasil jika query kosong, biarkan UI utama muncul
      } else {
        _searchResults = _searchableItems.where((item) {
          final titleLower = item['title'].toLowerCase();
          final keywordsLower = item['keywords'].toLowerCase();
          final searchLower = query.toLowerCase();
          return titleLower.contains(searchLower) || keywordsLower.contains(searchLower);
        }).toList();
      }
    });

    // Opsional: tampilkan snackbar jika tidak ada hasil (hanya jika query tidak kosong dan tidak ada hasil)
    if (query.isNotEmpty && _searchResults.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Sembunyikan snackbar sebelumnya
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tidak ada hasil ditemukan untuk: "$query"'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else if (query.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Sembunyikan jika query kosong
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Menghubungkan fungsi _onWillPop ke WillPopScope
      child: Scaffold(
        backgroundColor: _backgroundColor, // Warna latar belakang Scaffold
        body: _pages[_selectedIndex], // Menampilkan halaman yang sesuai dengan _selectedIndex
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Index item yang sedang aktif
          selectedItemColor: _accentColor, // Warna ikon dan label item terpilih
          unselectedItemColor: _textColorSecondary, // Warna ikon dan label item tidak terpilih
          onTap: _onItemTapped, // Callback saat item ditekan
          type: BottomNavigationBarType.fixed, // Memastikan semua item terlihat
          backgroundColor: _cardColor, // Warna latar belakang BottomNavigationBar
          elevation: 8, // Memberi sedikit shadow
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded), label: "Beranda"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart_rounded), label: "Tracking"),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_rounded), label: "Edukasi"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded), label: "Profil"),
          ],
        ),
      ),
    );
  }

  // --- Widget-widget yang sebelumnya ada di home_content.dart kini di sini ---

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildWelcomeSection(),
                const SizedBox(height: 16),
                _buildSearchBar(context),
                const SizedBox(height: 24),
                // Logika untuk menampilkan hasil pencarian atau konten utama
                if (_searchText.isNotEmpty) ...[
                  _buildSectionTitle("Hasil Pencarian"),
                  const SizedBox(height: 12),
                  _buildSearchResults(),
                ] else ...[
                  _buildSectionTitle("Promo & Info Terbaru"),
                  const SizedBox(height: 12),
                  _buildCarousel(),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Fitur Utama"),
                  const SizedBox(height: 12),
                  _buildFiturUtama(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Jelajahi Kategori"),
                  const SizedBox(height: 12),
                  _buildCategorySelector(context),
                  const SizedBox(height: 24),
                  _buildSectionTitle("Menu Lainnya"),
                  const SizedBox(height: 12),
                  _buildMenuGrid(context),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 80.0,
      floating: true,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_gradientStart, _gradientEnd],
          ),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: _gradientEnd.withOpacity(0.4),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: FlexibleSpaceBar(
          titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "iE-Parent",
                style: GoogleFonts.montserrat(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: _cardColor,
                    fontSize: 22,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 28),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Notifikasi ditekan!'),
                  backgroundColor: _accentColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _textColorPrimary,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }

  // Widget _buildWelcomeSection yang sudah diubah
  Widget _buildWelcomeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shadowColor: _primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: _cardColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // Menggunakan _userName yang diambil dari Supabase
                      _userName != null && _userName!.isNotEmpty
                          ? "Halo Bunda ${_userName!.split(' ')[0]}!" // Menampilkan "Halo Bunda [NamaDepan]!"
                          : "Halo Bunda!", // Default jika nama tidak ditemukan
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: _textColorPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Semoga hari ini menyenangkan!",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 16,
                          color: _textColorSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _primaryColor.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/images/parent_banner.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Cari artikel, tips, atau lainnya...',
          hintStyle: GoogleFonts.nunito(
            textStyle: TextStyle(
              fontSize: 14,
              color: _textColorSecondary,
            ),
          ),
          prefixIcon: Icon(Icons.search, color: _accentColor),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.clear, color: _textColorSecondary),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.mic_none_rounded, color: _accentColor), // Mengganti kamera dengan mic
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Pencarian suara (mic) ditekan!'),
                          backgroundColor: _accentColor,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ),
          filled: true,
          fillColor: _cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor.withOpacity(0.2), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _primaryColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        ),
        style: GoogleFonts.nunito(
          textStyle: TextStyle(
            fontSize: 14,
            color: _textColorPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    final List<String> assetImages = [
      'assets/images/slider1.jpg',
      'assets/images/slider2.jpg',
      'assets/images/slider3.jpg',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 180.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 0.92,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.easeInOutCubic,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        enlargeFactor: 0.2,
      ),
      items: assetImages.map((path) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _accentColor.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Image.asset(path, fit: BoxFit.cover, width: double.infinity),
                // Gradient overlay for better text visibility if needed
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFiturUtama(BuildContext context) {
    final fiturList = [
      {
        'icon': Icons.psychology_rounded,
        'title': "Gaya Belajar",
        'desc': "Kenali cara belajar",
        'targetWidget': TestLearningStyleScreen(),
        'color': const Color(0xFF333333), // Warna teks/ikon, bisa diubah sesuai keinginan
        'bgColor': const Color(0xFFA7C7E7), // Biru Pastel sebagai latar belakang
      },
      {
        'icon': Icons.checklist_rounded,
        'title': "Rencana",
        'desc': "Atur jadwal belajar",
        'targetWidget': const PlanScreen(),
        'color': const Color(0xFF333333), // Warna teks/ikon
        'bgColor': const Color(0xFFA7C7E7), // Peach sebagai latar belakang
      },
      {
        'icon': Icons.bar_chart_rounded,
        'title': "Tracking",
        'desc': "Pantau kemajuan",
        'targetWidget': const TrackingScreen(),
        'color': const Color(0xFF333333), // Warna teks/ikon
        'bgColor': const Color(0xFFA7C7E7), // Biru Pastel sebagai latar belakang
      },
      {
        'icon': Icons.lightbulb_rounded,
        'title': "Edukasi",
        'desc': "Materi parenting",
        'targetWidget': const EducationScreen(),
        'color': const Color(0xFF333333), // Warna teks/ikon
        'bgColor': const Color(0xFFA7C7E7), // Peach sebagai latar belakang
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: fiturList.length,
            itemBuilder: (context, index) {
              final item = fiturList[index];
              final itemColor = item['color'] as Color;
              final bgColor = item['bgColor'] as Color;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => item['targetWidget'] as Widget,
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: itemColor.withOpacity(0.15),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: itemColor.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(item['icon'] as IconData, color: itemColor, size: 32),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item['title'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: itemColor,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['desc'] as String,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                            fontSize: 12,
                            color: _textColorSecondary, // Tetap gunakan warna secondary yang ada
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.dashboard_rounded,
        'label': 'Lainnya',
        'targetWidget': const OthersScreen(),
        'color': const Color(0xFF005F6B), // Biru Teal Tua/Gelap
      },
      {
        'icon': Icons.child_care_rounded,
        'label': 'Pemantau',
        'targetWidget': const TrackingScreen(),
        'color': const Color(0xFF005F6B), // Biru Teal Tua/Gelap
      },
      {
        'icon': Icons.shopping_bag_rounded,
        'label': 'Belanja',
        'targetWidget': const ShoppingScreen(),
        'color': const Color(0xFF005F6B), // Biru Teal Tua/Gelap
      },
      {
        'icon': Icons.star_rounded,
        'label': 'Platform',
        'targetWidget': const PlatformScreen(),
        'color': const Color(0xFF005F6B), // Biru Teal Tua/Gelap
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: menuItems.map((item) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => item['targetWidget'] as Widget,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // Latar belakang lingkaran ikon menggunakan warna utama dengan opacity
                        color: (item['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      // Warna ikon sama dengan warna utama
                      child: Icon(item['icon'], color: item['color'] as Color, size: 24),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['label'] as String,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          // Pastikan warna teks label cukup kontras.
                          // Jika background Card secara umum terang, _textColorPrimary mungkin sudah cukup.
                          // Jika ingin selalu terang, gunakan Color(0xFFE0F7FA).
                          color: Color.fromARGB(255, 80, 92, 94), // Menggunakan warna cerah dari tema
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // --- Widget _buildCategorySelector ---
  Widget _buildCategorySelector(BuildContext context) {
  // Fungsi pembantu untuk membuat card kategori
  Widget categoryCard(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap, {
    required Color cardBackgroundColor, // Latar belakang keseluruhan kartu
    required Color iconCircleColor, // Latar belakang lingkaran ikon
    required Color iconColor, // Warna ikon itu sendiri
    required Color textColor, // Warna teks label
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: cardBackgroundColor, // Warna latar belakang kartu
          elevation: 2,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            // Border kartu disesuaikan dengan warna latar belakang ikon
            side: BorderSide(color: iconCircleColor, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10), // Padding untuk ikon
                  decoration: BoxDecoration(
                    color: iconCircleColor, // Latar belakang lingkaran ikon
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor, // Warna ikon
                    size: 32,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat( // Menggunakan GoogleFonts
                    textStyle: TextStyle(
                      color: textColor, // Warna teks
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            categoryCard(
              context,
              Icons.pregnant_woman_rounded,
              'Saya sedang hamil',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EdukasiHamilScreen(
                      materiEdukasi: [
                        'Nutrisi penting selama kehamilan',
                        'Perkembangan janin trimester pertama',
                        'Tips menjaga kesehatan saat hamil',
                      ],
                    ),
                  ),
                );
              },
              cardBackgroundColor: const Color(0xFFA7C7E7), // Peach untuk latar belakang kartu
              iconCircleColor: Colors.white, // Biru Pastel untuk lingkaran ikon
              iconColor: const Color(0xFF333333), // Ikon putih
              textColor: const Color(0xFF333333), // Teks abu-abu gelap
            ),
            const SizedBox(width: 16),
            categoryCard(
              context,
              Icons.child_care_rounded,
              'Saya sudah punya anak',
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EdukasiAnakScreen(
                      materiEdukasi: [
                        'Tahapan tumbuh kembang anak usia dini',
                        'Tips mendidik anak dengan positif',
                        'Stimulasi perkembangan kognitif anak',
                      ],
                    ),
                  ),
                );
              },
              cardBackgroundColor: const Color(0xFFA7C7E7), // Biru Pastel untuk latar belakang kartu
              iconCircleColor: Colors.white, // Peach untuk lingkaran ikon
              iconColor: const Color(0xFF333333), // Ikon abu-abu gelap
              textColor: const Color(0xFF333333), // Teks putih
            ),
          ],
        ),
      ),
    ),
  );
}

  // --- Widget _categoryCard (Sudah Diperbarui untuk Konsistensi) ---
  Widget _categoryCard(
      BuildContext context,
      IconData iconData, // Sekarang menerima IconData, bukan String imageAsset
      String label,
      VoidCallback onTap, {
      required Color backgroundColor,
      required Color textColor,
      required Color borderColor,
      // Parameter gradientStart dan gradientEnd tidak lagi diperlukan karena tidak ada gradien
      // Anda bisa menghapusnya jika tidak ada penggunaan lain
    }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor, // Latar belakang solid: const Color(0xFF005F6B)
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 1.5), // Border oranye transparan
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2), // Shadow yang lebih gelap
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent, // Penting agar warna container terlihat
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10), // Padding untuk ikon
                      decoration: BoxDecoration(
                        color: textColor.withOpacity(0.15), // Latar belakang lingkaran ikon oranye transparan
                        shape: BoxShape.circle,
                        border: Border.all(color: textColor, width: 2), // Border lingkaran ikon oranye
                      ),
                      child: Icon(
                        iconData, // Menggunakan ikon yang diberikan
                        color: textColor, // Warna ikon oranye
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor, // Warna teks oranye
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan hasil pencarian
  Widget _buildSearchResults() {
    if (_searchResults.isEmpty && _searchText.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'Tidak ada hasil yang cocok untuk "$_searchText".',
            style: GoogleFonts.nunito(
              textStyle: TextStyle(fontSize: 16, color: _textColorSecondary),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    // Menggunakan ListView.builder untuk efisiensi
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.builder(
        shrinkWrap: true, // Penting agar tidak ada error unbounded height
        physics: const NeverScrollableScrollPhysics(), // Agar scroll CustomScrollView tetap berfungsi
        itemCount: _searchResults.length,
        itemBuilder: (context, index) {
          final item = _searchResults[index];
          String itemType = item['type'] == 'fitur' ? 'Fitur Utama' : (item['type'] == 'kategori' ? 'Kategori Edukasi' : 'Menu Lain');

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                // Navigasi langsung ke widget yang ditentukan di data _searchableItems
                if (item['targetWidget'] is Widget) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => item['targetWidget'] as Widget,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Widget target untuk "${item['title']}" tidak ditemukan.'),
                      backgroundColor: Colors.orange,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _textColorPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kategori: $itemType',
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 12,
                          color: _textColorSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}