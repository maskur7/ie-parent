import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Path gambar lokal yang diminta
  static const String _localImagePath = 'assets/images/bcalledukasi.jpg';

  // Define a data structure for articles for better organization
  final Map<String, List<Map<String, String>>> _articles = {
    'Terbaru': [
      // Kombinasi dari berbagai kategori sebagai "terbaru"
      {
        'category': 'Parenting',
        'title': 'Tips Mengasuh Anak agar Tidak Serakah',
        'subtitle': 'Cara mendidik anak sejak dini agar tidak egois dan berbagi.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.parenting.co.id/usia-sekolah/tips-mengasuh-anak-agar-tidak-serakah-20230623',
      },
      {
        'category': 'Kesehatan',
        'title': 'Manfaat Tidur Cukup untuk Kesehatan Mental Anak',
        'subtitle': 'Studi terbaru menunjukkan hubungan antara kualitas tidur dan kesehatan mental.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.alodokter.com/manfaat-tidur-cukup-bagi-kesehatan-mental-anak',
      },
      {
        'category': 'Pendidikan',
        'title': 'Strategi Belajar Efektif di Era Digital untuk Remaja',
        'subtitle': 'Memaksimalkan potensi belajar dengan teknologi dan gadget.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.kompas.com/edu/read/2023/10/26/100000271/strategi-belajar-efektif-di-era-digital',
      },
      {
        'category': 'Gaya Hidup',
        'title': 'Mengelola Stres pada Anak di Masa Pandemi',
        'subtitle': 'Tips praktis membantu anak menghadapi tekanan dan kecemasan.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.unicef.org/indonesia/stories/mengelola-stres-pada-anak-di-masa-pandemi',
      },
      {
        'category': 'Pola Makan',
        'title': 'Panduan Gizi Seimbang untuk Anak Usia Sekolah',
        'subtitle': 'Memastikan asupan nutrisi optimal untuk tumbuh kembang anak.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.nutriclub.co.id/article/panduan-gizi-seimbang-anak-usia-sekolah',
      },
    ],
    'Parenting': [
      {
        'category': 'Parenting',
        'title': 'Membangun Kemandirian Anak Sejak Dini',
        'subtitle': 'Langkah-langkah praktis agar anak lebih mandiri dalam keseharian.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.parenting.co.id/usia-balita/membangun-kemandirian-anak-sejak-dini-20230620',
      },
      {
        'category': 'Parenting',
        'title': 'Menghadapi Tantrum Anak dengan Tenang',
        'subtitle': 'Strategi efektif untuk merespons ledakan emosi anak tanpa frustrasi.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.alodokter.com/cara-menghadapi-anak-tantrum',
      },
      {
        'category': 'Parenting',
        'title': 'Pentingnya Komunikasi Positif dengan Anak Remaja',
        'subtitle': 'Membangun hubungan kuat dan saling percaya dengan anak.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.ayahbunda.co.id/remaja/pentingnya-komunikasi-positif-dengan-anak-remaja-20220921',
      },
      {
        'category': 'Parenting',
        'title': 'Tips Mengatasi Anak Sulit Makan',
        'subtitle': 'Solusi kreatif agar anak mau makan dan tercukupi gizinya.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://hellosehat.com/parenting/nutrisi-anak/makanan-sehat-untuk-anak/cara-mengatasi-anak-susah-makan/',
      },
      {
        'category': 'Parenting',
        'title': 'Mengenali Tanda-tanda Kecanduan Gadget pada Anak',
        'subtitle': 'Dampak dan cara mencegah ketergantungan gadget pada anak.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.kompas.com/sains/read/2023/11/01/100000271/tanda-tanda-kecanduan-gadget-pada-anak',
      },
    ],
    'Pernikahan': [
      {
        'category': 'Pernikahan',
        'title': 'Tips Komunikasi Efektif dalam Pernikahan',
        'subtitle': 'Membangun fondasi hubungan yang kuat melalui komunikasi terbuka.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.psikologimania.com/tips-komunikasi-efektif-dalam-pernikahan/',
      },
      {
        'category': 'Pernikahan',
        'title': 'Mengatasi Konflik dalam Rumah Tangga secara Sehat',
        'subtitle': 'Cara menyelesaikan perbedaan pendapat tanpa merusak hubungan.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.ayahbunda.co.id/keluarga/mengatasi-konflik-dalam-rumah-tangga',
      },
      {
        'category': 'Pernikahan',
        'title': 'Pentingnya Kencan Malam bagi Pasangan Menikah',
        'subtitle': 'Membakar kembali romansa dan memperkuat ikatan hubungan.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.fimela.com/relationship/read/4200000/pentingnya-date-night-untuk-pasangan-menikah',
      },
      {
        'category': 'Pernikahan',
        'title': 'Manajemen Keuangan Keluarga: Tips untuk Pasangan',
        'subtitle': 'Mengatur keuangan bersama agar lebih stabil dan harmonis.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.cermati.com/artikel/manajemen-keuangan-keluarga-tips',
      },
      {
        'category': 'Pernikahan',
        'title': 'Peran Ayah dalam Pengasuhan Anak',
        'subtitle': 'Mengenali pentingnya keterlibatan ayah dalam tumbuh kembang anak.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.parenting.co.id/usia-sekolah/pentingnya-peran-ayah-dalam-pengasuhan-anak-20230715',
      },
    ],
    'Gaya Hidup': [
      {
        'category': 'Gaya Hidup',
        'title': 'Manfaat Hidup Minimalis untuk Kesejahteraan Mental',
        'subtitle': 'Mengurangi barang dapat menciptakan pikiran yang lebih jernih dan tenang.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.kompas.com/properti/read/2023/07/20/120000271/manfaat-hidup-minimalis-untuk-kesehatan-mental',
      },
      {
        'category': 'Gaya Hidup',
        'title': 'Dampak Positif Hobi Baru pada Kehidupan Sehari-hari',
        'subtitle': 'Menemukan minat baru dapat meningkatkan kualitas hidup dan mengurangi stres.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.hipwee.com/motivasi/manfaat-punya-hobi-baru/',
      },
      {
        'category': 'Gaya Hidup',
        'title': 'Pentingnya Aktivitas Fisik Rutin untuk Keluarga',
        'subtitle': 'Manfaat olahraga bersama untuk kesehatan fisik dan mental semua anggota keluarga.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.sehatq.com/artikel/pentingnya-aktivitas-fisik-rutin-untuk-kesehatan',
      },
      {
        'category': 'Gaya Hidup',
        'title': 'Cara Mengembangkan Kebiasaan Positif Setiap Hari',
        'subtitle': 'Mulai dari hal kecil, konsisten, dan nikmati proses perubahan diri.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.psychologytoday.com/us/blog/prescriptions-life/202210/how-to-develop-positive-habits',
      },
      {
        'category': 'Gaya Hidup',
        'title': 'Manajemen Waktu Efektif untuk Keseimbangan Hidup',
        'subtitle': 'Tips mengatur waktu agar produktif tanpa mengorbankan waktu pribadi.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.detik.com/edu/detik-edu/d-6400000/tips-manajemen-waktu-yang-efektif-untuk-pelajar-dan-mahasiswa',
      },
    ],
    'Kesehatan': [
      {
        'category': 'Kesehatan',
        'title': 'Cara Meningkatkan Imunitas Tubuh Secara Alami',
        'subtitle': 'Tips menjaga daya tahan tubuh agar tidak mudah sakit dan tetap bugar.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.halodoc.com/artikel/cara-meningkatkan-imunitas-tubuh-secara-alami',
      },
      {
        'category': 'Kesehatan',
        'title': 'Pentingnya Deteksi Dini Kanker pada Wanita',
        'subtitle': 'Langkah-langkah skrining untuk pencegahan dan penanganan lebih awal.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.klikdokter.com/info-sehat/kanker/pentingnya-deteksi-dini-kanker-pada-wanita',
      },
      {
        'category': 'Kesehatan',
        'title': 'Manfaat Yoga untuk Kesehatan Fisik dan Mental',
        'subtitle': 'Menggabungkan gerakan, pernapasan, dan meditasi untuk keseimbangan tubuh dan pikiran.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.alodokter.com/berbagai-manfaat-yoga-bagi-kesehatan',
      },
      {
        'category': 'Kesehatan',
        'title': 'Tips Mengatasi Insomnia dan Mendapatkan Tidur Berkualitas',
        'subtitle': 'Panduan untuk memperbaiki pola tidur dan mengatasi kesulitan tidur.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://hellosehat.com/hidup-sehat/tips-sehat/tips-mengatasi-insomnia/',
      },
      {
        'category': 'Kesehatan',
        'title': 'Pencegahan Penyakit Degeneratif Sejak Usia Muda',
        'subtitle': 'Gaya hidup sehat untuk menghindari penyakit seperti diabetes dan jantung.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.gooddoctor.co.id/artikel/pentingnya-mencegah-penyakit-degeneratif-sejak-muda',
      },
    ],
    'Pendidikan': [
      {
        'category': 'Pendidikan',
        'title': 'Pentingnya Pendidikan Karakter Sejak Usia Dini',
        'subtitle': 'Membentuk pribadi anak yang berakhlak mulia dan bertanggung jawab.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.kompas.com/edu/read/2022/08/17/100000271/pentingnya-pendidikan-karakter-sejak-usia-dini',
      },
      {
        'category': 'Pendidikan',
        'title': 'Memilih Jurusan Kuliah yang Tepat untuk Masa Depan',
        'subtitle': 'Panduan untuk menentukan pilihan pendidikan tinggi sesuai minat dan bakat.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.quipper.com/id/blog/tips-trick/campus/memilih-jurusan-kuliah-yang-tepat/',
      },
      {
        'category': 'Pendidikan',
        'title': 'Peran Orang Tua dalam Mendorong Minat Baca Anak',
        'subtitle': 'Menciptakan lingkungan yang mendukung kebiasaan membaca sejak kecil.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.ruangguru.com/blog/peran-orang-tua-dalam-meningkatkan-minat-baca-anak',
      },
      {
        'category': 'Pendidikan',
        'title': 'Manfaat Belajar Bahasa Asing untuk Perkembangan Otak',
        'subtitle': 'Dampak positif bilingualisme pada kognitif dan kemampuan berpikir.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.zenius.net/blog/manfaat-belajar-bahasa-asing',
      },
      {
        'category': 'Pendidikan',
        'title': 'Pendidikan Inklusi: Memahami Kebutuhan Belajar Beragam',
        'subtitle': 'Mendukung semua anak untuk belajar bersama tanpa diskriminasi.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.unicef.org/indonesia/press-releases/pendidikan-inklusi-indonesia',
      },
    ],
    'Pola Makan': [
      {
        'category': 'Pola Makan',
        'title': 'Diet Mediterania: Manfaat dan Cara Menerapkannya',
        'subtitle': 'Pola makan sehat yang terbukti mengurangi risiko penyakit kronis.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.alodokter.com/diet-mediterania-manfaat-dan-cara-menerapkannya',
      },
      {
        'category': 'Pola Makan',
        'title': 'Pentingnya Konsumsi Serat Harian untuk Pencernaan',
        'subtitle': 'Memahami peran serat dalam menjaga kesehatan saluran cerna.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.halodoc.com/artikel/pentingnya-serat-bagi-kesehatan-pencernaan',
      },
      {
        'category': 'Pola Makan',
        'title': 'Bahaya Konsumsi Gula Berlebih pada Anak',
        'subtitle': 'Dampak negatif gula terhadap kesehatan jangka panjang dan cara menguranginya.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://hellosehat.com/nutrisi/gizi-buruk/gula-berlebih-pada-anak/',
      },
      {
        'category': 'Pola Makan',
        'title': 'Mengenal Makanan Probiotik dan Prebiotik untuk Usus Sehat',
        'subtitle': 'Peran bakteri baik dalam menjaga kesehatan pencernaan dan imunitas.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.klikdokter.com/info-sehat/nutrisi/mengenal-makanan-probiotik-dan-prebiotik',
      },
      {
        'category': 'Pola Makan',
        'title': 'Tips Memulai Diet Sehat yang Berkelanjutan',
        'subtitle': 'Fokus pada perubahan gaya hidup, bukan hanya penurunan berat badan.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.sehatq.com/artikel/cara-memulai-diet-sehat-dan-berkelanjutan',
      },
    ],
    'Pariwisata': [
      {
        'category': 'Pariwisata',
        'title': 'Destinasi Wisata Keluarga Terbaik di Yogyakarta',
        'subtitle': 'Menjelajahi keindahan dan keunikan kota budaya bersama keluarga.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.traveloka.com/id-id/explore/destination/wisata-keluarga-jogja/65251',
      },
      {
        'category': 'Pariwisata',
        'title': 'Tips Liburan Hemat dan Menyenangkan Bersama Anak',
        'subtitle': 'Cara merencanakan perjalanan yang ramah anggaran dan tetap berkesan.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.orami.co.id/magazine/tips-liburan-hemat-bersama-anak',
      },
      {
        'category': 'Pariwisata',
        'title': 'Tempat Wisata Edukasi Anak di Jakarta yang Wajib Dikunjungi',
        'subtitle': 'Rekreasi sambil belajar di berbagai museum dan pusat sains.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.kompas.com/travel/read/2023/05/20/100000271/tempat-wisata-edukasi-anak-di-jakarta',
      },
      {
        'category': 'Pariwisata',
        'title': 'Manfaat Wisata Alam untuk Perkembangan Anak',
        'subtitle': 'Mengenalkan anak pada lingkungan dan aktivitas outdoor.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.parenting.co.id/usia-sekolah/manfaat-wisata-alam-untuk-perkembangan-anak-20230801',
      },
      {
        'category': 'Pariwisata',
        'title': 'Ide Aktivitas Liburan Seru di Rumah Bersama Keluarga',
        'subtitle': 'Menjelajahi kreativitas dan kebersamaan tanpa harus bepergian jauh.',
        // *DIGANTI KE GAMBAR LOKAL*
        'imageUrl': _localImagePath,
        'linkUrl': 'https://www.orami.co.id/magazine/aktivitas-liburan-seru-di-rumah-bersama-keluarga',
      },
    ],
  };

  // Define color palette (consistent with ProfileScreen)
  final Color _appBarBackgroundColor = const Color.fromARGB(255, 30, 104, 214);
  final Color _backgroundColor = const Color(0xFFF4F7FE); // Keep this for body background
  final Color _textColorLight = Colors.white; // Used for text on dark backgrounds
  final Color _primaryColor = const Color(0xFF4A90E2); // To be consistent with theme primary color

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _articles.keys.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Fungsi untuk membuka URL ---
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          throw 'Tidak dapat membuka $url';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan saat membuka tautan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool> _showConfirmationDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Buka Tautan Eksternal", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            content: Text(
                "Anda akan diarahkan ke halaman luar aplikasi. Lanjutkan?",
                style: GoogleFonts.nunito()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor, // Use primary color for action button
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Lanjutkan", style: GoogleFonts.poppins(color: _textColorLight)),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _confirmAndLaunch(String url) async {
    final bool confirm = await _showConfirmationDialog();
    if (confirm) {
      _launchURL(url);
    }
  }
  // --- Akhir Fungsi untuk membuka URL ---

  // --- Widget Card Artikel ---
  Widget _buildArticleCard({
    required String category,
    required String title,
    required String subtitle,
    required String imageUrl,
    required String linkUrl,
  }) {
    // Ukuran gambar yang konsisten
    const double imageSize = 90; 
    
    // Penambahan pengecekan untuk gambar lokal/network (walaupun saat ini hanya lokal)
    Widget imageWidget;
    if (imageUrl.startsWith('http') || imageUrl.startsWith('https')) {
      // Jika suatu saat ingin menggunakan gambar network lagi
      imageWidget = Image.network(
        imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: imageSize,
          height: imageSize,
          color: Colors.grey[200],
          child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40),
        ),
      );
    } else {
      // *PERUBAHAN UTAMA: Menggunakan Image.asset*
      imageWidget = Image.asset(
        imageUrl,
        width: imageSize,
        height: imageSize,
        fit: BoxFit.cover,
        // Error builder disarankan untuk Image.asset juga, jika path salah
        errorBuilder: (context, error, stackTrace) => Container(
          width: imageSize,
          height: imageSize,
          color: Colors.grey[200],
          child: Icon(Icons.image_not_supported, color: Colors.red, size: 40),
        ),
      );
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _confirmAndLaunch(linkUrl),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageWidget, // Menggunakan widget gambar yang sudah ditentukan
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: _primaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(color: Colors.grey[700], fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Ketuk untuk membuka artikel di browser.",
                      style: GoogleFonts.nunito(
                        textStyle: TextStyle(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
  // --- Akhir Widget Card Artikel ---

  Widget _buildTabContent(String tab) {
    List<Map<String, String>> articlesData = _articles[tab] ?? [];
    if (articlesData.isEmpty) {
      return Center(
        child: Text(
          'Belum ada artikel untuk kategori "$tab".',
          style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: articlesData.length,
      itemBuilder: (context, index) {
        final article = articlesData[index];
        return _buildArticleCard(
          category: article['category']!,
          title: article['title']!,
          subtitle: article['subtitle']!,
          imageUrl: article['imageUrl']!,
          linkUrl: article['linkUrl']!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: _backgroundColor, // Menggunakan variabel warna konsisten
      appBar: AppBar(
        title: Text(
          "Materi Edukasi",
          style: GoogleFonts.poppins( // Menggunakan GoogleFonts untuk judul
            textStyle: TextStyle(
              fontWeight: FontWeight.bold,
              color: _textColorLight, // Set title color to white
            ),
          ),
        ),
        backgroundColor: _appBarBackgroundColor, // Menggunakan warna baru yang diminta
        elevation: 0, // Hapus elevasi agar tampilan lebih bersih
        leading: canPop
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: _textColorLight), // Warna ikon back putih
                onPressed: () => Navigator.pop(context),
              )
            : null,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: _textColorLight, // Warna teks tab terpilih (putih)
          unselectedLabelColor: _textColorLight.withOpacity(0.7), // Warna teks tab tidak terpilih
          indicatorColor: _textColorLight, // Warna indikator tab (putih)
          indicatorSize: TabBarIndicatorSize.label,
          tabs: _articles.keys.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _articles.keys.map((tab) => _buildTabContent(tab)).toList(),
      ),
    );
  }
}