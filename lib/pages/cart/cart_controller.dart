import 'package:get/get.dart';

class CartItem {
  final String id;
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

  double get subtotal => price * quantity;
}

class CartController extends GetxController {
  // Observable variables
  final cartItems = <CartItem>[].obs;
  final isLoading = false.obs;
  final subtotal = 0.0.obs;
  final tax = 0.0.obs;
  final total = 0.0.obs;

  // Tax percentage (10%)
  static const double TAX_PERCENTAGE = 0.10;

  @override
  void onInit() {
    super.onInit();
    _loadCartItems();
  }

  void _loadCartItems() {
    isLoading.value = true;
    try {
      Future.delayed(const Duration(milliseconds: 500), () {
        cartItems.addAll([
          CartItem(
            id: '1',
            name: 'Laptop Gaming ASUS ROG',
            price: 15000000,
            imageUrl: 'https://via.placeholder.com/200?text=Laptop',
            quantity: 1,
          ),
          CartItem(
            id: '2',
            name: 'Mouse Wireless Logitech',
            price: 350000,
            imageUrl: 'https://via.placeholder.com/200?text=Mouse',
            quantity: 2,
          ),
          CartItem(
            id: '3',
            name: 'Keyboard Mekanik RGB',
            price: 850000,
            imageUrl: 'https://via.placeholder.com/200?text=Keyboard',
            quantity: 1,
          ),
        ]);
        _calculateTotals();
        isLoading.value = false;
      });
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat keranjang');
      isLoading.value = false;
    }
  }

  void _calculateTotals() {
    subtotal.value =
        cartItems.fold(0.0, (sum, item) => sum + item.subtotal);
    tax.value = subtotal.value * TAX_PERCENTAGE;
    total.value = subtotal.value + tax.value;
  }

  void addItem(CartItem item) {
    final existingIndex = cartItems.indexWhere((c) => c.id == item.id);
    if (existingIndex != -1) {
      cartItems[existingIndex].quantity += item.quantity;
      cartItems.refresh();
    } else {
      cartItems.add(item);
    }
    _calculateTotals();
    Get.snackbar(
      'Success',
      '${item.name} ditambahkan ke keranjang',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void removeItem(String itemId) {
    cartItems.removeWhere((item) => item.id == itemId);
    _calculateTotals();
    Get.snackbar(
      'Success',
      'Item dihapus dari keranjang',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void updateQuantity(String itemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(itemId);
      return;
    }
    final index = cartItems.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      cartItems[index].quantity = newQuantity;
      cartItems.refresh();
      _calculateTotals();
    }
  }

  void clearCart() {
    Get.dialog(
      AlertDialog(
        title: const Text('Kosongkan Keranjang'),
        content:
            const Text('Apakah Anda yakin ingin menghapus semua item?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              cartItems.clear();
              _calculateTotals();
              Get.snackbar(
                'Success',
                'Keranjang telah dikosongkan',
                snackPosition: SnackPosition.BOTTOM,
              );
              Get.back();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void checkout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Info',
        'Keranjang Anda kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Pembelian'),
        content: Text(
          'Total: Rp ${_formatCurrency(total.value)}\n\nLanjutkan dengan pembayaran?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Get.snackbar(
                'Success',
                'Pesanan berhasil dikirim ke checkout',
                snackPosition: SnackPosition.BOTTOM,
              );
              Get.back();
              // TODO: Navigate to checkout page
            },
            child: const Text('Lanjut'),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  String getFormattedPrice(double price) {
    return _formatCurrency(price);
  }
}
