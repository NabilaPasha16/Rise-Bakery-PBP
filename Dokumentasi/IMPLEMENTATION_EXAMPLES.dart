/// Contoh Implementasi GoRouter di berbagai page
///
/// File ini menunjukkan best practices untuk menggunakan GoRouter
/// di berbagai skenario dalam aplikasi Rise Bakery

// ============================================
// CONTOH 1: Login Page dengan Navigasi
// ============================================

/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../router/navigation_helpers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password tidak boleh kosong')),
      );
      return;
    }

    // TODO: Proses login dengan API
    // Jika berhasil, navigasi ke Home dengan membawa email
    context.toHome(email: email);
    
    // Atau jika ingin logout di Home:
    // context.toHome(email: email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            // Tombol ke Register Page
            TextButton(
              onPressed: () => context.toRegister(),
              child: const Text('Belum punya akun? Daftar di sini'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
*/

// ============================================
// CONTOH 2: Register Page dengan onRegister Callback
// ============================================

/*
import 'package:flutter/material.dart';
import '../router/navigation_helpers.dart';

class RegisterPageWithGoRouter extends StatefulWidget {
  const RegisterPageWithGoRouter({super.key});

  @override
  State<RegisterPageWithGoRouter> createState() =>
      _RegisterPageWithGoRouterState();
}

class _RegisterPageWithGoRouterState extends State<RegisterPageWithGoRouter> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleRegister() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password tidak boleh kosong')),
      );
      return;
    }

    // TODO: Proses register dengan API
    // Jika berhasil, kembali ke login page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil! Silakan login')),
    );
    
    // Navigasi kembali ke Login page
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        context.toLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _handleRegister,
              child: const Text('Register'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.back(),
              child: const Text('Kembali'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
*/

// ============================================
// CONTOH 3: Home Page dengan Multiple Navigation
// ============================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart_cubit.dart';
import '../model/cake.dart';
import '../router/navigation_helpers.dart';

class HomePageWithGoRouter extends StatefulWidget {
  final String email;

  const HomePageWithGoRouter({super.key, required this.email});

  @override
  State<HomePageWithGoRouter> createState() => _HomePageWithGoRouterState();
}

class _HomePageWithGoRouterState extends State<HomePageWithGoRouter> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          // Tombol ke Profile
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.toProfile(email: widget.email),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                // Cake item example
                final cake = Cake(
                  id: index,
                  name: 'Cake $index',
                  price: 50000,
                  image: 'assets/cake.jpg',
                  description: 'Delicious cake',
                );

                return GestureDetector(
                  onTap: () {
                    // Navigasi ke Detail Page dengan membawa data cake
                    context.toDetail(cake: cake);
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            cake.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(cake.name),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 10,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          
          switch (index) {
            case 0:
              // Home (refresh current page atau tetap di home)
              break;
            case 1:
              // Cart Page
              context.toCart();
              break;
            case 2:
              // Profile Page
              context.toProfile(email: widget.email);
              break;
            case 3:
              // API Cakes Page
              context.toApiCakes();
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.api), label: 'API'),
        ],
      ),
    );
  }
}
*/

// ============================================
// CONTOH 4: Detail Page dengan Back Navigation
// ============================================

/*
import 'package:flutter/material.dart';
import '../model/cake.dart';
import '../router/navigation_helpers.dart';

class DetailPageWithGoRouter extends StatefulWidget {
  final Cake cake;

  const DetailPageWithGoRouter({super.key, required this.cake});

  @override
  State<DetailPageWithGoRouter> createState() =>
      _DetailPageWithGoRouterState();
}

class _DetailPageWithGoRouterState extends State<DetailPageWithGoRouter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Kembali ke halaman sebelumnya
            context.back();
            // Atau gunakan:
            // context.popRoute();
          },
        ),
        title: Text(widget.cake.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.cake.image),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.cake.name,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Price: \$${widget.cake.price}'),
                  const SizedBox(height: 16),
                  Text(widget.cake.description),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Tambah ke cart dan navigasi ke cart page
                        context.toCart(buyNowItem: widget.cake);
                      },
                      child: const Text('Buy Now'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        // Kembali ke home (atau previous page)
                        context.back();
                      },
                      child: const Text('Continue Shopping'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

// ============================================
// CONTOH 5: Category Page dengan Dynamic Data
// ============================================

/*
import 'package:flutter/material.dart';
import '../model/cake.dart';
import '../router/navigation_helpers.dart';

class CategoryPageWithGoRouter extends StatefulWidget {
  final String category;
  final List<Cake> cakes;

  const CategoryPageWithGoRouter({
    super.key,
    required this.category,
    required this.cakes,
  });

  @override
  State<CategoryPageWithGoRouter> createState() =>
      _CategoryPageWithGoRouterState();
}

class _CategoryPageWithGoRouterState extends State<CategoryPageWithGoRouter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.back(),
        ),
        title: Text(widget.category),
      ),
      body: ListView.builder(
        itemCount: widget.cakes.length,
        itemBuilder: (context, index) {
          final cake = widget.cakes[index];
          return ListTile(
            title: Text(cake.name),
            subtitle: Text('\$${cake.price}'),
            onTap: () {
              // Navigasi ke detail page
              context.toDetail(cake: cake);
            },
          );
        },
      ),
    );
  }
}
*/

// ============================================
// CONTOH 6: Cart Page dengan Multiple Items
// ============================================

/*
import 'package:flutter/material.dart';
import '../model/cake.dart';
import '../router/navigation_helpers.dart';

class CartPageWithGoRouter extends StatefulWidget {
  final List<Cake>? items;
  final Cake? buyNowItem;

  const CartPageWithGoRouter({
    super.key,
    this.items,
    this.buyNowItem,
  });

  @override
  State<CartPageWithGoRouter> createState() => _CartPageWithGoRouterState();
}

class _CartPageWithGoRouterState extends State<CartPageWithGoRouter> {
  late List<Cake> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = [];
    
    if (widget.buyNowItem != null) {
      _cartItems.add(widget.buyNowItem!);
    }
    
    if (widget.items != null) {
      _cartItems.addAll(widget.items!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.back(),
        ),
        title: const Text('Cart'),
      ),
      body: _cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Cart is empty'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.back(),
                    child: const Text('Continue Shopping'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                final item = _cartItems[index];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text('\$${item.price}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() => _cartItems.removeAt(index));
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: _cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Proses checkout
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checkout successful!')),
                  );
                  // Kembali ke home
                  context.toHome();
                },
                child: const Text('Checkout'),
              ),
            ),
    );
  }
}
*/

// ============================================
// CONTOH 7: Profile Page
// ============================================

/*
import 'package:flutter/material.dart';
import '../router/navigation_helpers.dart';

class ProfilePageWithGoRouter extends StatefulWidget {
  final String email;

  const ProfilePageWithGoRouter({super.key, required this.email});

  @override
  State<ProfilePageWithGoRouter> createState() =>
      _ProfilePageWithGoRouterState();
}

class _ProfilePageWithGoRouterState extends State<ProfilePageWithGoRouter> {
  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigasi ke login page setelah logout
              context.toLogin();
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.back(),
        ),
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${widget.email}'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
