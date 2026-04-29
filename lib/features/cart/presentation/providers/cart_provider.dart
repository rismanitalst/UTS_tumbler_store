import 'package:flutter/material.dart';
import 'package:tumbler_store/features/dashboard/data/models/product_models.dart';

class CartItem {
  final ProductModel product;
  int quantity;
  bool isSelected;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isSelected = false,
  });

  double get subtotal => product.price * quantity;
}

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();

  bool get isEmpty => _items.isEmpty;

  int get totalItems =>
      _items.values.fold(0, (sum, e) => sum + e.quantity);

  List<CartItem> get selectedItems =>
      _items.values.where((e) => e.isSelected).toList();

  int get selectedCount => selectedItems.length;

  bool get allSelected =>
      _items.isNotEmpty &&
      _items.values.every((e) => e.isSelected);

  double get totalPrice =>
      _items.values
          .where((e) => e.isSelected)
          .fold(0, (sum, e) => sum + e.subtotal);

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

  void toggleSelect(int productId) {
    if (!_items.containsKey(productId)) return;

    _items[productId]!.isSelected =
        !_items[productId]!.isSelected;

    notifyListeners();
  }

  void toggleSelectAll() {
    final selectAll = !allSelected;

    for (final item in _items.values) {
      item.isSelected = selectAll;
    }

    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}