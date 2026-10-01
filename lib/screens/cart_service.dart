import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartItem {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class CartService with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double get totalPrice => _items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(CartItem item) {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(item);
    }
    Fluttertoast.showToast(msg: 'Ditambahkan ke keranjang');
    notifyListeners();
  }

  void removeItem(int id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void decreaseQuantity(int id) {}
}
