import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'profile_controller.dart';
import '../../widgets/bottom_navigation_widget.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isEditMode.value
                    ? Icons.check_rounded
                    : Icons.edit_outlined,
              ),
              onPressed: controller.toggleEditMode,
            ),
          ),
        ],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Profile Header
                    Center(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.primary.withOpacity(0.7),
                                ],
                              ),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.person,
                                  size: 60,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!controller.isEditMode.value)
                            Column(
                              children: [
                                Text(
                                  controller.userName.value,
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  controller.userEmail.value,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Editable Profile Information
                    if (controller.isEditMode.value) ...[
                      _buildEditField(
                        theme,
                        'Nama Lengkap',
                        controller.nameController,
                        Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildEditField(
                        theme,
                        'Nomor Telepon',
                        controller.phoneController,
                        Icons.phone_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildEditField(
                        theme,
                        'Lokasi',
                        controller.locationController,
                        Icons.location_on_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildEditField(
                        theme,
                        'Bio',
                        controller.bioController,
                        Icons.info_outline,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                    ] else ...[
                      // View Mode - Profile Details
                      _buildProfileSection(
                        theme,
                        colorScheme,
                        'Informasi Pribadi',
                        [
                          _buildDetailItem(
                            theme,
                            Icons.phone_outlined,
                            'Telepon',
                            controller.userPhone.value,
                          ),
                          Divider(color: Colors.grey[200]),
                          _buildDetailItem(
                            theme,
                            Icons.location_on_outlined,
                            'Lokasi',
                            controller.userLocation.value,
                          ),
                          Divider(color: Colors.grey[200]),
                          _buildDetailItem(
                            theme,
                            Icons.info_outline,
                            'Bio',
                            controller.userBio.value,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Settings Section
                      _buildProfileSection(
                        theme,
                        colorScheme,
                        'Pengaturan',
                        [
                          _buildSettingTile(
                            theme,
                            Icons.notifications_outlined,
                            'Notifikasi',
                            controller.notificationsEnabled,
                            () => controller.toggleNotifications(),
                          ),
                          Divider(color: Colors.grey[200]),
                          _buildSettingTile(
                            theme,
                            Icons.dark_mode_outlined,
                            'Mode Gelap',
                            controller.darkModeEnabled,
                            () => controller.toggleDarkMode(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Account Section
                      _buildProfileSection(
                        theme,
                        colorScheme,
                        'Akun',
                        [
                          _buildActionItem(
                            theme,
                            colorScheme,
                            Icons.lock_outline,
                            'Ubah Password',
                            () => controller.changePassword(),
                          ),
                          Divider(color: Colors.grey[200]),
                          _buildActionItem(
                            theme,
                            colorScheme,
                            Icons.logout_outlined,
                            'Logout',
                            () => controller.logout(),
                            isDanger: false,
                          ),
                          Divider(color: Colors.grey[200]),
                          _buildActionItem(
                            theme,
                            colorScheme,
                            Icons.delete_outline_rounded,
                            'Hapus Akun',
                            () => controller.deleteAccount(),
                            isDanger: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
      ),
      bottomNavigationBar: const BottomNavigationWidget(),
    );
  }

  Widget _buildEditField(
    ThemeData theme,
    String label,
    TextEditingController controller,
    IconData icon, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    List<Widget> children,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    ThemeData theme,
    IconData icon,
    String label,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    ThemeData theme,
    IconData icon,
    String label,
    RxBool value,
    VoidCallback onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Obx(
            () => Switch(
              value: value.value,
              onChanged: (_) => onChanged(),
              activeColor: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    ThemeData theme,
    ColorScheme colorScheme,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isDanger = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isDanger ? Colors.red : colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDanger ? Colors.red : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: isDanger ? Colors.red : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
