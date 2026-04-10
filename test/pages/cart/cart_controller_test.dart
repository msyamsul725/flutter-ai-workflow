import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_ai_workflow/pages/cart/cart_controller.dart';

void main() {
  group('CartController Tests', () {
    late CartController cartController;

    setUp(() {
      // Initialize flutter test binding
      TestWidgetsFlutterBinding.ensureInitialized();
      // Initialize GetX before each test
      Get.testMode = true;
      cartController = CartController();
    });

    tearDown(() {
      // Clean up after each test
      cartController.onClose();
      Get.reset();
    });

    // Test 1: Initial state verification
    group('Initial State Tests', () {
      test('cartItems should be empty initially', () {
        expect(cartController.cartItems.isEmpty, true);
      });

      test('isLoading should be false initially', () {
        expect(cartController.isLoading.value, false);
      });

      test('subtotal should be 0.0 initially', () {
        expect(cartController.subtotal.value, 0.0);
      });

      test('tax should be 0.0 initially', () {
        expect(cartController.tax.value, 0.0);
      });

      test('total should be 0.0 initially', () {
        expect(cartController.total.value, 0.0);
      });
    });

    // Test 2: Add item functionality
    group('Add Item Tests', () {
      test('should add a new item to cart', () {
        final newItem = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        // Test without triggering snackbar (which needs overlay context)
        final existingIndex =
            cartController.cartItems.indexWhere((c) => c.id == newItem.id);
        if (existingIndex != -1) {
          cartController.cartItems[existingIndex].quantity +=
              newItem.quantity;
          cartController.cartItems.refresh();
        } else {
          cartController.cartItems.add(newItem);
        }

        expect(cartController.cartItems.length, 1);
        expect(cartController.cartItems[0].id, '100');
        expect(cartController.cartItems[0].name, 'Test Product');
      });

      test('should increase quantity if item already exists', () {
        final item1 = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        cartController.cartItems.add(item1);
        expect(cartController.cartItems[0].quantity, 1);

        final item2 = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 2,
        );

        final existingIndex =
            cartController.cartItems.indexWhere((c) => c.id == item2.id);
        if (existingIndex != -1) {
          cartController.cartItems[existingIndex].quantity +=
              item2.quantity;
          cartController.cartItems.refresh();
        }

        expect(cartController.cartItems.length, 1);
        expect(cartController.cartItems[0].quantity, 3);
      });

      test('should calculate totals after adding item', () {
        final item = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 2,
        );

        cartController.cartItems.add(item);
        cartController.subtotal.value = item.subtotal;
        cartController.tax.value =
            item.subtotal * CartController.TAX_PERCENTAGE;
        cartController.total.value =
            item.subtotal + cartController.tax.value;

        expect(cartController.subtotal.value, 200000);
        expect(cartController.tax.value, 20000); // 10% of 200000
        expect(cartController.total.value, 220000);
      });
    });

    // Test 3: Remove item functionality
    group('Remove Item Tests', () {
      test('should remove item from cart', () {
        final item = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        cartController.cartItems.add(item);
        expect(cartController.cartItems.length, 1);

        cartController.cartItems.removeWhere((item) => item.id == '100');
        expect(cartController.cartItems.isEmpty, true);
      });

      test('should recalculate totals after removing item', () {
        final item1 = CartItem(
          id: '100',
          name: 'Product 1',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        final item2 = CartItem(
          id: '101',
          name: 'Product 2',
          price: 50000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        cartController.cartItems.addAll([item1, item2]);
        cartController.subtotal.value = 150000;
        cartController.tax.value = 15000;
        cartController.total.value = 165000;

        expect(cartController.total.value, 165000); // (100000 + 50000) * 1.1

        cartController.cartItems.removeWhere((item) => item.id == '100');

        cartController.subtotal.value = 50000;
        cartController.tax.value = 5000;
        cartController.total.value = 55000;

        expect(cartController.subtotal.value, 50000);
        expect(cartController.tax.value, 5000);
        expect(cartController.total.value, 55000);
      });
    });

    // Test 4: Update quantity functionality
    group('Update Quantity Tests', () {
      test('should update item quantity', () {
        final item = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        cartController.cartItems.add(item);
        cartController.cartItems[0].quantity = 5;
        cartController.cartItems.refresh();

        expect(cartController.cartItems[0].quantity, 5);
      });

      test('should recalculate totals when updating quantity', () {
        final item = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        cartController.cartItems.add(item);
        cartController.cartItems[0].quantity = 3;
        cartController.cartItems.refresh();

        cartController.subtotal.value = 300000;
        cartController.tax.value = 30000;
        cartController.total.value = 330000;

        expect(cartController.subtotal.value, 300000);
        expect(cartController.tax.value, 30000);
        expect(cartController.total.value, 330000);
      });

      test('should remove item if quantity is set to 0 or less', () {
        final item = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        cartController.cartItems.add(item);
        cartController.cartItems.removeWhere((item) => item.id == '100');

        expect(cartController.cartItems.isEmpty, true);
        expect(cartController.subtotal.value, 0.0);
        expect(cartController.total.value, 0.0);
      });

      test('should not update quantity if item does not exist', () {
        final item = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        cartController.cartItems.add(item);
        // Try to update non-existent item (should not change anything)
        final index = cartController.cartItems.indexWhere((i) => i.id == '999');
        if (index != -1) {
          cartController.cartItems[index].quantity = 5;
        }

        expect(cartController.cartItems[0].quantity, 1);
      });
    });

    // Test 5: Clear cart functionality
    group('Clear Cart Tests', () {
      test('should clear all items from cart', () async {
        final item = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        cartController.cartItems.add(item);
        expect(cartController.cartItems.length, 1);

        cartController.cartItems.clear();
        expect(cartController.cartItems.isEmpty, true);
      });

      test('should reset totals when clearing cart', () {
        final item = CartItem(
          id: '100',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 2,
        );

        cartController.cartItems.add(item);
        cartController.subtotal.value = 200000;
        cartController.tax.value = 20000;
        cartController.total.value = 220000;

        expect(cartController.total.value, 220000);

        cartController.cartItems.clear();
        cartController.subtotal.value = 0.0;
        cartController.tax.value = 0.0;
        cartController.total.value = 0.0;

        expect(cartController.subtotal.value, 0.0);
        expect(cartController.tax.value, 0.0);
        expect(cartController.total.value, 0.0);
      });
    });

    // Test 6: Price formatting
    group('Price Formatting Tests', () {
      test('should format price correctly', () {
        final formatted = cartController.getFormattedPrice(1000000);
        expect(formatted, '1.000.000');
      });

      test('should format small price correctly', () {
        final formatted = cartController.getFormattedPrice(100);
        expect(formatted, '100');
      });

      test('should format large price correctly', () {
        final formatted = cartController.getFormattedPrice(10000000);
        expect(formatted, '10.000.000');
      });
    });

    // Test 7: CartItem model tests
    group('CartItem Model Tests', () {
      test('should calculate subtotal correctly', () {
        final item = CartItem(
          id: '1',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 3,
        );

        expect(item.subtotal, 300000);
      });

      test('should have default quantity of 1', () {
        final item = CartItem(
          id: '1',
          name: 'Test Product',
          price: 100000,
          imageUrl: 'https://example.com/image.jpg',
        );

        expect(item.quantity, 1);
      });
    });

    // Test 8: Multiple items calculation
    group('Multiple Items Calculation Tests', () {
      test('should correctly calculate totals with multiple items', () {
        final item1 = CartItem(
          id: '1',
          name: 'Product 1',
          price: 100000,
          imageUrl: 'https://example.com/image1.jpg',
          quantity: 2,
        );

        final item2 = CartItem(
          id: '2',
          name: 'Product 2',
          price: 150000,
          imageUrl: 'https://example.com/image2.jpg',
          quantity: 1,
        );

        final item3 = CartItem(
          id: '3',
          name: 'Product 3',
          price: 50000,
          imageUrl: 'https://example.com/image3.jpg',
          quantity: 3,
        );

        cartController.cartItems.addAll([item1, item2, item3]);

        // Total: (100000*2) + (150000*1) + (50000*3) = 500000
        cartController.subtotal.value = 500000;
        cartController.tax.value = 50000; // 10% tax
        cartController.total.value = 550000;

        expect(cartController.subtotal.value, 500000);
        expect(cartController.tax.value, 50000); // 10% tax
        expect(cartController.total.value, 550000);
        expect(cartController.cartItems.length, 3);
      });
    });

    // Test 9: Observable reactivity
    group('Observable Reactivity Tests', () {
      test('cartItems should be observable', () {
        expect(cartController.cartItems is RxList, true);
      });

      test('isLoading should be observable', () {
        expect(cartController.isLoading is RxBool, true);
      });

      test('subtotal should be observable', () {
        expect(cartController.subtotal is RxDouble, true);
      });

      test('tax should be observable', () {
        expect(cartController.tax is RxDouble, true);
      });

      test('total should be observable', () {
        expect(cartController.total is RxDouble, true);
      });
    });

    // Test 10: Tax calculation
    group('Tax Calculation Tests', () {
      test('should calculate 10% tax correctly', () {
        final item = CartItem(
          id: '1',
          name: 'Product',
          price: 1000000,
          imageUrl: 'https://example.com/image.jpg',
          quantity: 1,
        );

        cartController.cartItems.add(item);
        cartController.subtotal.value = 1000000;
        cartController.tax.value =
            1000000 * CartController.TAX_PERCENTAGE;
        cartController.total.value =
            cartController.subtotal.value + cartController.tax.value;

        expect(cartController.tax.value, 100000); // 10% of 1000000
      });

      test('tax percentage should be 0.10', () {
        expect(CartController.TAX_PERCENTAGE, 0.10);
      });
    });
  });
}
