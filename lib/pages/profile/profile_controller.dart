import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Observable variables
  final isLoading = false.obs;
  final isEditMode = false.obs;
  final userName = 'Ahmad Rizki'.obs;
  final userEmail = 'ahmad.rizki@example.com'.obs;
  final userPhone = '+62 812 3456 7890'.obs;
  final userLocation = 'Jakarta, Indonesia'.obs;
  final userBio = 'Flutter Developer | AI Enthusiast'.obs;
  final notificationsEnabled = true.obs;
  final darkModeEnabled = false.obs;

  // Editing controllers
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController locationController;
  late TextEditingController bioController;

  @override
  void onInit() {
    super.onInit();
    _initializeEditingControllers();
  }

  void _initializeEditingControllers() {
    nameController = TextEditingController(text: userName.value);
    phoneController = TextEditingController(text: userPhone.value);
    locationController = TextEditingController(text: userLocation.value);
    bioController = TextEditingController(text: userBio.value);
  }

  void toggleEditMode() {
    if (isEditMode.value) {
      // Save changes
      userName.value = nameController.text;
      userPhone.value = phoneController.text;
      userLocation.value = locationController.text;
      userBio.value = bioController.text;
      Get.snackbar(
        'Success',
        'Profil berhasil diperbarui',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      // Enter edit mode
      _initializeEditingControllers();
    }
    isEditMode.toggle();
  }

  void toggleNotifications() {
    notificationsEnabled.toggle();
    Get.snackbar(
      'Success',
      'Pengaturan notifikasi diperbarui',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleDarkMode() {
    darkModeEnabled.toggle();
    Get.snackbar(
      'Success',
      'Mode gelap ${darkModeEnabled.value ? "diaktifkan" : "dinonaktifkan"}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> changePassword() async {
    Get.snackbar(
      'Info',
      'Fitur ubah password belum tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Implement change password functionality
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      // Simulasi logout delay
      await Future.delayed(const Duration(seconds: 1));
      Get.snackbar(
        'Success',
        'Logout berhasil',
        snackPosition: SnackPosition.BOTTOM,
      );
      // TODO: Navigate ke login page dan hapus session
      // Get.offNamed(Routes.LOGIN);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAccount() async {
    Get.snackbar(
      'Info',
      'Fitur hapus akun belum tersedia',
      snackPosition: SnackPosition.BOTTOM,
    );
    // TODO: Implement delete account functionality
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    bioController.dispose();
    super.onClose();
  }
}
