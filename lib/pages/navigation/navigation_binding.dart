import 'package:flutter_ai_workflow/pages/cart/cart_controller.dart';
import 'package:flutter_ai_workflow/pages/history/history_controller.dart';
import 'package:flutter_ai_workflow/pages/home/home_controller.dart';
import 'package:flutter_ai_workflow/pages/notifications/notifications_controller.dart';
import 'package:flutter_ai_workflow/pages/profile/profile_controller.dart' show ProfileController;
import 'package:get/get.dart';
import 'navigation_controller.dart';

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavigationController>(() => NavigationController());
      Get.lazyPut<ProfileController>(() => ProfileController());
        Get.lazyPut<HistoryController>(
      () => HistoryController());
       Get.lazyPut<CartController>(() => CartController());
        Get.lazyPut<HomeController>(() => HomeController());
            Get.lazyPut<NotificationsController>(() => NotificationsController());
    
  }
}
