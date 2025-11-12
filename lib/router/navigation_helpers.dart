import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../model/cake.dart';

/// Helper class untuk navigasi menggunakan GoRouter
class AppNavigation {
  /// Navigasi ke Splash Screen
  static void toSplash(BuildContext context) {
    GoRouter.of(context).go('/splash');
  }

  /// Navigasi ke Login Page
  static void toLogin(BuildContext context) {
    GoRouter.of(context).go('/login');
  }

  /// Navigasi ke Register Page
  static void toRegister(BuildContext context) {
    GoRouter.of(context).go('/register');
  }

  /// Navigasi ke Home Page
  /// [email] - Email pengguna
  static void toHome(BuildContext context, {String? email}) {
    GoRouter.of(context).go('/home', extra: email);
  }

  /// Navigasi ke Detail Page
  /// [cake] - Data kue yang akan ditampilkan
  static void toDetail(BuildContext context, {required Cake cake}) {
    GoRouter.of(context).go('/detail', extra: cake);
  }

  /// Navigasi ke Cart Page
  /// [items] - List item di cart (optional)
  /// [buyNowItem] - Item yang dibeli langsung (optional)
  static void toCart(
    BuildContext context, {
    List<Cake>? items,
    Cake? buyNowItem,
  }) {
    GoRouter.of(
      context,
    ).go('/cart', extra: {'items': items, 'buyNowItem': buyNowItem});
  }

  /// Navigasi ke Category Page
  /// [category] - Nama kategori
  /// [cakes] - List kue dalam kategori
  static void toCategory(
    BuildContext context, {
    required String category,
    required List<Cake> cakes,
  }) {
    GoRouter.of(
      context,
    ).go('/category', extra: {'category': category, 'cakes': cakes});
  }

  /// Navigasi ke Profile Page
  /// [email] - Email pengguna
  static void toProfile(BuildContext context, {String? email}) {
    GoRouter.of(context).go('/profile', extra: email);
  }

  /// Navigasi ke API Cakes Page
  static void toApiCakes(BuildContext context) {
    GoRouter.of(context).go('/api-cakes');
  }

  /// Navigasi ke halaman sebelumnya
  static void back(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      GoRouter.of(context).pop();
    }
  }
}

/// Extension untuk BuildContext untuk memudahkan navigasi
extension NavigationExtension on BuildContext {
  /// Navigasi ke Splash Screen
  void toSplash() => AppNavigation.toSplash(this);

  /// Navigasi ke Login Page
  void toLogin() => AppNavigation.toLogin(this);

  /// Navigasi ke Register Page
  void toRegister() => AppNavigation.toRegister(this);

  /// Navigasi ke Home Page
  void toHome({String? email}) => AppNavigation.toHome(this, email: email);

  /// Navigasi ke Detail Page
  void toDetail({required Cake cake}) =>
      AppNavigation.toDetail(this, cake: cake);

  /// Navigasi ke Cart Page
  void toCart({List<Cake>? items, Cake? buyNowItem}) =>
      AppNavigation.toCart(this, items: items, buyNowItem: buyNowItem);

  /// Navigasi ke Category Page
  void toCategory({required String category, required List<Cake> cakes}) =>
      AppNavigation.toCategory(this, category: category, cakes: cakes);

  /// Navigasi ke Profile Page
  void toProfile({String? email}) =>
      AppNavigation.toProfile(this, email: email);

  /// Navigasi ke API Cakes Page
  void toApiCakes() => AppNavigation.toApiCakes(this);

  /// Navigasi ke halaman sebelumnya
  void back() => AppNavigation.back(this);
}

/// Extension untuk BuildContext menggunakan GoRouter
extension GoRouterExtensionHelper on BuildContext {
  /// Go ke rute tertentu
  void goRoute(String location, {Object? extra}) =>
      GoRouter.of(this).go(location, extra: extra);

  /// Push ke rute tertentu
  void pushRoute(String location, {Object? extra}) =>
      GoRouter.of(this).push(location, extra: extra);

  /// Pop dari rute saat ini
  void popRoute<T extends Object?>([T? result]) =>
      GoRouter.of(this).pop(result);

  /// Cek apakah bisa pop
  bool canPopRoute() => GoRouter.of(this).canPop();

  /// Replace rute saat ini
  void replaceRoute(String location, {Object? extra}) =>
      GoRouter.of(this).replace(location, extra: extra);

  /// Go ke rute named
  void goRouteNamed(
    String name, {
    Map<String, String>? pathParameters,
    Map<String, dynamic>? queryParameters,
    Object? extra,
  }) => GoRouter.of(this).goNamed(
    name,
    pathParameters: pathParameters ?? {},
    queryParameters: queryParameters ?? {},
    extra: extra,
  );
}
