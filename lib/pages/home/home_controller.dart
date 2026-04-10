import 'package:get/get.dart';

class HomeController extends GetxController {
  // Observable untuk index tab yang aktif
  final currentTabIndex = 0.obs;
  
  // Observable untuk loading state
  final isLoading = false.obs;
  
  // List menu items
  final menuItems = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeMenuItems();
    _loadData();
  }

  // Inisialisasi menu items
  void _initializeMenuItems() {
    menuItems.addAll([
      'Dashboard',
      'Orders',
      'Favorites',
      'Settings',
    ]);
  }

  // Load data untuk halaman home
  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Simulasi loading data
    } finally {
      isLoading.value = false;
    }
  }

  // Method untuk switch tab
  void switchTab(int index) {
    currentTabIndex.value = index;
  }

  // Method untuk refresh data
  Future<void> refreshData() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      // Simulasi refresh data
    } finally {
      isLoading.value = false;
    }
  }
}
