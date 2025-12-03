import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:sizer/sizer.dart';
import '../router/navigation_helpers.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  Map<String, String> _registeredUsers = {};

  // --- PALET WARNA MEWAH ---
  final Color _bgCream = const Color(0xFFFFF3E0);
  final Color _bgPeach = const Color(0xFFFFE0B2);
  final Color _textChocolate = const Color(0xFF5D4037);
  final Color _accentGold = const Color(0xFFD4AF37);

  @override
  void initState() {
    super.initState();
    _loadRegisteredUsers();
  }

  Future<void> _loadRegisteredUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('registered_users');
    if (raw != null && raw.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = json.decode(raw);
        setState(() {
          _registeredUsers = decoded.map((k, v) => MapEntry(k, v.toString()));
        });
      } catch (_) {
        setState(() {
          _registeredUsers = {};
        });
      }
    }
  }

  void _login() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Password tidak boleh kosong")),
      );
      return;
    }
    if (!_registeredUsers.containsKey(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Akun tidak ditemukan. Silakan register terlebih dahulu.",
          ),
        ),
      );
      return;
    }

    if (_registeredUsers[email] != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password salah. Coba lagi.")),
      );
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Login berhasil sebagai $email")));

    context.toHome(email: email);
  }

  void _goToRegister() {
    context.toRegister();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double formWidth = width > 600 ? 420 : width * 0.95;

    return Scaffold(
      // Background scaffold dihilangkan karena kita pakai Container gradient
      body: Stack(
        children: [
          // 1. Background Gradient (Selaras dengan Splash Screen)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_bgCream, _bgPeach],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 2. Form Content
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: formWidth,
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9), // Glass effect
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: _textChocolate.withOpacity(0.15), // Shadow Coklat
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/logo.png', height: 18.h, width: 36.w),
                    SizedBox(height: 2.h),
                    
                    // Font Playfair Display untuk kesan mewah
                    Text(
                      "Selamat Datang",
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _textChocolate,
                        letterSpacing: 1.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "RISE BAKERY",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: _accentGold,
                        letterSpacing: 2.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Input Email
                    TextField(
                      controller: emailController,
                      style: GoogleFonts.poppins(fontSize: 16, color: _textChocolate),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Email / Nama",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: _textChocolate.withOpacity(0.7),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: _textChocolate.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: _accentGold,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(Icons.person_outline, color: _accentGold),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Input Password
                    TextField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      style: GoogleFonts.poppins(fontSize: 16, color: _textChocolate),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: "Password",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: _textChocolate.withOpacity(0.7),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 20),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: _textChocolate.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: _accentGold,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock_outline, color: _accentGold),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure ? Icons.visibility_off : Icons.visibility,
                            color: _textChocolate.withOpacity(0.5),
                          ),
                          onPressed: () =>
                              setState(() => _isObscure = !_isObscure),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Tombol Login (Coklat Mewah)
                    GFButton(
                      onPressed: _login,
                      text: "Login",
                      icon: const Icon(Icons.login, color: Colors.white),
                      fullWidthButton: true,
                      size: GFSize.LARGE,
                      color: _textChocolate, // Menggunakan warna coklat tema
                      elevation: 8,
                      shape: GFButtonShape.pills,
                      textStyle: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),

                    const SizedBox(height: 16),
                    
                    // Tombol Register
                    TextButton(
                      onPressed: _goToRegister,
                      child: RichText(
                        text: TextSpan(
                          text: "Belum punya akun? ",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: _textChocolate.withOpacity(0.7),
                          ),
                          children: [
                            TextSpan(
                              text: "Register di sini",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: _accentGold,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}