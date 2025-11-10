import 'package:flutter/material.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


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
        // ignore malformed stored data
        setState(() {
          _registeredUsers = {};
        });
      }
    }
  }

  Future<void> _saveUserToPrefs(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    _registeredUsers[email] = password;
    await prefs.setString('registered_users', json.encode(_registeredUsers));
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
    // Require that the account exists in stored users
    if (!_registeredUsers.containsKey(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Akun tidak ditemukan. Silakan register terlebih dahulu.")),
      );
      return;
    }

    // Validate password
    if (_registeredUsers[email] != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password salah. Coba lagi.")),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login berhasil sebagai $email")),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(email: email),
      ),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(
          onRegister: (email, password) async {
            await _saveUserToPrefs(email, password);
          },
        ),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double formWidth = width > 600 ? 420 : width * 0.95;
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: Stack(
        children: [
          // Image background overlay removed — using cream background only
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: formWidth,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha((0.92 * 255).round()),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.withAlpha((0.2 * 255).round()),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 120,
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Selamat Datang di RISE BAKERY",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink[600],
                        letterSpacing: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: emailController,
                        style: GoogleFonts.poppins(fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.pink[50],
                        labelText: "Email / Nama",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.pink[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: Colors.pink[400]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.pink[600]!, width: 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      style: GoogleFonts.poppins(fontSize: 18),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.pink[50],
                        labelText: "Password",
                        labelStyle: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.pink[700],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide:
                              BorderSide(color: Colors.pink[600]!, width: 2),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.pink[400],
                          ),
                          onPressed: () =>
                              setState(() => _isObscure = !_isObscure),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    GFButton(
                    onPressed: _login,
                    text: "Login",
                    icon: const Icon(Icons.login, color: Colors.white),
                    fullWidthButton: true,
                    size: GFSize.LARGE,
                    color: const Color.fromARGB(255, 237, 226, 125),
                    elevation: 6,
                    shape: GFButtonShape.pills,     // bentuk rounded pills
                      textStyle: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white
  ),
),

                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _goToRegister,
                      child: Text(
                        "Belum punya akun? Register di sini",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.pink[600],
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
