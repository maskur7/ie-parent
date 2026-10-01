import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ieparentapp/services/learning_style_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestLearningStyleScreen extends StatefulWidget {
  const TestLearningStyleScreen({super.key});

  @override
  _TestLearningStyleScreenState createState() =>
      _TestLearningStyleScreenState();
}

// **PERHATIAN:** Kelas ini awalnya private, namun berisi widget
// yang Anda panggil dari luar file ini (seperti _buildResultSection).
// Jika kelas ini dipanggil dari luar package/library, Anda harus membuatnya public
// seperti yang disarankan warning 'Invalid use of a private type in a public API'.
// Namun, karena ini adalah State, kita biarkan private, tetapi kita akan
// memperbaiki penggunaan property shade.

class _TestLearningStyleScreenState extends State<TestLearningStyleScreen> {
  // Palet Warna yang Ditingkatkan (menggunakan Material Color untuk Shade)
  final Color _primaryColor =
      Colors.lightBlue.shade600; // Biru cerah (MaterialColor, mendukung shade)
  final Color _accentColor = Colors
      .blue.shade800; // Biru yang lebih dalam (MaterialColor, mendukung shade)
  final Color _cardColor = Colors.white;
  final Color _backgroundColor = const Color(0xFFE3F2FD);
  final Color _textColorPrimary = const Color(0xFF1A237E);
  final Color _textColorSecondary = const Color(0xFF546E7A);

  // List Pertanyaan (Tidak Berubah)
  final List<Map<String, dynamic>> questions = [
    // ... (Konten list questions tetap sama)
    // Visual questions
    {
      'question':
          'Apakah anak lebih mudah paham jika dijelaskan dengan bantuan gambar?',
      'type': 'visual'
    },
    {
      'question':
          'Apakah anak menyukai penyampaian informasi dalam bentuk diagram atau peta konsep?',
      'type': 'visual'
    },
    {
      'question':
          'Apakah anak lebih cepat mengerti saat melihat video atau presentasi visual?',
      'type': 'visual'
    },
    {
      'question':
          'Apakah anak sering memberi warna atau simbol khusus pada catatannya?',
      'type': 'visual'
    },
    {
      'question':
          'Apakah anak lebih tertarik pada buku yang penuh ilustrasi dibanding teks saja?',
      'type': 'visual'
    },
    {
      'question':
          'Apakah anak lebih memilih menonton video tutorial daripada membaca instruksi?',
      'type': 'visual'
    },
    {
      'question':
          'Apakah anak terlihat lebih fokus saat belajar menggunakan media visual?',
      'type': 'visual'
    },
    {
      'question':
          'Apakah anak sering menggunakan alat tulis warna-warni untuk menandai sesuatu?',
      'type': 'visual'
    },
    {
      'question': 'Apakah anak lebih mudah memahami materi melalui animasi?',
      'type': 'visual'
    },
    {
      'question':
          'Apakah anak suka membuat bagan atau alur gambar saat mengerjakan sesuatu?',
      'type': 'visual'
    },

    // Auditory questions
    {
      'question':
          'Apakah anak lebih cepat paham melalui penjelasan lisan secara langsung?',
      'type': 'auditory'
    },
    {
      'question':
          'Apakah anak menikmati mendengarkan dongeng, podcast, atau rekaman suara?',
      'type': 'auditory'
    },
    {
      'question':
          'Apakah anak tetap fokus belajar meski sambil mendengarkan musik?',
      'type': 'auditory'
    },
    {
      'question':
          'Apakah anak senang berdiskusi atau banyak bertanya untuk memahami sesuatu?',
      'type': 'auditory'
    },
    {
      'question':
          'Apakah anak sering bergumam atau mengulang kata saat sedang menghafal?',
      'type': 'auditory'
    },
    {
      'question':
          'Apakah anak peka terhadap perubahan nada dan intonasi suara orang lain?',
      'type': 'auditory'
    },
    {
      'question':
          'Apakah anak lebih efektif belajar melalui metode tanya jawab?',
      'type': 'auditory'
    },
    {
      'question': 'Apakah anak sangat mudah mengingat nada dan lirik lagu?',
      'type': 'auditory'
    },
    {
      'question':
          'Apakah anak baru paham suatu konsep setelah ia menceritakannya kembali?',
      'type': 'auditory'
    },
    {
      'question':
          'Apakah anak terbiasa membaca materi dengan suara yang lantang?',
      'type': 'auditory'
    },

    // Read/Write questions
    {
      'question':
          'Apakah anak lebih suka mencatat informasi secara rinci dalam bentuk tulisan?',
      'type': 'read_write'
    },
    {
      'question':
          'Apakah anak menunjukkan minat tinggi membaca buku cerita atau artikel?',
      'type': 'read_write'
    },
    {
      'question':
          'Apakah anak senang membuat daftar poin kegiatan (list) secara tertulis?',
      'type': 'read_write'
    },
    {
      'question':
          'Apakah anak lebih mudah ingat informasi jika sudah menuliskannya di kertas?',
      'type': 'read_write'
    },
    {
      'question':
          'Apakah anak sering membaca ulang teks untuk memahami isinya secara mendalam?',
      'type': 'read_write'
    },
    {
      'question':
          'Apakah anak lebih menyukai media teks dibanding media suara atau gambar?',
      'type': 'read_write'
    },
    {
      'question':
          'Apakah anak selalu mencari instruksi tertulis sebelum memulai tugas?',
      'type': 'read_write'
    },
    {
      'question':
          'Apakah anak suka membuat ringkasan singkat dari buku yang ia baca?',
      'type': 'read_write'
    },
    {
      'question':
          'Apakah anak mudah mengingat ejaan kata yang pernah ia tulis?',
      'type': 'read_write'
    },
    {
      'question':
          'Apakah anak merasa nyaman belajar menggunakan modul atau buku teks?',
      'type': 'read_write'
    },

    // Kinesthetic questions
    {
      'question':
          'Apakah anak lebih semangat belajar jika langsung mempraktikkan alat peraganya?',
      'type': 'kinesthetic'
    },
    {
      'question':
          'Apakah anak menyukai aktivitas tangan seperti membuat kerajinan atau lego?',
      'type': 'kinesthetic'
    },
    {
      'question':
          'Apakah anak mudah mengingat kejadian jika ia terlibat langsung secara fisik?',
      'type': 'kinesthetic'
    },
    {
      'question':
          'Apakah anak sering menggerakkan anggota tubuh saat sedang konsentrasi?',
      'type': 'kinesthetic'
    },
    {
      'question':
          'Apakah anak memiliki kebiasaan belajar sambil berjalan atau berpindah posisi?',
      'type': 'kinesthetic'
    },
    {
      'question':
          'Apakah anak cepat bosan jika diminta duduk diam dalam waktu lama?',
      'type': 'kinesthetic'
    },
    {
      'question':
          'Apakah anak sangat menikmati kegiatan bermain peran atau simulasi?',
      'type': 'kinesthetic'
    },
    {
      'question':
          'Apakah anak butuh jeda aktivitas fisik (lari/lompat) di sela waktu belajar?',
      'type': 'kinesthetic'
    },
    {
      'question':
          'Apakah anak ekspresif menggunakan gerakan tangan saat menjelaskan sesuatu?',
      'type': 'kinesthetic'
    },
    {
      'question':
          'Apakah anak lebih cepat paham melalui permainan yang melibatkan gerakan fisik?',
      'type': 'kinesthetic'
    },
  ];

  int currentQuestionIndex = 0;
  int visualScore = 0;
  int auditoryScore = 0;
  int readWriteScore = 0;
  int kinestheticScore = 0;
  bool testCompleted = false;

  Future<void> answerQuestion(int value) async {
    final currentQuestion = questions[currentQuestionIndex];
    final type = currentQuestion['type'];

    if (type == 'visual') {
      visualScore = (visualScore + value).clamp(0, 10);
    } else if (type == 'auditory') {
      auditoryScore = (auditoryScore + value).clamp(0, 10);
    } else if (type == 'read_write') {
      readWriteScore = (readWriteScore + value).clamp(0, 10);
    } else if (type == 'kinesthetic') {
      kinestheticScore = (kinestheticScore + value).clamp(0, 10);
    }

    setState(() {
      currentQuestionIndex++;
      if (currentQuestionIndex >= questions.length) {
        testCompleted = true;
      }
    });

    if (testCompleted) {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        final style = getLearningStyleName();
        final description = getResultDescription();

        try {
          await LearningStyleService().insertLearningStyle(
            user.id,
            style,
            description,
          );
          // Menggunakan `mounted` check untuk menghilangkan warning `use_build_context_synchronously`
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Gaya belajar berhasil disimpan! 🎉"),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          // Menggunakan interpolasi string untuk menghilangkan warning `prefer_interpolation_to_compose_strings`
          // Menggunakan `mounted` check untuk menghilangkan warning `use_build_context_synchronously`
          if (mounted) {
            // Mengganti print dengan ScaffoldMessenger (sesuai saran avoid_print)
            // Atau jika ingin tetap menggunakan print di development: print("Error saving learning style: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Gagal menyimpan gaya belajar: ${e.toString()}"),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } else {
        // Menggunakan `mounted` check
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text("Anda harus login untuk menyimpan gaya belajar. ⚠️"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  String getLearningStyleName() {
    Map<String, int> scores = {
      "Visual": visualScore,
      "Auditori": auditoryScore,
      "Baca/Tulis": readWriteScore,
      "Kinestetik": kinestheticScore,
    };

    String dominantStyle = "Tidak Diketahui";
    int maxScore = -1;

    scores.forEach((style, score) {
      if (score > maxScore) {
        maxScore = score;
        dominantStyle = style;
      } else if (score == maxScore) {
        // Logika tetap
      }
    });

    return dominantStyle;
  }

  // Widget Badge Hasil yang Diperbarui
  Widget getLearningStyleBadge(String style) {
    IconData iconData;
    Color badgeColor;

    switch (style.toLowerCase()) {
      case "visual":
        iconData = FontAwesomeIcons.eye;
        badgeColor = const Color(0xFF673AB7); // Deep Purple
        break;
      case "auditori":
        iconData = FontAwesomeIcons.earListen;
        badgeColor = const Color(0xFFF44336); // Red
        break;
      case "baca/tulis":
        iconData = FontAwesomeIcons.bookOpen;
        badgeColor = const Color(0xFF2196F3); // Blue
        break;
      case "kinestetik":
        iconData = FontAwesomeIcons.personWalking;
        badgeColor = const Color(0xFF4CAF50); // Green
        break;
      default:
        iconData = Icons.help_outline;
        badgeColor = Colors.grey;
    }

    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // **PERBAIKAN 1 & 2:** Mengganti Colors.shade800 dengan warna solid atau withOpacity
        // Asumsi warna yang diinginkan adalah versi yang lebih gelap
        gradient: RadialGradient(
          colors: [badgeColor.withOpacity(0.8), badgeColor],
          center: Alignment.topLeft,
          radius: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Icon(iconData, color: Colors.white, size: 60),
    );
  }

  List<String> _getCharacteristics(String style) {
    // ... (Logika tetap sama)
    switch (style) {
      case "Visual":
        return [
          'Lebih suka melihat gambar, warna, dan grafik.',
          'Senang menonton video atau presentasi visual.',
          'Suka membuat catatan berwarna, mind map, atau diagram.',
          'Belajar lebih cepat saat melihat informasi secara visual.'
        ];
      case "Auditori":
        return [
          'Mudah memahami dengan mendengarkan.',
          'Suka mendengar cerita, podcast, atau penjelasan verbal.',
          'Gemar berdiskusi dan berbicara tentang apa yang dipelajari.',
          'Cenderung mengulang informasi secara verbal.'
        ];
      case "Baca/Tulis":
        return [
          'Memahami pelajaran dengan menulis catatan secara rinci.',
          'Lebih mudah belajar dengan membaca buku atau artikel.',
          'Senang membuat daftar poin penting, ringkasan, atau transkrip.',
          'Sering membaca ulang materi untuk memahami isinya.'
        ];
      case "Kinestetik":
        return [
          'Belajar optimal melalui praktik langsung atau gerakan.',
          'Suka menyentuh, memegang, dan mencoba sendiri.',
          'Tidak bisa duduk diam terlalu lama.',
          'Sering menggunakan gerakan tubuh saat belajar.'
        ];
      default:
        return ["Tidak ada ciri-ciri yang ditentukan."];
    }
  }

  List<String> _getTips(String style) {
    // ... (Logika tetap sama)
    switch (style) {
      case "Visual":
        return [
          'Gunakan flashcard bergambar dan infografis.',
          'Manfaatkan video dan presentasi visual.',
          'Buat catatan dengan kode warna dan mind map.'
        ];
      case "Auditori":
        return [
          'Dengarkan podcast atau rekaman edukatif.',
          'Ajak anak berdiskusi dan bercerita ulang.',
          'Dorong anak untuk membaca materi keras-keras.'
        ];
      case "Baca/Tulis":
        return [
          'Dorong untuk membuat ringkasan dan catatan mendetail.',
          'Sediakan banyak bahan bacaan relevan dan terstruktur.',
          'Ajak anak menulis ulang informasi dengan kata-kata sendiri.'
        ];
      case "Kinestetik":
        return [
          'Gunakan alat peraga nyata dan eksperimen langsung.',
          'Sediakan waktu jeda aktivitas atau belajar sambil bergerak.',
          'Libatkan dalam permainan interaktif dan simulasi.'
        ];
      default:
        return ["Tidak ada tips yang ditentukan."];
    }
  }

  // Fungsi pembantu untuk mendapatkan deskripsi lengkap untuk database
  String getResultDescription() {
    final learningStyle = getLearningStyleName();
    final characteristics = _getCharacteristics(learningStyle);
    final tips = _getTips(learningStyle);

    // Menggunakan interpolasi string untuk menghilangkan warning `prefer_interpolation_to_compose_strings`
    String fullDescription = "Gaya belajar anak Anda adalah $learningStyle.\n\n"
        "Ciri-ciri Umum:\n"
        "${characteristics.map((c) => "- $c").join('\n')}\n\n"
        "Tips Belajar:\n"
        "${tips.map((t) => "- $t").join('\n')}";

    return fullDescription;
  }

  @override
  Widget build(BuildContext context) {
    final learningStyleName = getLearningStyleName();
    final characteristics = _getCharacteristics(learningStyleName);
    final tips = _getTips(learningStyleName);

    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          "Tes Gaya Belajar Anak",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w800,
              color: _cardColor,
              fontSize: 22,
            ),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              // **PERBAIKAN 3:** Mengganti _primaryColor.shade700
              colors: [_accentColor, _primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: testCompleted
            ? SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ... (Widget hasil tes lainnya tetap sama)
                      Text(
                        "Hasil Tes Gaya Belajar",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: _textColorPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Selamat! Ini adalah gaya belajar yang paling dominan.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(
                          textStyle: TextStyle(
                              fontSize: 16, color: _textColorSecondary),
                        ),
                      ),
                      const SizedBox(height: 30),
                      getLearningStyleBadge(learningStyleName),
                      const SizedBox(height: 30),

                      // Box utama untuk gaya belajar
                      Card(
                        elevation: 10,
                        shadowColor: _accentColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        margin: const EdgeInsets.only(bottom: 25),
                        color: _cardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            children: [
                              Text(
                                "Gaya Belajar Dominan:",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.nunito(
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      color: _textColorSecondary,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                learningStyleName.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: (learningStyleName == "Visual")
                                        ? const Color(0xFF673AB7)
                                        : (learningStyleName == "Auditori")
                                            ? const Color(0xFFF44336)
                                            : (learningStyleName ==
                                                    "Baca/Tulis")
                                                ? const Color(0xFF2196F3)
                                                : const Color(0xFF4CAF50),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Sub-container untuk Ciri-ciri Umum
                      _buildResultSection(
                        title: "Ciri-ciri Umum",
                        icon: Icons.lightbulb_outline,
                        color: Colors.green.shade600,
                        items: characteristics,
                      ),

                      // Sub-container untuk Tips
                      _buildResultSection(
                        title: "Strategi Belajar",
                        icon: Icons.school_outlined,
                        color: Colors.amber.shade700,
                        items: tips,
                      ),
                      const SizedBox(height: 10),

                      // Tombol Ulangi Tes
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            currentQuestionIndex = 0;
                            visualScore = 0;
                            auditoryScore = 0;
                            readWriteScore = 0;
                            kinestheticScore = 0;
                            testCompleted = false;
                          });
                        },
                        icon: const Icon(Icons.refresh, size: 24),
                        label: Text(
                          "Ulangi Tes",
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _accentColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
                          minimumSize: const Size(double.infinity, 0),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Progress Bar
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 12),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: LinearProgressIndicator(
                              value:
                                  (currentQuestionIndex + 1) / questions.length,
                              backgroundColor: Colors.grey[300],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(_primaryColor),
                              minHeight: 15,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Text(
                          "Pertanyaan ${currentQuestionIndex + 1} dari ${questions.length}",
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _textColorPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Container untuk isi pertanyaan
                  Expanded(
                    child: Card(
                      elevation: 10,
                      shadowColor: _primaryColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      margin: const EdgeInsets.only(bottom: 30),
                      color: _cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(35),
                        child: Center(
                          child: Text(
                            questions[currentQuestionIndex]['question'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: _textColorPrimary,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Container untuk tombol jawaban
                  Column(
                    children: [
                      _buildAnswerButton(
                        label: "Ya / Setuju",
                        icon: Icons.check_circle_outline,
                        color: const Color(0xFF4CAF50),
                        onPressed: () => answerQuestion(1),
                      ),
                      const SizedBox(height: 16),
                      _buildAnswerButton(
                        label: "Netral / Terkadang",
                        icon: Icons.horizontal_rule_rounded,
                        color: const Color(0xFFFF9800),
                        onPressed: () => answerQuestion(0),
                      ),
                      const SizedBox(height: 16),
                      _buildAnswerButton(
                        label: "Tidak / Tidak Setuju",
                        icon: Icons.cancel_outlined,
                        color: const Color(0xFFF44336),
                        onPressed: () => answerQuestion(-1),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  // Helper function for building consistent answer buttons (diperbarui)
  Widget _buildAnswerButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    // Menentukan warna gelap sebagai pengganti shade700
    Color darkerColor;
    if (color == const Color(0xFF4CAF50)) {
      // Green
      darkerColor = const Color(0xFF388E3C);
    } else if (color == const Color(0xFFFF9800)) {
      // Orange
      darkerColor = const Color(0xFFF57C00);
    } else if (color == const Color(0xFFF44336)) {
      // Red
      darkerColor = const Color(0xFFD32F2F);
    } else {
      darkerColor = color; // Default
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          // **PERBAIKAN 4:** Mengganti color.shade700! dengan darkerColor
          colors: [color.withOpacity(0.9), darkerColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(35),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28, color: Colors.white),
                const SizedBox(width: 15),
                Text(
                  label,
                  style: GoogleFonts.montserrat(
                    textStyle: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  // Widget baru untuk menampilkan hasil (Ciri-ciri & Tips)
  Widget _buildResultSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<String> items,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 20),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24, color: color),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _textColorPrimary),
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1, color: Color(0xFFE0E0E0)),
            ...items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Icon(Icons.arrow_right, size: 20, color: color),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item,
                          textAlign: TextAlign.left,
                          style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: _textColorPrimary),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
