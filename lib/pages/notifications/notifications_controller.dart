import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'info', 'warning', 'success', 'error'
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

class NotificationsController extends GetxController {
  // Observable variables
  final notifications = <NotificationItem>[].obs;
  final isLoading = false.obs;
  final unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadNotifications();
  }

  void _loadNotifications() {
    isLoading.value = true;
    try {
      // Simulate loading notifications from API
      Future.delayed(const Duration(milliseconds: 500), () {
        notifications.addAll([
          NotificationItem(
            id: '1',
            title: 'Pembaruan Profil',
            message: 'Profil Anda telah berhasil diperbarui',
            timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
            type: 'success',
          ),
          NotificationItem(
            id: '2',
            title: 'Login Baru',
            message: 'Akun Anda login dari perangkat baru',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            type: 'info',
          ),
          NotificationItem(
            id: '3',
            title: 'Peringatan Keamanan',
            message: 'Kami mendeteksi aktivitas mencurigakan',
            timestamp: DateTime.now().subtract(const Duration(hours: 24)),
            type: 'warning',
          ),
          NotificationItem(
            id: '4',
            title: 'Transaksi Berhasil',
            message: 'Transaksi Rp 150.000 telah dikonfirmasi',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            type: 'success',
          ),
          NotificationItem(
            id: '5',
            title: 'Verifikasi Email',
            message: 'Silakan verifikasi email Anda',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            type: 'info',
          ),
        ]);
        _updateUnreadCount();
        isLoading.value = false;
      });
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat notifikasi');
      isLoading.value = false;
    }
  }

  void _updateUnreadCount() {
    unreadCount.value =
        notifications.where((n) => !n.isRead).toList().length;
  }

  void markAsRead(String notificationId) {
    final index =
        notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index].isRead = true;
      notifications.refresh();
      _updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    notifications.refresh();
    _updateUnreadCount();
    Get.snackbar(
      'Success',
      'Semua notifikasi telah ditandai sebagai dibaca',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void deleteNotification(String notificationId) {
    notifications.removeWhere((n) => n.id == notificationId);
    _updateUnreadCount();
    Get.snackbar(
      'Success',
      'Notifikasi dihapus',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void clearAllNotifications() {
    Get.dialog(
      AlertDialog(
        title: const Text('Hapus Semua Notifikasi'),
        content: const Text(
            'Apakah Anda yakin ingin menghapus semua notifikasi?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              notifications.clear();
              _updateUnreadCount();
              Get.snackbar(
                'Success',
                'Semua notifikasi telah dihapus',
                snackPosition: SnackPosition.BOTTOM,
              );
              Get.back();
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String getFormattedTime(DateTime timestamp) {
    return _formatTimestamp(timestamp);
  }
}
