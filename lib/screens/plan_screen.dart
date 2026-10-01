// lib\screens\plan_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

// Asumsi model Plan dan PlanService Anda sudah benar
import '../models/plan.dart';
import '../services/plan_service.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({super.key});

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  final PlanService _service = PlanService();
  List<Plan> _plans = [];
  bool _isLoading = true;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  final List<String> _categories = [
    'Matematika',
    'Bahasa Inggris',
    'Sains',
    'Seni',
    'Sejarah',
    'Komputer',
    'Olahraga',
    'Lainnya'
  ];
  final List<String> _difficultyLevels = ['Mudah', 'Sedang', 'Sulit'];

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    Intl.defaultLocale = 'id_ID';
    loadPlans();
  }

// -----------------------------------------------------------------
// FUNGSI NOTIFIKASI
// -----------------------------------------------------------------

  Future<void> _initializeNotifications() async {
    // Inisialisasi TimeZone ke lokasi lokal (Asia/Jakarta)
    tzdata.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initSettingsAndroid);

    // Meminta izin notifikasi (wajib untuk Android 13+)
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _cancelNotification(int planId) async {
    await flutterLocalNotificationsPlugin.cancel(planId);
  }

  // FUNGSI NOTIFIKASI 1 JAM SEBELUM PELAKSANAAN
  Future<void> _scheduleNotification(Plan plan) async {
    // Hanya jadwalkan jika ada tenggat dan belum selesai
    if (plan.dueDate == null || plan.isCompleted) return;

    final int notificationId = plan.id;

    // Hitung waktu 1 jam sebelum tenggat (pastikan menggunakan zona waktu lokal)
    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      plan.dueDate!,
      tz.local,
    ).subtract(const Duration(hours: 1)); // PENGURANGAN TEPAT 1 JAM

    // Jangan jadwalkan jika waktu pengingat sudah terlewat
    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      '🔔 Pengingat Rencana Belajar',
      'Segera selesaikan "${plan.title}" (Kategori: ${plan.category})! Tenggat dalam 1 jam.',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'plan_reminder_channel',
          'Pengingat Rencana',
          channelDescription: 'Notifikasi pengingat rencana belajar',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
// -----------------------------------------------------------------
// FUNGSI CRUD & DATA
// -----------------------------------------------------------------

  Future<void> loadPlans() async {
    setState(() => _isLoading = true);

    final List<Plan> oldPlans = List.from(_plans);

    try {
      _plans = await _service.fetchPlans();
      _plans.sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        // Urutkan yang belum selesai di depan
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return a.dueDate!.compareTo(b.dueDate!);
      });

      // Batalkan notifikasi lama sebelum menjadwalkan yang baru
      for (var plan in oldPlans) {
        await _cancelNotification(plan.id);
      }

      // Jadwalkan notifikasi untuk semua rencana yang belum selesai
      for (var plan in _plans) {
        await _scheduleNotification(plan);
      }

    } catch (e) {
      if (mounted) {
        // NOTIFIKASI GAGAL MUAT DATA
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat rencana belajar. Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      _plans = [];
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _deletePlan(int planId) async {
    try {
      await _service.deletePlan(planId);
      await _cancelNotification(planId); // Batalkan notifikasi
      if (mounted) {
        // NOTIFIKASI BERHASIL HAPUS
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rencana berhasil dihapus!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      loadPlans(); // Muat ulang daftar rencana
    } catch (e) {
      if (mounted) {
        // NOTIFIKASI GAGAL HAPUS
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal menghapus rencana: ${e.toString()}')),
        );
      }
    }
  }

  void _showDeleteConfirmation(Plan plan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Rencana'),
          content: Text('Anda yakin ingin menghapus rencana "${plan.title}"? Aksi ini tidak dapat dibatalkan.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _deletePlan(plan.id); // Panggil fungsi hapus
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showForm({Plan? plan}) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        final titleController = TextEditingController(text: plan?.title);
        final descController = TextEditingController(text: plan?.description);
        String? selectedCategory = plan?.category;
        String? selectedDifficulty = plan?.difficultyLevel;
        DateTime? selectedDueDate = plan?.dueDate;
        double currentPriority = (plan?.priority ?? 0).toDouble();

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            plan == null ? 'Tambah Rencana Baru' : 'Edit Rencana Belajar',
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStateInDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Judul Rencana',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon: const Icon(Icons.title, color: Colors.indigo),
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.05),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: descController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi Detail',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon:
                            const Icon(Icons.description, color: Colors.indigo),
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.05),
                      ),
                      maxLines: 3,
                      minLines: 1,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: 'Kategori',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon:
                            const Icon(Icons.category, color: Colors.indigo),
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.05),
                      ),
                      items: _categories
                          .map((cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (value) {
                        setStateInDialog(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedDifficulty,
                      decoration: InputDecoration(
                        labelText: 'Tingkat Kesulitan',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        prefixIcon:
                            const Icon(Icons.insights, color: Colors.indigo),
                        filled: true,
                        fillColor: Colors.blueGrey.withOpacity(0.05),
                      ),
                      items: _difficultyLevels
                          .map((diff) =>
                              DropdownMenuItem(value: diff, child: Text(diff)))
                          .toList(),
                      onChanged: (value) {
                        setStateInDialog(() {
                          selectedDifficulty = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // INPUT TANGGAL DAN WAKTU (showDatePicker diikuti showTimePicker)
                    GestureDetector(
                      onTap: () async {
                        final DateTime today = DateTime.now();
                        final DateTime normalizedToday =
                            DateTime(today.year, today.month, today.day);
                        final DateTime initialDateForPicker =
                            selectedDueDate != null &&
                                    selectedDueDate!.isAfter(normalizedToday)
                                ? selectedDueDate!
                                : normalizedToday;

                        // 1. Pilih Tanggal
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: initialDateForPicker,
                          firstDate: normalizedToday,
                          lastDate: DateTime(2030),
                          builder: (context, child) {
                            return Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: Colors.indigo,
                                  onPrimary: Colors.white,
                                  onSurface: Colors.black,
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.indigo),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );

                        if (pickedDate != null) {
                           // 2. Pilih Jam
                           final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: selectedDueDate != null
                                ? TimeOfDay.fromDateTime(selectedDueDate!)
                                : TimeOfDay.now(),
                           );

                           if (pickedTime != null) {
                              setStateInDialog(() {
                                // 3. Gabungkan Tanggal dan Jam
                                selectedDueDate = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour, 
                                  pickedTime.minute,
                                );
                              });
                           }
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: TextEditingController(
                            // TAMPILKAN FORMAT TANGGAL DAN JAM DI TEXTFIELD FORM
                            text: selectedDueDate != null
                                ? DateFormat('EEEE, dd MMMM yyyy, HH:mm')
                                    .format(selectedDueDate!)
                                : 'Pilih tanggal dan jam tenggat',
                          ),
                          decoration: InputDecoration(
                            labelText: 'Tenggat Waktu',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.calendar_today,
                                color: Colors.indigo),
                            suffixIcon: const Icon(Icons.arrow_drop_down,
                                color: Colors.indigo),
                            filled: true,
                            fillColor: Colors.blueGrey.withOpacity(0.05),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Prioritas',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo)),
                        Slider(
                          value: currentPriority,
                          min: 0,
                          max: 5,
                          divisions: 5,
                          label: _getPriorityText(currentPriority.round()),
                          onChanged: (double value) {
                            setStateInDialog(() {
                              currentPriority = value;
                            });
                          },
                          activeColor: Colors.indigo,
                          inactiveColor: Colors.indigo.withOpacity(0.3),
                          thumbColor: Colors.indigoAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Batal', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text;
                final desc = descController.text;

                if (title.isEmpty || desc.isEmpty) {
                  // NOTIFIKASI VALIDASI GAGAL
                  ScaffoldMessenger.of(dialogContext).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Judul dan Deskripsi tidak boleh kosong!')),
                  );
                  return;
                }

                try {
                  String successMessage = ''; 

                  if (plan != null) {
                    await _cancelNotification(plan.id);
                  }

                  Plan savedPlan;
                  if (plan == null) {
                    // Operasi Tambah Rencana
                    savedPlan = await _service.addPlan(
                      title,
                      desc,
                      selectedCategory,
                      selectedDifficulty,
                      selectedDueDate,
                      currentPriority.round(),
                    );
                    successMessage = 'Rencana baru berhasil ditambahkan!';
                  } else {
                    // Operasi Edit Rencana
                    await _service.updatePlan(
                      plan.id,
                      title,
                      desc,
                      selectedCategory,
                      selectedDifficulty,
                      selectedDueDate,
                      currentPriority.round(),
                    );
                    savedPlan = Plan(
                      id: plan.id,
                      title: title,
                      description: desc,
                      category: selectedCategory,
                      difficultyLevel: selectedDifficulty,
                      priority: currentPriority.round(),
                      dueDate: selectedDueDate,
                      isCompleted: plan.isCompleted,
                      createdAt: plan.createdAt,
                      userId: plan.userId,
                    );
                    successMessage = 'Rencana berhasil diperbarui!';
                  }

                  // Jadwalkan ulang notifikasi pengingat 1 jam
                  await _scheduleNotification(savedPlan);

                  if (mounted) {
                    Navigator.pop(dialogContext);
                    loadPlans();
                    
                    // NOTIFIKASI BERHASIL TAMBAH/EDIT
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(successMessage),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    // NOTIFIKASI GAGAL TAMBAH/EDIT
                    ScaffoldMessenger.of(dialogContext).showSnackBar(
                      SnackBar(
                          content:
                              Text('Gagal menyimpan rencana: ${e.toString()}')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(plan == null ? 'Simpan Rencana' : 'Update Rencana',
                  style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

// -----------------------------------------------------------------
// HELPER WIDGETS & LOGIC
// -----------------------------------------------------------------

  String _getPriorityText(int priority) {
    switch (priority) {
      case 0: return 'Tidak ada';
      case 1: return 'Rendah';
      case 2: return 'Sedang';
      case 3: return 'Penting';
      case 4: return 'Sangat Penting';
      case 5: return 'Mendesak';
      default: return 'Tidak ada';
    }
  }

  Widget _buildPriorityIndicator(int priority) {
    Color color;
    String text;
    switch (priority) {
      case 0: color = Colors.blueGrey; text = 'Tidak ada'; break;
      case 1: color = Colors.lightGreen; text = 'Rendah'; break;
      case 2: color = Colors.orangeAccent; text = 'Sedang'; break;
      case 3: color = Colors.deepOrange; text = 'Penting'; break;
      case 4: color = Colors.redAccent; text = 'Sangat Penting'; break;
      case 5: color = Colors.red; text = 'Mendesak'; break;
      default: color = Colors.blueGrey; text = 'Tidak ada';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  IconData _getCategoryIcon(String? category) {
    switch (category) {
      case 'Matematika': return Icons.calculate;
      case 'Bahasa Inggris': return Icons.language;
      case 'Sains': return Icons.science;
      case 'Seni': return Icons.palette;
      case 'Sejarah': return Icons.museum;
      case 'Komputer': return Icons.computer;
      case 'Olahraga': return Icons.sports_baseball;
      default: return Icons.subject;
    }
  }

  IconData _getDifficultyIcon(String? difficulty) {
    switch (difficulty) {
      case 'Mudah': return Icons.sentiment_satisfied_alt;
      case 'Sedang': return Icons.sentiment_neutral;
      case 'Sulit': return Icons.sentiment_dissatisfied;
      default: return Icons.bar_chart;
    }
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          const SizedBox(width: 8),
          Text('$label: ',
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold)),
          Text(value,
              style: const TextStyle(fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

// -----------------------------------------------------------------
// BUILD METHOD
// -----------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text(
          'Rencana Belajar Anak',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: const Color.fromARGB(255, 30, 104, 214),
        elevation: 4,
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
          : _plans.isEmpty
              ? const Center(
                  child: Text(
                    "Belum ada rencana belajar yang ditambahkan.",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _plans.length + 1,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    // Item terakhir adalah padding extra agar tidak tertutup FAB
                    if (index == _plans.length) {
                      return const SizedBox(height: 80);
                    }
                    
                    final plan = _plans[index];
                    return Card(
                      elevation: 6,
                      margin: const EdgeInsets.only(bottom: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    plan.title,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: plan.isCompleted ? Colors.grey : Colors.deepPurple,
                                        decoration: plan.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                                    ),
                                  ),
                                ),
                                // PopupMenuButton untuk Edit/Hapus
                                PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showForm(plan: plan);
                                    } else if (value == 'delete') {
                                      _showDeleteConfirmation(plan);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit, color: Colors.indigo),
                                          SizedBox(width: 8),
                                          Text('Edit Rencana'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Hapus Rencana'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Baris Prioritas
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildPriorityIndicator(plan.priority ?? 0),
                                  const Spacer(),
                                ],
                            ),
                            const Divider(height: 24, thickness: 1),
                            Text(plan.description,
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.black87)),
                            const SizedBox(height: 12),
                            if (plan.category != null &&
                                plan.category!.isNotEmpty)
                              _buildInfoRow('Kategori', plan.category!,
                                  _getCategoryIcon(plan.category)),
                            if (plan.difficultyLevel != null &&
                                plan.difficultyLevel!.isNotEmpty)
                              _buildInfoRow('Kesulitan', plan.difficultyLevel!,
                                  _getDifficultyIcon(plan.difficultyLevel)),
                            if (plan.dueDate != null)
                              _buildInfoRow(
                                  'Tenggat Waktu',
                                  // TAMPILKAN TANGGAL DAN JAM
                                  DateFormat('dd MMMM yyyy, HH:mm')
                                      .format(plan.dueDate!),
                                  Icons.access_time),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Rencana',
            style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      // Posisi FAB di kanan bawah agar tidak menutupi item daftar
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}