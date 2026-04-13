import 'package:get/get.dart';
import '../pages/login/login_view.dart';
import '../pages/login/login_binding.dart';
import '../pages/navigation/navigation_view.dart';
import '../pages/navigation/navigation_binding.dart';
import '../pages/home/home_view.dart';
import '../pages/home/home_binding.dart';
import '../pages/notifications/notifications_view.dart';
import '../pages/notifications/notifications_binding.dart';
import '../pages/history/history_view.dart';
import '../pages/history/history_binding.dart';
import '../pages/history/history_detail_view.dart';
import '../pages/history/history_detail_binding.dart';
import '../pages/profile/profile_view.dart';
import '../pages/profile/profile_binding.dart';
import '../pages/cart/cart_view.dart';
import '../pages/cart/cart_binding.dart';

abstract class AppPages {
  static const initial = Routes.navigation;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.navigation,
      page: () => const NavigationView(),
      binding: NavigationBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.notification,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: Routes.history,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.history_detail,
      page: () => const HistoryDetailView(),
      binding: HistoryDetailBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.cart,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
  ];
}

abstract class Routes {
  static const login = '/login';
  static const navigation = '/navigation';
  static const home = '/home';
  static const notification = '/notification';
  static const history = '/history';
  static const history_detail = '/history/detail';
  static const profile = '/profile';
  static const cart = '/cart';
}
