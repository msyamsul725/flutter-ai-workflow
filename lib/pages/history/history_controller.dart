import 'package:get/get.dart';

// Model untuk History Item
class HistoryItem {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String status;
  final String icon;

  HistoryItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.icon,
  });
}

class HistoryController extends GetxController {
  // Observable untuk daftar history items
  final historyItems = <HistoryItem>[].obs;
  
  // Observable untuk loading state
  final isLoading = false.obs;
  
  // Observable untuk filter status
  final filterStatus = 'all'.obs;
  
  // Observable untuk search query
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistoryData();
  }

  // Load history data dari backend/database
  Future<void> _loadHistoryData() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Simulasi data history
      final mockData = [
        HistoryItem(
          id: '1',
          title: 'Pembelian Produk A',
          description: 'Pesanan berhasil diproses',
          date: DateTime.now().subtract(const Duration(days: 1)),
          status: 'completed',
          icon: 'shopping_bag',
        ),
        HistoryItem(
          id: '2',
          title: 'Pembayaran Faktur',
          description: 'Pembayaran berhasil diterima',
          date: DateTime.now().subtract(const Duration(days: 3)),
          status: 'completed',
          icon: 'payment',
        ),
        HistoryItem(
          id: '3',
          title: 'Retur Barang',
          description: 'Proses retur sedang diproses',
          date: DateTime.now().subtract(const Duration(days: 5)),
          status: 'pending',
          icon: 'assignment_return',
        ),
        HistoryItem(
          id: '4',
          title: 'Pembelian Produk B',
          description: 'Pesanan sedang dalam pengiriman',
          date: DateTime.now().subtract(const Duration(days: 7)),
          status: 'in_progress',
          icon: 'local_shipping',
        ),
        HistoryItem(
          id: '5',
          title: 'Download Invoice',
          description: 'File invoice berhasil diunduh',
          date: DateTime.now().subtract(const Duration(days: 10)),
          status: 'completed',
          icon: 'download',
        ),
        HistoryItem(
          id: '6',
          title: 'Pembatalan Pesanan',
          description: 'Pesanan dibatalkan atas permintaan',
          date: DateTime.now().subtract(const Duration(days: 15)),
          status: 'cancelled',
          icon: 'cancel',
        ),
      ];
      
      historyItems.addAll(mockData);
    } finally {
      isLoading.value = false;
    }
  }

  // Filter history berdasarkan status
  void setFilter(String status) {
    filterStatus.value = status;
  }

  // Cari history berdasarkan query
  void searchHistory(String query) {
    searchQuery.value = query;
  }

  // Get filtered dan searched items
  List<HistoryItem> get filteredItems {
    var items = historyItems.where((item) {
      final statusMatch = filterStatus.value == 'all' || 
                         item.status == filterStatus.value;
      final searchMatch = searchQuery.value.isEmpty ||
                         item.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                         item.description.toLowerCase().contains(searchQuery.value.toLowerCase());
      return statusMatch && searchMatch;
    }).toList();
    
    // Urutkan berdasarkan tanggal terbaru
    items.sort((a, b) => b.date.compareTo(a.date));
    return items;
  }

  // Get status color
  String getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return '#4CAF50';
      case 'in_progress':
        return '#FF9800';
      case 'pending':
        return '#2196F3';
      case 'cancelled':
        return '#F44336';
      default:
        return '#9E9E9E';
    }
  }

  // Get status label
  String getStatusLabel(String status) {
    switch (status) {
      case 'completed':
        return 'Selesai';
      case 'in_progress':
        return 'Proses';
      case 'pending':
        return 'Menunggu';
      case 'cancelled':
        return 'Dibatalkan';
      default:
        return status;
    }
  }

  // Refresh history data
  Future<void> refreshHistory() async {
    historyItems.clear();
    await _loadHistoryData();
  }

  // Delete history item
  void deleteHistoryItem(String id) {
    historyItems.removeWhere((item) => item.id == id);
  }

  // Clear all history
  Future<void> clearAllHistory() async {
    historyItems.clear();
  }
}
