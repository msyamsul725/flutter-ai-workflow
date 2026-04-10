import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navigation_controller.dart';
import '../home/home_view.dart';
import '../notifications/notifications_view.dart';
import '../profile/profile_view.dart';

class NavigationView extends GetView<NavigationController> {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomeView(),
              NotificationsView(),
              ProfileView(),
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () => Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: BottomNavigationBar(
              elevation: 0,
              backgroundColor: Colors.white,
              selectedItemColor: colorScheme.primary,
              unselectedItemColor: Colors.grey[400],
              currentIndex: controller.selectedIndex.value,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_outlined),
                  activeIcon: const Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.notifications_outlined),
                  activeIcon: const Icon(Icons.notifications),
                  label: 'Notifikasi',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.person_outline),
                  activeIcon: const Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
              onTap: (index) {
                controller.switchTab(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
