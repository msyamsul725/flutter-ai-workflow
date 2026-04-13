import 'package:get/get.dart';

// Controller untuk halaman Detail Notifikasi - menandakan notifikasi yang unit test-nya di-skip
class DetailNotifikasiSkipUnitTestController extends GetxController {
  // Judul notifikasi (reaktif)
  final title = 'Detail Notifikasi'.obs;

  // Menandakan apakah unit test untuk notifikasi ini di-skip
  final isSkipped = true.obs;

  // Toggle flag skip
  void toggleSkip() {
    isSkipped.value = !isSkipped.value;
  }

  // Memuat data notifikasi berdasarkan id (dummy implementation)
  void loadNotification(String id) {
    // Mengubah judul sesuai id yang diminta
    title.value = 'Notifikasi #$id';
  }
}
