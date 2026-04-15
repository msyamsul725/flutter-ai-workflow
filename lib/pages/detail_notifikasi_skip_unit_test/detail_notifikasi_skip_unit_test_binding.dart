import 'package:get/get.dart';
import 'package:flutter_ai_workflow/pages/detail_notifikasi_skip_unit_test/detail_notifikasi_skip_unit_test_controller.dart';

class DetailNotifikasiSkipUnitTestBinding extends Bindings {
  @override
  void dependencies() {
    // Mendaftarkan controller untuk halaman Detail Notifikasi
    Get.lazyPut<DetailNotifikasiSkipUnitTestController>(() => DetailNotifikasiSkipUnitTestController());
  }
}
