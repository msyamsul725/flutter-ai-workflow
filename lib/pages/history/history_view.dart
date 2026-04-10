import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat'),
        elevation: 0,
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: controller.refreshHistory,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  onChanged: (value) => controller.searchHistory(value),
                  decoration: InputDecoration(
                    hintText: 'Cari riwayat...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              
              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('all', 'Semua', colorScheme),
                      const SizedBox(width: 8),
                      _buildFilterChip('completed', 'Selesai', colorScheme),
                      const SizedBox(width: 8),
                      _buildFilterChip('in_progress', 'Proses', colorScheme),
                      const SizedBox(width: 8),
                      _buildFilterChip('pending', 'Menunggu', colorScheme),
                      const SizedBox(width: 8),
                      _buildFilterChip('cancelled', 'Dibatalkan', colorScheme),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // History list
              Expanded(
                child: controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorScheme.primary,
                        ),
                      )
                    : controller.filteredItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.history,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Tidak ada riwayat',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: controller.filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = controller.filteredItems[index];
                              return _buildHistoryCard(item, colorScheme, context);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build filter chip
  Widget _buildFilterChip(
    String value,
    String label,
    ColorScheme colorScheme,
  ) {
    return Obx(
      () => FilterChip(
        label: Text(label),
        selected: controller.filterStatus.value == value,
        onSelected: (_) => controller.setFilter(value),
        selectedColor: colorScheme.primary.withOpacity(0.3),
        labelStyle: TextStyle(
          color: controller.filterStatus.value == value
              ? colorScheme.primary
              : Colors.grey[600],
          fontWeight: controller.filterStatus.value == value
              ? FontWeight.bold
              : FontWeight.normal,
        ),
        side: BorderSide(
          color: controller.filterStatus.value == value
              ? colorScheme.primary
              : Colors.grey[300]!,
        ),
      ),
    );
  }

  // Build history card
  Widget _buildHistoryCard(
    HistoryItem item,
    ColorScheme colorScheme,
    BuildContext context,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon dengan background
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getIconData(item.icon),
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                
                // Title dan description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _parseColor(controller.getStatusColor(item.status))
                        .withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    controller.getStatusLabel(item.status),
                    style: TextStyle(
                      color: _parseColor(controller.getStatusColor(item.status)),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Divider
            Divider(
              height: 0,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 12),
            
            // Footer dengan tanggal dan action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatDate(item.date),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                GestureDetector(
                  onTap: () => controller.deleteHistoryItem(item.id),
                  child: Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Colors.red[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk konversi hex color ke Color
  Color _parseColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexColor', radix: 16));
  }

  // Helper untuk get icon dari string
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'shopping_bag':
        return Icons.shopping_bag_outlined;
      case 'payment':
        return Icons.payment_outlined;
      case 'assignment_return':
        return Icons.assignment_return_outlined;
      case 'local_shipping':
        return Icons.local_shipping_outlined;
      case 'download':
        return Icons.download_outlined;
      case 'cancel':
        return Icons.cancel_outlined;
      default:
        return Icons.history;
    }
  }

  // Helper untuk format tanggal
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return 'Baru saja';
      }
      return '${difference.inHours} jam lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
