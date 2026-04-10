import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Model untuk data riwayat
class HistoryItem {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String category;
  final IconData icon;
  final Color color;

  HistoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.category,
    required this.icon,
    required this.color,
  });
}

// Controller untuk halaman histori
class HistoryController extends GetxController {
  final isLoading = false.obs;
  final historyItems = <HistoryItem>[].obs;
  final filteredItems = <HistoryItem>[].obs;
  final selectedFilter = 'Semua'.obs;

  final filters = [
    'Semua',
    'Login',
    'Transaksi',
    'Perubahan Profil',
    'Unduhan',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeHistoryData();
  }

  void _initializeHistoryData() {
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      historyItems.assignAll([
        HistoryItem(
          id: '1',
          title: 'Login Berhasil',
          description: 'Anda berhasil masuk dari perangkat baru',
          dateTime: DateTime.now().subtract(const Duration(hours: 2)),
          category: 'Login',
          icon: Icons.login,
          color: Colors.green,
        ),
        HistoryItem(
          id: '2',
          title: 'Transaksi Pembayaran',
          description: 'Pembayaran Rp 500.000 - Invoice #12345',
          dateTime: DateTime.now().subtract(const Duration(hours: 5)),
          category: 'Transaksi',
          icon: Icons.payment,
          color: Colors.blue,
        ),
        HistoryItem(
          id: '3',
          title: 'Perubahan Profil',
          description: 'Foto profil telah diperbarui',
          dateTime: DateTime.now().subtract(const Duration(days: 1)),
          category: 'Perubahan Profil',
          icon: Icons.person_outline,
          color: Colors.purple,
        ),
        HistoryItem(
          id: '4',
          title: 'Unduhan File',
          description: 'File laporan_q1_2026.pdf berhasil diunduh',
          dateTime: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          category: 'Unduhan',
          icon: Icons.download,
          color: Colors.orange,
        ),
        HistoryItem(
          id: '5',
          title: 'Login Berhasil',
          description: 'Anda berhasil masuk dari iPhone 14',
          dateTime: DateTime.now().subtract(const Duration(days: 2)),
          category: 'Login',
          icon: Icons.login,
          color: Colors.green,
        ),
        HistoryItem(
          id: '6',
          title: 'Transaksi Refund',
          description: 'Pengembalian dana Rp 250.000',
          dateTime: DateTime.now().subtract(const Duration(days: 3)),
          category: 'Transaksi',
          icon: Icons.refund,
          color: Colors.red,
        ),
        HistoryItem(
          id: '7',
          title: 'Ubah Password',
          description: 'Password akun Anda telah diperbarui',
          dateTime: DateTime.now().subtract(const Duration(days: 4)),
          category: 'Perubahan Profil',
          icon: Icons.lock,
          color: Colors.purple,
        ),
        HistoryItem(
          id: '8',
          title: 'Unduhan Laporan',
          description: 'File annual_report_2025.pdf berhasil diunduh',
          dateTime: DateTime.now().subtract(const Duration(days: 5)),
          category: 'Unduhan',
          icon: Icons.download,
          color: Colors.orange,
        ),
      ]);
      filteredItems.assignAll(historyItems);
      isLoading.value = false;
    });
  }

  void filterByCategory(String category) {
    selectedFilter.value = category;
    if (category == 'Semua') {
      filteredItems.assignAll(historyItems);
    } else {
      filteredItems.assignAll(
        historyItems.where((item) => item.category == category).toList(),
      );
    }
  }

  Future<void> deleteHistoryItem(String itemId) async {
    historyItems.removeWhere((item) => item.id == itemId);
    filterByCategory(selectedFilter.value);
    Get.snackbar(
      'Terhapus',
      'Item riwayat telah dihapus',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> clearAllHistory() async {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Semua Riwayat?'),
        content: const Text(
          'Tindakan ini tidak dapat dibatalkan. Semua riwayat akan dihapus secara permanen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              historyItems.clear();
              filteredItems.clear();
              Get.back();
              Get.snackbar(
                'Berhasil',
                'Semua riwayat telah dihapus',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 1) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  String getFormattedDateTime(DateTime dateTime) => _formatDateTime(dateTime);
}

// View untuk halaman histori
class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        elevation: 0,
        actions: [
          Obx(
            () => controller.historyItems.isNotEmpty
                ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'clear') {
                        controller.clearAllHistory();
                      }
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem<String>(
                        value: 'clear',
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 12),
                            Text('Hapus Semua'),
                          ],
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  // Filter Tabs
                  if (controller.historyItems.isNotEmpty) ...[
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Obx(
                        () => Row(
                          children: controller.filters
                              .map(
                                (filter) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: FilterChip(
                                    label: Text(filter),
                                    selected:
                                        controller.selectedFilter.value == filter,
                                    onSelected: (_) {
                                      controller.filterByCategory(filter);
                                    },
                                    backgroundColor: Colors.grey[200],
                                    selectedColor: colorScheme.primary,
                                    labelStyle: TextStyle(
                                      color: controller.selectedFilter.value ==
                                              filter
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    Divider(height: 1, color: Colors.grey[300]),
                  ],
                  // History List
                  Expanded(
                    child: Obx(
                      () => controller.filteredItems.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 80,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Tidak ada riwayat',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Mulai beraksi untuk membuat riwayat',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: controller.filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = controller.filteredItems[index];
                                return _buildHistoryCard(
                                  context,
                                  theme,
                                  colorScheme,
                                  item,
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHistoryCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    HistoryItem item,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                item.icon,
                color: item.color,
                size: 24,
              ),
            ),
          ),
          title: Text(
            item.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                item.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.getFormattedDateTime(item.dateTime),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'delete') {
                controller.deleteHistoryItem(item.id);
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Text('Hapus'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Binding untuk GetX dependency injection
class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}
