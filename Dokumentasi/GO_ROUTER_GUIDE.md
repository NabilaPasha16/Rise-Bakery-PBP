# GoRouter Implementation Guide

## 📋 Daftar Rute

| Rute | Path | Parameter | Deskripsi |
|------|------|-----------|-----------|
| Splash | `/splash` | - | Halaman splash screen |
| Login | `/login` | - | Halaman login |
| Register | `/register` | - | Halaman registrasi |
| Home | `/home` | `email` (String) | Halaman utama |
| Detail | `/detail` | `cake` (Cake) | Halaman detail kue |
| Cart | `/cart` | `items` (List<Cake>), `buyNowItem` (Cake) | Halaman keranjang |
| Category | `/category` | `category` (String), `cakes` (List<Cake>) | Halaman kategori |
| Profile | `/profile` | `email` (String) | Halaman profil |
| API Cakes | `/api-cakes` | - | Halaman API kue |

---

## 🚀 Cara Menggunakan

### 1. Menggunakan Extension Helper (Rekomendasi)

Extension `NavigationExtension` memberikan cara yang paling mudah dan clean untuk navigasi:

```dart
import 'package:flutter/material.dart';
import 'router/navigation_helpers.dart';

// Navigasi ke halaman lain
context.toSplash();      // Ke Splash
context.toLogin();       // Ke Login
context.toRegister();    // Ke Register
context.toHome();        // Ke Home
context.toApiCakes();    // Ke API Cakes
context.back();          // Kembali ke halaman sebelumnya

// Dengan parameter
context.toHome(email: 'user@example.com');
context.toDetail(cake: myCake);
context.toProfile(email: 'user@example.com');
context.toCategory(category: 'Chocolate', cakes: cakeList);
context.toCart(items: cartItems, buyNowItem: myCake);
```

### 2. Menggunakan AppNavigation Class

```dart
import 'router/navigation_helpers.dart';

// Navigasi ke halaman lain
AppNavigation.toSplash(context);
AppNavigation.toLogin(context);
AppNavigation.toRegister(context);
AppNavigation.toHome(context, email: 'user@example.com');
AppNavigation.toDetail(context, cake: myCake);
AppNavigation.toProfile(context, email: 'user@example.com');
AppNavigation.toCategory(context, category: 'Chocolate', cakes: cakeList);
AppNavigation.toCart(context, items: cartItems, buyNowItem: myCake);
AppNavigation.back(context);
```

### 3. Menggunakan GoRouter Langsung

```dart
import 'package:go_router/go_router.dart';

// Navigasi basic
context.pushRoute('/login');           // Push rute ke stack
context.goRoute('/home', extra: 'email@example.com'); // Replace rute
context.replaceRoute('/splash');       // Replace rute saat ini
context.popRoute();                    // Kembali ke halaman sebelumnya

// Dengan nama rute (jika menggunakan named routes)
context.goRouteNamed('home', 
  pathParameters: {},
  queryParameters: {},
  extra: 'email@example.com'
);
```

---

## 📱 Contoh Implementasi pada Page

### Contoh di Detail Page

```dart
import 'package:flutter/material.dart';
import 'router/navigation_helpers.dart';

class DetailPage extends StatefulWidget {
  final Cake cake;
  
  const DetailPage({required this.cake});
  
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.back(),  // Kembali ke halaman sebelumnya
        ),
      ),
      body: Column(
        children: [
          // Konten detail
          ElevatedButton(
            onPressed: () {
              // Tambah ke cart
              context.toCart(buyNowItem: widget.cake);
            },
            child: const Text('Buy Now'),
          ),
        ],
      ),
    );
  }
}
```

### Contoh di Home Page (untuk navigasi)

```dart
import 'package:flutter/material.dart';
import 'router/navigation_helpers.dart';

class HomePage extends StatefulWidget {
  final String email;
  
  const HomePage({required this.email});
  
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Grid atau List of cakes
          GestureDetector(
            onTap: () {
              // Navigasi ke detail page dengan membawa data cake
              context.toDetail(cake: cake);
            },
            child: CakeCard(cake: cake),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
            onTap: () => context.toCart(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
            onTap: () => context.toProfile(email: widget.email),
          ),
        ],
      ),
    );
  }
}
```

### Contoh di Splash Screen

```dart
import 'package:flutter/material.dart';
import 'router/navigation_helpers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    
    // Setelah 3 detik, navigasi ke login
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.toLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // UI Splash Screen
    );
  }
}
```

### Contoh di Login Page

```dart
import 'package:flutter/material.dart';
import 'router/navigation_helpers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _handleLogin(String email) {
    // Validate dan proses login
    // Jika berhasil:
    context.toHome(email: email);
    
    // Atau ke register jika belum punya akun:
    // context.toRegister();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Login form
          ElevatedButton(
            onPressed: () => context.toRegister(),
            child: const Text('Belum punya akun? Daftar'),
          ),
        ],
      ),
    );
  }
}
```

---

## 🎯 Best Practices

1. **Selalu gunakan extension** - Lebih clean dan readable
   ```dart
   context.toHome();  // ✅ Rekomendasi
   GoRouter.of(context).go('/home');  // ❌ Hindari
   ```

2. **Pass data sebagai extra** - Jangan hardcode data
   ```dart
   context.toDetail(cake: cake);  // ✅ Benar
   // ❌ Jangan: context.goRoute('/detail?id=${cake.id}');
   ```

3. **Handle null values** - Selalu check parameter optional
   ```dart
   final email = state.extra as String? ?? 'default@example.com';
   ```

4. **Gunakan immutable models** - Pastikan Cake model adalah immutable
   ```dart
   @immutable
   class Cake {
     final String name;
     // ...
   }
   ```

5. **Error handling** - GoRouter sudah handle invalid routes dengan error builder

---

## 🔧 Troubleshooting

### Issue: Page tidak terupdate setelah navigasi
**Solusi**: Pastikan BuildContext yang digunakan berada di widget yang tepat (bukan di parent yang tidak rebuild)

### Issue: Parameter tidak ter-pass dengan benar
**Solusi**: Pastikan type parameter sesuai dengan yang didefinisikan di router

### Issue: Back button tidak bekerja
**Solusi**: Gunakan `context.back()` atau `context.popRoute()` untuk navigasi back

---

## 📚 Referensi Struktur Router

File: `lib/router/app_router.dart` - Definisi semua routes
File: `lib/router/navigation_helpers.dart` - Helper dan extensions untuk navigasi
