import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ai_workflow/pages/detail_notifikasi_skip_unit_test/detail_notifikasi_skip_unit_test_controller.dart';

class DetailNotifikasiSkipUnitTestView extends GetView<DetailNotifikasiSkipUnitTestController> {
  const DetailNotifikasiSkipUnitTestView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // UI reaktif menggunakan Obx untuk menampilkan perubahan controller
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => Text('Status skip unit test: ${controller.isSkipped.value ? "DI-SKIP" : "AKTIF"}')),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: controller.toggleSkip,
              child: const Text('Toggle Skip'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => controller.loadNotification('123'),
              child: const Text('Load contoh notifikasi'),
            ),
          ],
        ),
      ),
    );
  }
}
