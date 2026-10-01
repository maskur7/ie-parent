// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'education_screen.dart';
// import 'edukasi_hamil_screen.dart';
// import 'edukasi_anak_screen.dart';
// import 'package:google_fonts/google_fonts.dart'; // Tambahkan package untuk font yang lebih elegan

// class HomeContent extends StatefulWidget {
//   const HomeContent({super.key});

//   @override
//   State<HomeContent> createState() => _HomeContentState();
// }

// class _HomeContentState extends State<HomeContent> {
//   final TextEditingController _searchController = TextEditingController();

//   // Palette warna yang diperbarui untuk tampilan yang lebih modern dan elegan
//   final Color _primaryColor = const Color(0xFF64B5F6); // Biru muda yang segar
//   final Color _accentColor = const Color(0xFF1E88E5); // Biru yang lebih dalam untuk aksen
//   final Color _cardColor = Colors.white;
//   final Color _backgroundColor = const Color(0xFFF5F9FF); // Background lebih soft
//   final Color _textColorPrimary = const Color(0xFF2C3E50); // Dark blue-grey untuk teks utama
//   final Color _textColorSecondary = const Color(0xFF7F8C8D); // Slate untuk teks sekunder
  
//   // Warna untuk gradient dan aksen
//   final Color _gradientStart = const Color(0xFF64B5F6);
//   final Color _gradientEnd = const Color(0xFF1E88E5);

//   void _handleSearch(String query) {
//     print('Mencari: $query');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Hasil pencarian untuk: $query'),
//         backgroundColor: _accentColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(10),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           _buildSliverAppBar(),
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 8),
//                   _buildWelcomeSection(),
//                   const SizedBox(height: 16),
//                   _buildSearchBar(context),
//                   const SizedBox(height: 24),
//                   _buildSectionTitle("Promo & Info Terbaru"),
//                   const SizedBox(height: 12),
//                   _buildCarousel(),
//                   const SizedBox(height: 24),
//                   _buildSectionTitle("Fitur Utama"),
//                   const SizedBox(height: 12),
//                   _buildFiturUtama(context),
//                   const SizedBox(height: 24),
//                   _buildSectionTitle("Jelajahi Kategori"),
//                   const SizedBox(height: 12),
//                   _buildCategorySelector(context),
//                   const SizedBox(height: 24),
//                   _buildSectionTitle("Menu Lainnya"),
//                   const SizedBox(height: 12),
//                   _buildMenuGrid(context),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: _backgroundColor,
//     );
//   }

//   Widget _buildSliverAppBar() {
//     return SliverAppBar(
//       expandedHeight: 80.0,
//       floating: false,
//       pinned: true,
//       elevation: 0,
//       backgroundColor: _primaryColor,
//       flexibleSpace: FlexibleSpaceBar(
//         titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
//         title: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               "iE-Parent",
//               style: GoogleFonts.montserrat(
//                 textStyle: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   color: _cardColor,
//                   fontSize: 22,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         background: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [_gradientStart, _gradientEnd],
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.notifications_outlined, color: Colors.white),
//           onPressed: () {
//             // Notification action
//           },
//         ),
//         const SizedBox(width: 8),
//       ],
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Text(
//         title,
//         style: GoogleFonts.montserrat(
//           textStyle: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w600,
//             color: _textColorPrimary,
//             letterSpacing: 0.4,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWelcomeSection() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Card(
//         elevation: 0,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(16),
//           side: BorderSide(color: _primaryColor.withOpacity(0.2), width: 1),
//         ),
//         color: _cardColor,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "Halo Bunda!",
//                       style: GoogleFonts.montserrat(
//                         textStyle: TextStyle(
//                           fontSize: 24,
//                           fontWeight: FontWeight.w700,
//                           color: _textColorPrimary,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       "Semoga hari ini menyenangkan!",
//                       style: GoogleFonts.nunito(
//                         textStyle: TextStyle(
//                           fontSize: 16, 
//                           color: _textColorSecondary,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 height: 80,
//                 width: 80,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: _primaryColor.withOpacity(0.3),
//                       spreadRadius: 1,
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: Image.asset(
//                     'assets/images/parent_banner.jpg',
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: TextField(
//         controller: _searchController,
//         onChanged: _handleSearch,
//         decoration: InputDecoration(
//           hintText: 'Cari artikel, tips, atau lainnya...',
//           hintStyle: GoogleFonts.nunito(
//             textStyle: TextStyle(
//               fontSize: 14,
//               color: _textColorSecondary,
//             ),
//           ),
//           prefixIcon: Icon(Icons.search, color: _accentColor),
//           suffixIcon: Container(
//             margin: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: _primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: IconButton(
//               iconSize: 20,
//               padding: EdgeInsets.zero,
//               icon: Icon(Icons.photo_camera_outlined, color: _accentColor),
//               onPressed: () {
//                 print('Tombol kamera ditekan');
//               },
//             ),
//           ),
//           filled: true,
//           fillColor: _cardColor,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: _primaryColor.withOpacity(0.2), width: 1),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide(color: _primaryColor, width: 1.5),
//           ),
//           contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
//         ),
//         style: GoogleFonts.nunito(
//           textStyle: TextStyle(
//             fontSize: 14,
//             color: _textColorPrimary,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCarousel() {
//     final List<String> assetImages = [
//       'assets/images/slider1.jpg',
//       'assets/images/slider2.jpg',
//       'assets/images/slider3.jpg',
//     ];

//     return CarouselSlider(
//       options: CarouselOptions(
//         height: 180.0,
//         autoPlay: true,
//         enlargeCenterPage: true,
//         viewportFraction: 0.92,
//         aspectRatio: 16 / 9,
//         autoPlayCurve: Curves.easeInOutCubic,
//         autoPlayAnimationDuration: const Duration(milliseconds: 800),
//         enlargeFactor: 0.2,
//       ),
//       items: assetImages.map((path) {
//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 5.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: _accentColor.withOpacity(0.2),
//                 spreadRadius: 1,
//                 blurRadius: 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(16),
//             child: Stack(
//               children: [
//                 Image.asset(path, fit: BoxFit.cover, width: double.infinity),
//                 // Gradient overlay for better text visibility if needed
//                 Positioned.fill(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.3),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildFiturUtama(BuildContext context) {
//     final fiturList = [
//       {
//         'icon': Icons.psychology_rounded,
//         'title': "Tes Gaya Belajar",
//         'desc': "Kenali cara belajar anak",
//         'route': "/test",
//         'color': const Color(0xFFFF9800), // Orange
//         'bgColor': const Color(0xFFFFF3E0), // Light orange background
//       },
//       {
//         'icon': Icons.checklist_rounded,
//         'title': "Rencana Belajar",
//         'desc': "Atur jadwal belajar",
//         'route': "/plan",
//         'color': const Color(0xFF4CAF50), // Green
//         'bgColor': const Color(0xFFE8F5E9), // Light green background
//       },
//       {
//         'icon': Icons.bar_chart_rounded,
//         'title': "Tracking",
//         'desc': "Pantau kemajuan",
//         'route': "/tracking",
//         'color': _accentColor, // Blue accent
//         'bgColor': const Color(0xFFE3F2FD), // Light blue background
//       },
//       {
//         'icon': Icons.lightbulb_rounded,
//         'title': "Edukasi",
//         'desc': "Materi parenting",
//         'route': "/edukasi",
//         'color': const Color(0xFF9C27B0), // Purple
//         'bgColor': const Color(0xFFF3E5F5), // Light purple background
//       },
//     ];

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Card(
//         elevation: 2,
//         shadowColor: Colors.black26,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 2,
//               crossAxisSpacing: 16,
//               mainAxisSpacing: 16,
//               childAspectRatio: 1.1,
//             ),
//             itemCount: fiturList.length,
//             itemBuilder: (context, index) {
//               final item = fiturList[index];
//               final itemColor = item['color'] as Color;
//               final bgColor = item['bgColor'] as Color;
              
//               return GestureDetector(
//                 onTap: () {
//                   if (item['route'] == '/edukasi') {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => const Scaffold(
//                           body: EducationScreen(),
//                         ),
//                       ),
//                     );
//                   } else {
//                     Navigator.pushNamed(context, item['route'] as String);
//                   }
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: bgColor,
//                     borderRadius: BorderRadius.circular(20),
//                     boxShadow: [
//                       BoxShadow(
//                         color: itemColor.withOpacity(0.1),
//                         spreadRadius: 1,
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           shape: BoxShape.circle,
//                           boxShadow: [
//                             BoxShadow(
//                               color: itemColor.withOpacity(0.2),
//                               spreadRadius: 1,
//                               blurRadius: 6,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Icon(item['icon'] as IconData, color: itemColor, size: 32),
//                       ),
//                       const SizedBox(height: 12),
//                       Text(
//                         item['title'] as String,
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.montserrat(
//                           textStyle: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: itemColor,
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         item['desc'] as String,
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.nunito(
//                           textStyle: TextStyle(
//                             fontSize: 12,
//                             color: _textColorSecondary,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuGrid(BuildContext context) {
//     final List<Map<String, dynamic>> menuItems = [
//       {
//         'icon': Icons.dashboard_rounded,
//         'label': 'Lainnya',
//         'route': '/lainnya',
//         'color': const Color(0xFF03A9F4), // Light Blue
//       },
//       {
//         'icon': Icons.child_care_rounded,
//         'label': 'Pemantau',
//         'route': '/tracking',
//         'color': const Color(0xFFE91E63), // Pink
//       },
//       {
//         'icon': Icons.shopping_bag_rounded,
//         'label': 'Belanja',
//         'route': '/belanja',
//         'color': const Color(0xFF009688), // Teal
//       },
//       {
//         'icon': Icons.star_rounded,
//         'label': 'Platform',
//         'route': '/platform',
//         'color': const Color(0xFFFF5722), // Deep Orange
//       },
//     ];

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Card(
//         elevation: 2,
//         shadowColor: Colors.black26,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: GridView.count(
//             crossAxisCount: 4,
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             mainAxisSpacing: 12,
//             crossAxisSpacing: 12,
//             children: menuItems.map((item) {
//               return InkWell(
//                 onTap: () => Navigator.pushNamed(context, item['route']),
//                 borderRadius: BorderRadius.circular(12),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: (item['color'] as Color).withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(item['icon'], color: item['color'] as Color, size: 24),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       item['label'] as String,
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.nunito(
//                         textStyle: TextStyle(
//                           fontSize: 12,
//                           color: _textColorPrimary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCategorySelector(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: Card(
//         elevation: 2,
//         shadowColor: Colors.black26,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(24),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             children: [
//               _categoryCard(
//                 context,
//                 'assets/images/pregnant_banner.jpg',
//                 'Saya sedang hamil',
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const EdukasiHamilScreen(
//                         materiEdukasi: [
//                           'Nutrisi penting selama kehamilan',
//                           'Perkembangan janin trimester pertama',
//                           'Tips menjaga kesehatan saat hamil',
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 backgroundColor: const Color(0xFFE3F2FD),
//                 textColor: const Color(0xFF1976D2),
//                 borderColor: const Color(0xFF90CAF9),
//                 gradientStart: const Color(0xFF90CAF9),
//                 gradientEnd: const Color(0xFF42A5F5),
//               ),
//               const SizedBox(width: 16),
//               _categoryCard(
//                 context,
//                 'assets/images/kids_banner.jpg',
//                 'Saya sudah punya anak',
//                 () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => const EdukasiAnakScreen(
//                         materiEdukasi: [
//                           'Tahapan tumbuh kembang anak usia dini',
//                           'Tips mendidik anak dengan positif',
//                           'Stimulasi perkembangan kognitif anak',
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 backgroundColor: const Color(0xFFE0F7FA),
//                 textColor: const Color(0xFF00838F),
//                 borderColor: const Color(0xFF80DEEA),
//                 gradientStart: const Color(0xFF80DEEA),
//                 gradientEnd: const Color(0xFF26C6DA),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _categoryCard(
//     BuildContext context,
//     String imageAsset,
//     String label,
//     VoidCallback onTap, {
//     required Color backgroundColor,
//     required Color textColor,
//     required Color borderColor,
//     required Color gradientStart,
//     required Color gradientEnd,
//   }) {
//     return Expanded(
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: borderColor.withOpacity(0.3),
//               spreadRadius: 1,
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: onTap,
//             borderRadius: BorderRadius.circular(16),
//             child: Ink(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [gradientStart.withOpacity(0.2), gradientEnd.withOpacity(0.3)],
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 border: Border.all(color: borderColor.withOpacity(0.5), width: 1.5),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: 70,
//                       width: 70,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(color: borderColor, width: 2),
//                         boxShadow: [
//                           BoxShadow(
//                             color: borderColor.withOpacity(0.3),
//                             spreadRadius: 1,
//                             blurRadius: 4,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: ClipOval(
//                         child: Image.asset(
//                           imageAsset,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Text(
//                       label,
//                       textAlign: TextAlign.center,
//                       style: GoogleFonts.montserrat(
//                         textStyle: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           color: textColor,
//                           fontSize: 14,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }