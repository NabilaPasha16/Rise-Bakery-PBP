import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../router/navigation_helpers.dart';

class RegisterPage extends StatefulWidget {
  final Function(String, String) onRegister;
  const RegisterPage({super.key, required this.onRegister});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // --- PALET WARNA MEWAH ---
  final Color _bgCream = const Color(0xFFFFF3E0);
  final Color _bgPeach = const Color(0xFFFFE0B2);
  final Color _textChocolate = const Color(0xFF5D4037);
  final Color _accentGold = const Color(0xFFD4AF37);

  Future<void> _saveUserToPrefs(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('registered_users') ?? '{}';
    final Map<String, dynamic> users = json.decode(raw);
    users[email] = password;
    await prefs.setString('registered_users', json.encode(users));
  }

  void _register() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan Password tidak boleh kosong')),
      );
      return;
    }

    _saveUserToPrefs(email, password);
    widget.onRegister(email, password);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registrasi berhasil! Silakan login.')),
    );

    // Gunakan GoRouter untuk kembali ke login
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.toLogin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final formWidth = width > 600 ? 420.0 : width * 0.95;

    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient full screen
      appBar: AppBar(
        title: Text(
          'Register',
          style: GoogleFonts.playfairDisplay( // Font mewah
            color: _textChocolate,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent, // Transparan
        elevation: 0,
        iconTheme: IconThemeData(color: _textChocolate),
      ),
      body: Container(
        // Background Gradient Theme
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_bgCream, _bgPeach],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: formWidth,
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Glass effect
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: _textChocolate.withOpacity(0.15), // Shadow Coklat
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/logo.png', height: 100),
                  const SizedBox(height: 18),
                  
                  // Judul dengan Font Mewah
                  Text(
                    'Buat Akun Baru',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: _textChocolate,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    "Join Rise Bakery Family",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: _accentGold,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Input Email
                  TextField(
                    controller: emailController,
                    style: GoogleFonts.poppins(fontSize: 16, color: _textChocolate),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Email',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _textChocolate.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(Icons.email_outlined, color: _accentGold),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: _textChocolate.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: _accentGold, width: 2),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Input Password
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: GoogleFonts.poppins(fontSize: 16, color: _textChocolate),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Password',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: _textChocolate.withOpacity(0.7),
                      ),
                      prefixIcon: Icon(Icons.lock_outline, color: _accentGold),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: _textChocolate.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: _accentGold, width: 2),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Tombol Register
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _textChocolate, // Warna Coklat Mewah
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 5,
                        shadowColor: _textChocolate.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Daftar Sekarang',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}