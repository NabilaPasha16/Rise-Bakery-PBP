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
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        title: Text(
          'Register',
          style: GoogleFonts.poppins(color: Colors.pink[400]),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.pink[300]),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: formWidth,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.92 * 255).round()),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withAlpha((0.08 * 255).round()),
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
                Text(
                  'Daftar Akun',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink[400],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: emailController,
                  style: GoogleFonts.poppins(fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.pink[50],
                    labelText: 'Email',
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.pink[300],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: GoogleFonts.poppins(fontSize: 16),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.pink[50],
                    labelText: 'Password',
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.pink[300],
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink[300],
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
