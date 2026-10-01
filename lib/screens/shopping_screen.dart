// lib/screens/shopping_screen.dart
import 'package:flutter/material.dart';

// Model untuk item di keranjang
class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;
  final String imageUrl;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    required this.imageUrl,
  });
}

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({super.key});

  @override
  State<ShoppingScreen> createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  //selectedCategoryIndex tidak lagi dibutuhkan karena kita akan menggunakan ExpansionTile
  final List<CartItem> cart = []; // Menyimpan produk yang ditambahkan ke keranjang

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  // Kategori produk baru: Hanya 3
  final List<String> categories = [
    'Pregnancy Products',
    'Baby Products',
    'General Products',
  ];

  // Daftar gambar yang tersedia (tetap sama)
  final List<String> availableImages = [
    'assets/images/face_care.jpg',
    'assets/images/hair_care.jpg',
    'assets/images/body_care.jpg',
    'assets/images/oral_care.jpg',
  ];

  // Data produk dummy yang dirombak untuk 3 kategori baru
  final Map<String, List<Map<String, dynamic>>> productMap = {
    'Pregnancy Products': [
      {
        'id': 'preg_01',
        'title': 'Nutrisi Trimester Awal',
        'image': 'assets/images/face_care.jpg',
        'price': 150.0,
        'description': 'Suplemen nutrisi esensial untuk mendukung kesehatan ibu dan perkembangan janin di trimester pertama.',
      },
      {
        'id': 'preg_02',
        'title': 'Minyak Anti Stretch Mark',
        'image': 'assets/images/body_care.jpg',
        'price': 120.0,
        'description': 'Minyak alami yang membantu mencegah dan mengurangi stretch mark selama kehamilan.',
      },
      {
        'id': 'preg_03',
        'title': 'Bantal Kehamilan Nyaman',
        'image': 'assets/images/hair_care.jpg',
        'price': 250.0,
        'description': 'Bantal khusus yang dirancang untuk memberikan kenyamanan optimal saat tidur di masa kehamilan.',
      },
      {
        'id': 'preg_04',
        'title': 'Teh Pelancar ASI',
        'image': 'assets/images/oral_care.jpg',
        'price': 50.0,
        'description': 'Teh herbal untuk membantu produksi ASI setelah melahirkan dan selama menyusui.',
      },
      {
        'id': 'preg_05',
        'title': 'Korset Pemulihan Pasca Melahirkan',
        'image': 'assets/images/body_care.jpg',
        'price': 170.0,
        'description': 'Korset yang dirancang untuk membantu pemulihan tubuh pasca melahirkan.',
      },
      {
        'id': 'preg_06',
        'title': 'Breast Pump Elektrik Cepat',
        'image': 'assets/images/face_care.jpg',
        'price': 450.0,
        'description': 'Pompa ASI elektrik yang efisien dan nyaman untuk ibu menyusui.',
      },
      {
        'id': 'preg_07',
        'title': 'Nipple Cream Organik',
        'image': 'assets/images/oral_care.jpg',
        'price': 70.0,
        'description': 'Krim puting organik untuk mencegah dan meredakan iritasi saat menyusui.',
      },
      {
        'id': 'preg_08',
        'title': 'Buku Panduan Persiapan Melahirkan',
        'image': 'assets/images/hair_care.jpg',
        'price': 85.0,
        'description': 'Panduan praktis untuk menghadapi proses persalinan dengan tenang dan percaya diri.',
      },
    ],
    'Baby Products': [
      {
        'id': 'baby_01',
        'title': 'Paket Perawatan Kulit Bayi',
        'image': 'assets/images/body_care.jpg',
        'price': 220.0,
        'description': 'Paket lengkap produk perawatan kulit bayi yang lembut dan aman.',
      },
      {
        'id': 'baby_02',
        'title': 'Popok Bayi Organik',
        'image': 'assets/images/face_care.jpg',
        'price': 100.0,
        'description': 'Popok bayi ramah lingkungan dari bahan organik untuk kulit sensitif.',
      },
      {
        'id': 'baby_03',
        'title': 'Mainan Edukasi Bayi Interaktif',
        'image': 'assets/images/hair_care.jpg',
        'price': 60.0,
        'description': 'Mainan yang merangsang perkembangan motorik dan kognitif bayi.',
      },
      {
        'id': 'baby_04',
        'title': 'Baby Oral Gel Formula Aman',
        'image': 'assets/images/oral_care.jpg',
        'price': 35.0,
        'description': 'Gel pembersih mulut bayi untuk menjaga kebersihan sebelum tumbuh gigi.',
      },
      {
        'id': 'baby_05',
        'title': 'Baju Bayi Katun Lembut',
        'image': 'assets/images/body_care.jpg',
        'price': 75.0,
        'description': 'Pakaian bayi dari katun lembut, nyaman untuk kulit sensitif.',
      },
      {
        'id': 'baby_06',
        'title': 'Shampoo Bayi Anti Alergi',
        'image': 'assets/images/hair_care.jpg',
        'price': 45.0,
        'description': 'Shampoo khusus bayi yang bebas alergi dan tidak pedih di mata.',
      },
    ],
    'General Products': [
      {
        'id': 'gen_01',
        'title': 'Skincare Harian',
        'image': 'assets/images/face_care.jpg',
        'price': 120.0,
        'description': 'Rangkaian perawatan wajah untuk menjaga kulit tetap sehat dan bercahaya.',
      },
      {
        'id': 'gen_02',
        'title': 'Perawatan Rambut Intensif',
        'image': 'assets/images/hair_care.jpg',
        'price': 90.0,
        'description': 'Berbagai produk untuk perawatan rambut, mulai dari sampo hingga kondisioner.',
      },
      {
        'id': 'gen_03',
        'title': 'Body Lotion Pelembap',
        'image': 'assets/images/body_care.jpg',
        'price': 85.0,
        'description': 'Produk perawatan tubuh seperti lotion, sabun, dan scrub untuk kulit halus.',
      },
      {
        'id': 'gen_04',
        'title': 'Pasta Gigi Pemutih',
        'image': 'assets/images/oral_care.jpg',
        'price': 40.0,
        'description': 'Produk untuk menjaga kesehatan gigi dan mulut Anda, seperti pasta gigi dan obat kumur.',
      },
      {
        'id': 'gen_05',
        'title': 'Suplemen Multivitamin Harian',
        'image': 'assets/images/face_care.jpg',
        'price': 110.0,
        'description': 'Suplemen harian untuk mendukung kesehatan dan vitalitas Anda.',
      },
      {
        'id': 'gen_06',
        'title': 'Hand Sanitizer Travel Size',
        'image': 'assets/images/hair_care.jpg',
        'price': 25.0,
        'description': 'Pembersih tangan antiseptik untuk kebersihan di mana saja.',
      },
      {
        'id': 'gen_07',
        'title': 'Botol Minum Olahraga',
        'image': 'assets/images/body_care.jpg',
        'price': 45.0,
        'description': 'Botol minum ramah lingkungan untuk gaya hidup sehat dan berkelanjutan.',
      },
      {
        'id': 'gen_08',
        'title': 'Diffuser Aromaterapi Modern',
        'image': 'assets/images/oral_care.jpg',
        'price': 180.0,
        'description': 'Alat penyebar aroma untuk menciptakan suasana relaksasi di rumah.',
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchText = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addProductToCart(Map<String, dynamic> productData) {
    setState(() {
      final existingItemIndex = cart.indexWhere((item) => item.id == productData['id']);
      if (existingItemIndex != -1) {
        cart[existingItemIndex].quantity++;
      } else {
        cart.add(CartItem(
          id: productData['id'],
          name: productData['title'],
          price: productData['price'],
          imageUrl: productData['image'],
          quantity: 1,
        ));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${productData['title']} ditambahkan ke keranjang')),
    );
  }

  void _increaseQuantity(String productId) {
    setState(() {
      final itemIndex = cart.indexWhere((item) => item.id == productId);
      if (itemIndex != -1) {
        cart[itemIndex].quantity++;
      }
    });
  }

  void _decreaseQuantity(String productId) {
    setState(() {
      final itemIndex = cart.indexWhere((item) => item.id == productId);
      if (itemIndex != -1) {
        if (cart[itemIndex].quantity > 1) {
          cart[itemIndex].quantity--;
        } else {
          _removeItemFromCart(productId); // Hapus jika kuantitas jadi 0
        }
      }
    });
  }

  void _removeItemFromCart(String productId) {
    setState(() {
      cart.removeWhere((item) => item.id == productId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item dihapus dari keranjang')),
    );
  }

  double get _totalPrice {
    return cart.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    //selectedCategory tidak lagi digunakan untuk menampilkan produk
    //products dan filteredProducts akan dibuat di dalam ExpansionTile

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80, // Tambahkan tinggi AppBar
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.jpg'), // Ganti dengan gambar avatar Anda
              radius: 20,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Halo,', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  Text('Riyadi', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 28),
                if (cart.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        cart.length.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              _showCartBottomSheet(context);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari Produk...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Produk Kami', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    // Implement 'Lihat Semua' functionality if needed
                  },
                  child: const Text('Lihat Semua', style: TextStyle(color: Colors.orange, fontSize: 16)),
                ),
              ],
            ),
          ),
          // Bagian Kategori Produk yang sekarang menggunakan ExpansionTile
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final categoryName = categories[index];
                final products = productMap[categoryName]!;
                final filteredProducts = products.where((product) {
                  return product['title']!.toLowerCase().contains(_searchText.toLowerCase());
                }).toList();

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ExpansionTile(
                    initiallyExpanded: index == 0, // Kategori pertama otomatis terbuka
                    title: Text(
                      categoryName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    childrenPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    children: [
                      GridView.builder(
                        shrinkWrap: true, // Penting agar GridView tidak mengambil semua ruang yang tersedia
                        physics: const NeverScrollableScrollPhysics(), // Agar GridView tidak bisa digulir sendiri
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, productIndex) {
                          final product = filteredProducts[productIndex];
                          return GestureDetector(
                            onTap: () {
                              _showProductDetailBottomSheet(context, product);
                            },
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                                      child: Image.asset(
                                        product['image'],
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Rp${product['price'].toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Colors.orange,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: IconButton(
                                              icon: const Icon(Icons.add, color: Colors.white),
                                              onPressed: () {
                                                _addProductToCart(product);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Bottom Sheet untuk Detail Produk
  void _showProductDetailBottomSheet(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              child: Stack(
                // Menggunakan Stack untuk posisi tombol close di AppBarlike
                children: [
                  ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20.0),
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 20), // Memberi sedikit jarak dari konten
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          product['image'],
                          height: 200,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        product['title'],
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rp${product['price'].toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.orange),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Deskripsi:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        product['description'] ?? 'Tidak ada deskripsi.',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          _addProductToCart(product);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Tambah ke Keranjang',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  // Tombol Close untuk Detail Produk
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.black, size: 28),
                      onPressed: () {
                        Navigator.pop(context); // Menutup bottom sheet detail produk
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Bottom Sheet untuk Keranjang Belanja
  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 60,
                      height: 5,
                      margin: const EdgeInsets.only(top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Keranjang Belanja',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.black),
                          onPressed: () {
                            Navigator.pop(context); // Menutup bottom sheet keranjang
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: cart.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
                                SizedBox(height: 16),
                                Text('Keranjang kamu kosong',
                                    style: TextStyle(fontSize: 18, color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: scrollController,
                            itemCount: cart.length,
                            itemBuilder: (context, index) {
                              final item = cart[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.asset(
                                          item.imageUrl,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold, fontSize: 16),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Rp${item.price.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                  color: Colors.orange,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(Icons.remove, size: 20),
                                                        onPressed: () {
                                                          _decreaseQuantity(item.id);
                                                        },
                                                      ),
                                                      Text(item.quantity.toString(),
                                                          style: const TextStyle(
                                                              fontSize: 16, fontWeight: FontWeight.bold)),
                                                      IconButton(
                                                        icon: const Icon(Icons.add, size: 20),
                                                        onPressed: () {
                                                          _increaseQuantity(item.id);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Spacer(),
                                                IconButton(
                                                  icon: const Icon(Icons.delete, color: Colors.red),
                                                  onPressed: () {
                                                    _removeItemFromCart(item.id);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total:',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('Rp${_totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _totalPrice > 0
                              ? () {
                                  // Implementasi checkout
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Total belanja: Rp${_totalPrice.toStringAsFixed(0)}. Proses checkout...')),
                                  );
                                  Navigator.pop(context); // Tutup bottom sheet setelah checkout
                                }
                              : null, // Tombol non-aktif jika keranjang kosong
                          child: const Text(
                            'Checkout Sekarang',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}