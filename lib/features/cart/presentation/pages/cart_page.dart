import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumbler_store/features/cart/presentation/pages/checkout_page.dart';
import 'package:tumbler_store/features/cart/presentation/providers/cart_provider.dart';
import 'package:tumbler_store/core/extensions/number_extension.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const _pink = Color(0xFFE8829A);
  static const _pinkLight = Color(0xFFFDE8EE);
  static const _bg = Color(0xFFFFF0F5);
  static const _textPrimary = Color(0xFF2D2D2D);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4A7B9),
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 16),
          ),
        ),
        title: const Text(
          'Keranjang',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, _) {
              if (cart.isEmpty) return const SizedBox();
              return TextButton(
                onPressed: () => _confirmClear(context, cart),
                child: const Text(
                  'Kosongkan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, _) {
          if (cart.isEmpty) return _buildEmpty();

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _CartItemCard(item: cart.items[i]),
                ),
              ),
              _buildSummary(context, cart),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: _pinkLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_cart_outlined,
                size: 56, color: _pink),
          ),
          const SizedBox(height: 20),
          const Text(
            'Keranjang masih kosong',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Yuk tambahkan produk favoritmu!',
            style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context, CartProvider cart) {
  return Container(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      boxShadow: [
        BoxShadow(
          color: Colors.pink.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, -6),
        ),
      ],
    ),
    child: Column(
      children: [
        // Select all row
        Row(
          children: [
            GestureDetector(
              onTap: () => cart.toggleSelectAll(),
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: cart.allSelected ? _pink : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: cart.allSelected ? _pink : Colors.grey.shade300,
                    width: 1.5,
                  ),
                ),
                child: cart.allSelected
                    ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Semua',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            const Text(
              'Total',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 8),
            Text(
              cart.totalPrice.toRupiah(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _pink,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: cart.selectedItems.isEmpty
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutPage()),
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _pink,
              disabledBackgroundColor: Colors.grey.shade200,
              disabledForegroundColor: Colors.grey.shade400,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              cart.selectedItems.isEmpty
                  ? 'Pilih produk dulu'
                  : 'Checkout (${cart.selectedCount} produk)',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  void _confirmClear(BuildContext context, CartProvider cart) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Kosongkan Keranjang?',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: const Text(
          'Semua item akan dihapus dari keranjang.',
          style: TextStyle(fontSize: 13, color: Color(0xFF9E9E9E)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFF9E9E9E))),
          ),
          TextButton(
            onPressed: () {
              cart.clearCart();
              Navigator.pop(context);
            },
            child: const Text('Kosongkan',
                style: TextStyle(
                    color: Color(0xFFE8829A), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  static const _pink = Color(0xFFE8829A);
  static const _pinkLight = Color(0xFFFDE8EE);
  static const _textPrimary = Color(0xFF2D2D2D);

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => cart.toggleSelect(item.product.id),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: item.isSelected ? _pink : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: item.isSelected ? _pink : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: item.isSelected
                  ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          // Gambar
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              item.product.imageUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 72,
                height: 72,
                color: _pinkLight,
                child: const Icon(Icons.local_drink_outlined, color: _pink, size: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: _textPrimary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  item.product.price.toRupiah(),
                  style: const TextStyle(
                    color: _pink,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            children: [
              GestureDetector(
                onTap: () => cart.removeItem(item.product.id),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _pinkLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: _pink, size: 16),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onTap: () => cart.decreaseItem(item.product.id),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${item.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _QtyButton(
                    icon: Icons.add,
                    onTap: () => cart.addItem(item.product),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  static const _pink = Color(0xFFE8829A);
  static const _pinkLight = Color(0xFFFDE8EE);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _pinkLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: _pink, size: 14),
      ),
    );
  }
}