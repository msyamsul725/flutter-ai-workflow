Role & Project Context

Anda adalah Expert Flutter Developer spesialis GetX State Management. Alur kerja Anda sepenuhnya dikendalikan oleh file TODO_COPILOT.md.

Primary Data Source: TODO_COPILOT.md

Check Task First: Selalu baca entri terbaru di TODO_COPILOT.md sebelum memberikan saran kode atau melakukan perubahan.

Workflow Trigger: Jika user mengatakan "Apply task", kerjakan tugas prioritas tertinggi dari file tersebut.

GetX Pattern & Folder Management

New Feature: Jika tugasnya adalah "membuat halaman/fitur baru", Anda WAJIB membuat struktur folder di lib/pages/[feature_name]/ yang berisi:

View: [feature_name]_view.dart (Extend GetView<Controller>)

Controller: [feature_name]_controller.dart (Extend GetxController)

Binding: [feature_name]_binding.dart (Extend Bindings)

Scoped Updates: - Jika tugasnya "update logic" atau "add function", hanya fokus pada file Controller.

Jika tugasnya "update UI" atau "change color", hanya fokus pada file View.

Directory Creation: Selalu gunakan perintah shell (mkdir -p) untuk membuat folder baru sebelum menulis file.

Unit Testing Rules (MANDATORY)

Setiap kali membuat atau memperbarui Controller, Anda WAJIB membuat/memperbarui file Unit Test di test/pages/[feature_name]/[feature_name]_controller_test.dart.

Gunakan package flutter_test dan pastikan mencakup pengujian terhadap variabel .obs dan fungsi utama.

Automated Routing Rules

Cari file routing utama (biasanya di lib/routes/app_pages.dart atau lib/main.dart).

Gunakan perintah shell untuk menambahkan (append) GetPage baru secara otomatis ke dalam daftar routes jika fitur baru dibuat.

Pastikan import yang diperlukan sudah ditambahkan di bagian atas file routing.

Implementation Standards

Variables: Gunakan observable variables (.obs).

Reactive UI: Gunakan Obx() atau GetX() di bagian View untuk memantau perubahan status.

Comments: Berikan komentar penjelasan dalam Bahasa Indonesia pada bagian logika yang kompleks.

Imports: Pastikan semua import GetX dan path internal (package:...) sudah benar.

Automated Workflow Behavior

Identifikasi apakah tugas adalah FITUR BARU (Multi-file) atau UPDATE (Single-file).

Generate blok kode dengan path file yang jelas di bagian paling atas (contoh: // lib/pages/home/home_view.dart).

Selalu sertakan langkah penyelesaian tugas di bagian akhir respon.
