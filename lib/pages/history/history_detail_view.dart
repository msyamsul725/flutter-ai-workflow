import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'history_detail_controller.dart';
import 'package:flutter_ai_workflow/pages/history/history_controller.dart';

class HistoryDetailView extends GetView<HistoryDetailController> {
  const HistoryDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat'),
        backgroundColor: colorScheme.primary,
        centerTitle: true,
      ),
      body: Obx(() {
        final item = controller.selectedItem.value;
        if (item == null) {
          return const Center(child: Text('Data tidak tersedia'));
        }

        // Tampilkan detail sederhana dari item history
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(item.description),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      Get.find<HistoryController>().getStatusLabel(item.status),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(controller.formattedDate),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => controller.delete(),
                icon: const Icon(Icons.delete_outline),
                label: const Text('Hapus riwayat ini'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
