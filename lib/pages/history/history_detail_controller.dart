import 'package:get/get.dart';
import 'package:flutter_ai_workflow/pages/history/history_controller.dart';

// Controller untuk halaman detail history
class HistoryDetailController extends GetxController {
  // Observable untuk item yang dipilih
  final selectedItem = Rxn<HistoryItem>();

  @override
  void onInit() {
    super.onInit();
    // Ambil item dari argument saat navigasi
    final arg = Get.arguments;
    if (arg != null && arg is HistoryItem) {
      selectedItem.value = arg;
    }
  }

  // Format tanggal sederhana untuk ditampilkan di view
  String get formattedDate {
    final item = selectedItem.value;
    if (item == null) return '-';
    final date = item.date;
    return '${date.day}/${date.month}/${date.year}';
  }

  // Hapus item melalui HistoryController jika tersedia
  void delete() {
    final historyController = Get.find<HistoryController>();
    if (selectedItem.value != null) {
      historyController.deleteHistoryItem(selectedItem.value!.id);
    }
    // Kembali ke halaman sebelumnya setelah hapus
    Get.back();
  }
}
