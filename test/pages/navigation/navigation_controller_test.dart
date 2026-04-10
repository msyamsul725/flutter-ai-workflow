import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_ai_workflow/pages/navigation/navigation_controller.dart';
import 'package:flutter_ai_workflow/pages/navigation/navigation_binding.dart';

void main() {
  late NavigationController controller;

  setUp(() {
    // Inisialisasi binding sebelum test
    Get.testMode = true;
    NavigationBinding().dependencies();
    controller = Get.find<NavigationController>();
  });

  tearDown(() {
    Get.reset();
  });

  group('NavigationController', () {
    test('Initial state should be index 0', () {
      expect(controller.selectedIndex.value, equals(0));
    });

    test('TabLabels should have 3 items', () {
      expect(controller.tabLabels.length, equals(3));
      expect(controller.tabLabels[0], equals('Home'));
      expect(controller.tabLabels[1], equals('Notifikasi'));
      expect(controller.tabLabels[2], equals('Profil'));
    });

    test('TabRoutes should have 3 routes', () {
      expect(NavigationController.tabRoutes.length, equals(3));
      expect(NavigationController.tabRoutes[0], equals('/home'));
      expect(NavigationController.tabRoutes[1], equals('/notification'));
      expect(NavigationController.tabRoutes[2], equals('/profile'));
    });

    test('switchTab should update selectedIndex', () {
      controller.switchTab(1);
      expect(controller.selectedIndex.value, equals(1));

      controller.switchTab(2);
      expect(controller.selectedIndex.value, equals(2));

      controller.switchTab(0);
      expect(controller.selectedIndex.value, equals(0));
    });

    test('switchTab should not update with invalid index', () {
      final initialIndex = controller.selectedIndex.value;
      controller.switchTab(-1);
      expect(controller.selectedIndex.value, equals(initialIndex));

      controller.switchTab(10);
      expect(controller.selectedIndex.value, equals(initialIndex));
    });

    test('getTabLabel should return correct label for valid index', () {
      expect(controller.getTabLabel(0), equals('Home'));
      expect(controller.getTabLabel(1), equals('Notifikasi'));
      expect(controller.getTabLabel(2), equals('Profil'));
    });

    test('getTabLabel should return empty string for invalid index', () {
      expect(controller.getTabLabel(-1), equals(''));
      expect(controller.getTabLabel(10), equals(''));
    });

    test('selectedIndex should be observable', () {
      var updateCount = 0;
      controller.selectedIndex.listen((_) {
        updateCount++;
      });

      controller.switchTab(1);
      expect(updateCount, equals(1));

      controller.switchTab(2);
      expect(updateCount, equals(2));

      // Switching to same index should not trigger listener
      controller.selectedIndex.value = 2;
      expect(updateCount, equals(2));
    });

    test('Multiple rapid switches should use last index', () {
      controller.switchTab(1);
      controller.switchTab(2);
      controller.switchTab(0);
      controller.switchTab(1);

      expect(controller.selectedIndex.value, equals(1));
    });

    test('switchTab should handle all valid indices sequentially', () {
      for (int i = 0; i < 3; i++) {
        controller.switchTab(i);
        expect(controller.selectedIndex.value, equals(i));
      }
    });

    test('selectedIndex should start at 0 after initialization', () {
      // Setelah setUp, controller sudah diinisialisasi
      expect(controller.selectedIndex.value, equals(0));
    });

    test('switchTab 0 should select home tab', () {
      controller.switchTab(1);
      controller.switchTab(2);
      controller.switchTab(0);

      expect(controller.selectedIndex.value, equals(0));
      expect(controller.getTabLabel(controller.selectedIndex.value), equals('Home'));
    });

    test('switchTab 1 should select notification tab', () {
      controller.switchTab(1);

      expect(controller.selectedIndex.value, equals(1));
      expect(
        controller.getTabLabel(controller.selectedIndex.value),
        equals('Notifikasi'),
      );
    });

    test('switchTab 2 should select profile tab', () {
      controller.switchTab(2);

      expect(controller.selectedIndex.value, equals(2));
      expect(
        controller.getTabLabel(controller.selectedIndex.value),
        equals('Profil'),
      );
    });
  });
}
