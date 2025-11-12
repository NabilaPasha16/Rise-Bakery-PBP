import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/splash_screen.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/home_page.dart';
import '../pages/detail_page.dart';
import '../pages/cart_page.dart';
import '../pages/category_page.dart';
import '../pages/profile_page.dart';
import '../pages/api_cakes_page.dart';
import '../model/cake.dart';
import '../services/api_service.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) {
          return RegisterPage(
            onRegister: (email, password) {
              // Handle registration logic here
              // Then navigate to home or login
              context.go('/login');
            },
          );
        },
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) {
          final email = state.extra as String? ?? 'user@example.com';
          return HomePage(email: email);
        },
      ),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final cake = state.extra as Cake?;
          if (cake != null) {
            return DetailPage(cake: cake);
          }
          return const Scaffold(body: Center(child: Text('Cake not found')));
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return CartPage(
            items: extra?['items'] as List<Cake>?,
            buyNowItem: extra?['buyNowItem'] as Cake?,
          );
        },
      ),
      GoRoute(
        path: '/category',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final category = extra?['category'] as String? ?? '';
          final cakes = extra?['cakes'] as List<Cake>? ?? [];
          return CategoryPage(category: category, cakes: cakes);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) {
          final email = state.extra as String? ?? 'user@example.com';
          return ProfilePage(email: email);
        },
      ),
      GoRoute(
        path: '/api-cakes',
        builder: (context, state) {
          return ApiCakesPage(apiService: ApiService());
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Page not found'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
