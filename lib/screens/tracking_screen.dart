// lib/screens/tracking_screen.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Model & service (pastikan path sesuai projectmu)
import '../models/plan.dart';
import '../models/learning_style_result.dart';
import '../services/plan_service.dart';
import '../services/learning_style_service.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  final PlanService _planService = PlanService();
  final LearningStyleService _styleService = LearningStyleService();

  List<Plan> _plans = [];
  LearningStyleResult? _styleResult;
  bool _isLoading = true;

  // Grafik: 7 titik (H-6 ... Hari ini). Akan di-update setelah load data.
  List<FlSpot> _progressSpots = List.generate(7, (i) => FlSpot(i.toDouble(), 0));

  // Checklist harian (dummy / presentational). Kamu bisa ganti pengambilan dari DB nanti.
  List<Map<String, dynamic>> _dailyChecklist = [
    {'label': 'Belajar 30 menit', 'completed': false},
    {'label': 'Mengerjakan tugas sekolah', 'completed': false},
    {'label': 'Membaca materi edukasi', 'completed': false},
  ];

  // Konfirmasi pelaksanaan plan (fitur yang kamu minta)
  bool _isPlanCompleted = false;

  // Nilai untuk perhitungan
  double _varkScore = 0.0; // 0..100 (jika ada hasil VARK maka 100)
  double _planScore = 0.0; // 0 atau 100 berdasarkan konfirmasi
  double _totalProgress = 0.0; // (vark * 0.5) + (plan * 0.5)

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'id_ID';
    _loadTrackingData();
  }

  Future<void> _loadTrackingData() async {
    setState(() => _isLoading = true);

    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      debugPrint("User belum login -> tidak dapat memuat data tracking.");
      setState(() => _isLoading = false);
      return;
    }

    try {
      // Ambil rencana belajar (sesuai service yang sudah ada)
      final plans = await _planService.fetchPlans();

      // Ambil hasil tes gaya belajar terbaru (service-mu menerima userId)
      final result = await _styleService.fetchLatestResult(userId);

      // VARK: jika ada hasil tes maka kita tetapkan 100 (sesuai kebijakan kamu)
      final double vark = result != null ? 100.0 : 0.0;

      // Plan: nilai diambil dari konfirmasi checkbox (user menandai seluruh plan selesai)
      final double plan = _isPlanCompleted ? 100.0 : 0.0;

      // Hitung total progress
      final double total = ((vark.clamp(0.0, 100.0) * 0.5) + (plan.clamp(0.0, 100.0) * 0.5)).clamp(0.0, 100.0);

      // Bangun grafik: pakai history sederhana — kita isi 7 titik dengan variasi
      // titik hari ini (index 6) diset ke total, yang lain diisi baseline dari vark dan plan
      List<FlSpot> spots = List.generate(7, (i) {
        // buat variasi sederhana: kombinasi vark dan plan, naik sedikit setiap hari
        // untuk hari ini set tepat total
        if (i == 6) return FlSpot(i.toDouble(), total);
        // untuk hari sebelumnya gunakan rata-rata vark dan (plan*0.5) terdistribusi
        final double simulatedPlanPart = (_isPlanCompleted ? 100.0 : 0.0) * 0.5 * (0.7 + i * 0.04);
        final double simulatedVarkPart = vark * 0.5;
        final double val = (simulatedVarkPart + simulatedPlanPart).clamp(0.0, 100.0);
        return FlSpot(i.toDouble(), val);
      });

      setState(() {
        _plans = plans;
        _styleResult = result;
        _varkScore = vark;
        _planScore = plan;
        _totalProgress = total;
        _progressSpots = spots;
      });
    } catch (e, st) {
      debugPrint('Error loadTrackingData: $e\n$st');
      // fallback: set semua ke 0 agar UI tidak crash
      setState(() {
        _plans = [];
        _styleResult = null;
        _varkScore = 0;
        _planScore = _isPlanCompleted ? 100.0 : 0.0;
        _totalProgress = ((_varkScore * 0.5) + (_planScore * 0.5));
        _progressSpots = List.generate(7, (i) => FlSpot(i.toDouble(), _totalProgress));
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat data tracking: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // toggle konfirmasi pelaksanaan plan (checkbox utama)
  void _togglePlanConfirmation(bool? val) {
    setState(() {
      _isPlanCompleted = val == true;
      _planScore = _isPlanCompleted ? 100.0 : 0.0;
      _totalProgress = ((_varkScore * 0.5) + (_planScore * 0.5)).clamp(0.0, 100.0);
      // update titik hari ini pada grafik
      _updateTodaySpot(_totalProgress);
    });
  }

  void _updateTodaySpot(double value) {
    setState(() {
      if (_progressSpots.length < 7) {
        _progressSpots = List.generate(7, (i) => FlSpot(i.toDouble(), value));
      } else {
        _progressSpots = _progressSpots.map((s) {
          if (s.x.toInt() == 6) return FlSpot(s.x, value);
          return s;
        }).toList();
      }
    });
  }

  // toggle lokal checklist harian
  void _toggleChecklistLocal(int index) {
    setState(() {
      _dailyChecklist[index]['completed'] = !_dailyChecklist[index]['completed'];
    });
  }

  // ---------- UI Helper ----------
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1565C0)),
      ),
    );
  }

  Widget _emptyMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.blueGrey.shade50, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.blueGrey.shade400),
          const SizedBox(width: 12),
          Expanded(child: Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.blueGrey.shade700))),
        ],
      ),
    );
  }

  Widget _getLearningStyleBadge(String style) {
    IconData iconData;
    Color badgeColor;

    switch (style.toLowerCase()) {
      case "visual":
        iconData = FontAwesomeIcons.eye;
        badgeColor = Colors.purple.shade500;
        break;
      case "auditori":
      case "auditory":
        iconData = FontAwesomeIcons.earListen;
        badgeColor = Colors.orange.shade500;
        break;
      case "baca/tulis":
      case "read/write":
        iconData = FontAwesomeIcons.bookOpen;
        badgeColor = Colors.blue.shade500;
        break;
      case "kinestetik":
      case "kinesthetic":
        iconData = FontAwesomeIcons.personWalking;
        badgeColor = Colors.green.shade500;
        break;
      default:
        iconData = Icons.help_outline;
        badgeColor = Colors.grey.shade500;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: badgeColor.withOpacity(0.12),
        border: Border.all(color: badgeColor.withOpacity(0.4)),
      ),
      child: Icon(iconData, color: badgeColor, size: 34),
    );
  }

  Widget _styleResultCard() {
    if (_styleResult == null) return _emptyMessage("Belum ada hasil tes gaya belajar.");

    final learningStyleName = _styleResult!.result;
    final createdAt = _styleResult!.createdAt;

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      margin: const EdgeInsets.only(bottom: 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
            child: Row(
              children: [
                _getLearningStyleBadge(learningStyleName),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Gaya Belajar Anak Anda", style: TextStyle(fontSize: 14, color: Colors.blue.shade700)),
                    const SizedBox(height: 6),
                    Text(learningStyleName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.blue.shade800)),
                    const SizedBox(height: 6),
                    Text("Tanggal tes: ${DateFormat('dd MMMM yyyy').format(createdAt.toLocal())}", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Catatan:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text("Nilai VARK: 100 (metode: apabila hasil tes ada, nilai VARK dianggap 100%)", style: TextStyle(color: Colors.grey.shade800)),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(Plan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: ListTile(
        leading: const Icon(Icons.star, color: Colors.amber),
        title: Text(plan.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(plan.description),
        trailing: Text(DateFormat('dd MMM yyyy').format(plan.createdAt.toLocal()), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
      ),
    );
  }

  Widget _buildLineChart() {
    final spots = _progressSpots.isNotEmpty ? _progressSpots : List.generate(7, (i) => FlSpot(i.toDouble(), _totalProgress));
    return Container(
      height: 260,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Skor Rata-rata Mingguan (%)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 8),
          Expanded(
            child: LineChart(LineChartData(
              minX: 0,
              maxX: 6,
              minY: 0,
              maxY: 100,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 20, getTitlesWidget: (v, m) => Text(v.toInt().toString(), style: const TextStyle(fontSize: 10, color: Colors.black54)), reservedSize: 30)),
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, interval: 1, getTitlesWidget: (v, m) {
                  const style = TextStyle(fontSize: 10, color: Colors.black54);
                  switch (v.toInt()) {
                    case 0:
                      return SideTitleWidget(axisSide: m.axisSide, child: const Text('H-6', style: style));
                    case 1:
                      return SideTitleWidget(axisSide: m.axisSide, child: const Text('H-5', style: style));
                    case 2:
                      return SideTitleWidget(axisSide: m.axisSide, child: const Text('H-4', style: style));
                    case 3:
                      return SideTitleWidget(axisSide: m.axisSide, child: const Text('H-3', style: style));
                    case 4:
                      return SideTitleWidget(axisSide: m.axisSide, child: const Text('H-2', style: style));
                    case 5:
                      return SideTitleWidget(axisSide: m.axisSide, child: const Text('Kemarin', style: style));
                    case 6:
                      return SideTitleWidget(axisSide: m.axisSide, child: const Text('Hari ini', style: style));
                    default:
                      return SideTitleWidget(axisSide: m.axisSide, child: const Text('', style: style));
                  }
                }, reservedSize: 36)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              gridData: FlGridData(show: true, horizontalInterval: 20, getDrawingHorizontalLine: (v) => FlLine(color: Colors.grey.shade200)),
              borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.shade300)),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 3.5,
                  color: const Color(0xFF1976D2),
                  belowBarData: BarAreaData(show: true, color: const Color(0xFF1976D2).withOpacity(0.12)),
                  dotData: FlDotData(show: true),
                ),
              ],
            )),
          ),
          const SizedBox(height: 8),
          Center(child: Text("Total Progres (VARK 50% + Plan 50%): ${_totalProgress.toStringAsFixed(1)}%", style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _checklistTile(String label, bool completed, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(color: completed ? Colors.green.shade50 : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: completed ? Colors.green.shade200 : Colors.grey.shade300)),
        child: Row(children: [
          Icon(completed ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded, color: completed ? Colors.green.shade700 : Colors.blueGrey),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 15, color: completed ? Colors.green.shade800 : Colors.black87))),
        ]),
      ),
    );
  }

  // ---------- BUILD ----------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Tracking Perkembangan"),
        backgroundColor: const Color(0xFF1976D2),
        elevation: 3,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1565C0)))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _sectionTitle("🧠 Hasil Tes Gaya Belajar"),
                _styleResultCard(),
                const SizedBox(height: 20),
                _sectionTitle("🎯 Rencana Belajar Aktif"),
                _plans.isEmpty ? _emptyMessage("Belum ada rencana belajar aktif. Buat di halaman 'Plan'.") : Column(children: _plans.map((p) => _buildPlanCard(p)).toList()),
                const SizedBox(height: 20),
                _sectionTitle("📈 Grafik Progres Belajar"),
                _buildLineChart(),
                const SizedBox(height: 16),
                _sectionTitle("✅ Konfirmasi Pelaksanaan Plan"),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6)]),
                  child: Row(
                    children: [
                      Expanded(child: Text("Apakah Anda sudah melaksanakan seluruh rencana belajar hari ini? Jika ya, centang untuk konfirmasi (Plan = 50%).", style: TextStyle(color: Colors.grey.shade800))),
                      Checkbox(value: _isPlanCompleted, onChanged: _togglePlanConfirmation)
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _sectionTitle("📝 Checklist Harian"),
                ..._dailyChecklist.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final item = entry.value;
                  return _checklistTile(item['label'], item['completed'], () => _toggleChecklistLocal(idx));
                }).toList(),
                const SizedBox(height: 24),
              ]),
            ),
    );
  }
}
