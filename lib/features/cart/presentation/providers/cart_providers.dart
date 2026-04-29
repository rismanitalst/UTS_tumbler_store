// lib/features/cart/presentation/providers/cart_provider.dart

import 'package:flutter/material.dart';
import 'package:tumbler_store/features/dashboard/data/models/product_models.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get subtotal => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get totalItems => _items.values.fold(0, (sum, e) => sum + e.quantity);
  double get totalPrice => _items.values.fold(0, (sum, e) => sum + e.subtotal);
  bool get isEmpty => _items.isEmpty;

  void addItem(ProductModel product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity++;
    } else {
      _items[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void decreaseItem(int productId) {
    if (!_items.containsKey(productId)) return;
    if (_items[productId]!.quantity <= 1) {
      _items.remove(productId);
    } else {
      _items[productId]!.quantity--;
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}