import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Observable untuk track index bottom navigation yang aktif
  final selectedIndex = 0.obs;

  // Map routes dengan index tab
  static const Map<int, String> tabRoutes = {
    0: '/home',
    1: '/notification',
    2: '/history',
    3: '/profile',
  };

  // List tab labels untuk reference
  final tabLabels = <String>['Home', 'Notifikasi', 'Riwayat', 'Profil'];

  @override
  void onInit() {
    super.onInit();
    // Set initial index berdasarkan current route
    _initializeIndexFromRoute();
  }

  /// Inisialisasi index dari current route saat app dimulai
  void _initializeIndexFromRoute() {
    final currentRoute = Get.currentRoute;
    selectedIndex.value = _getIndexFromRoute(currentRoute);
  }

  /// Ubah tab berdasarkan index dan update route
  void switchTab(int index) {
    if (index < 0 || index >= tabRoutes.length) return;

    selectedIndex.value = index;
    final routeName = tabRoutes[index];
    if (routeName != null && Get.currentRoute != routeName) {
      Get.offNamed(routeName);
    }
  }

  /// Get index dari route name
  int _getIndexFromRoute(String route) {
    for (final entry in tabRoutes.entries) {
      if (entry.value == route) {
        return entry.key;
      }
    }
    return 0;
  }

  /// Get tab label dari index
  String getTabLabel(int index) {
    if (index >= 0 && index < tabLabels.length) {
      return tabLabels[index];
    }
    return '';
  }
}
