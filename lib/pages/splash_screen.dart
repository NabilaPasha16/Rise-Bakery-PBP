import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../router/navigation_helpers.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animasi fade & scale (LOGIKA TETAP SAMA)
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _animationController.forward();

    // Setelah 3 detik pindah ke LoginPage (LOGIKA TETAP SAMA)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.toLogin();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // --- PALET WARNA MEWAH ---
  final Color _bgCream = const Color(0xFFFFF3E0); // Cream lembut
  final Color _bgPeach = const Color(0xFFFFE0B2); // Peach hangat
  final Color _textChocolate = const Color(0xFF5D4037); // Coklat tua premium
  final Color _accentGold = const Color(0xFFD4AF37); // Emas

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Gradient Mewah
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_bgCream, _bgPeach],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/spless.png'),
                fit: BoxFit.cover,
                opacity: 0.15, // Dibuat lebih transparan agar elegan (watermark)
              ),
            ),
          ),

          // 2. Content Utama
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo dengan Shadow halus
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _textChocolate.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset('assets/logo.png', height: 160),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // JUDUL UTAMA (Font Serif untuk kesan Luxury)
                    Text(
                      "PILACAKE",
                      style: GoogleFonts.playfairDisplay( // Ganti font ke serif mewah
                        fontSize: 48,
                        color: _textChocolate,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4.0, // Spasi antar huruf lebar = elegan
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Subjudul 1 (Garis hiasan)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60),
                      child: Divider(
                        color: _textChocolate.withOpacity(0.5),
                        thickness: 1,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Subjudul 2
                    Text(
                      "Premium Bakery by Rise",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: _textChocolate.withOpacity(0.8),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Loading Animation (Warna disesuaikan tema)
                    LoadingAnimationWidget.staggeredDotsWave(
                      color: _textChocolate, // Ubah biru menjadi coklat
                      size: 50,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Footer Kelompok
                    Text(
                      "KELOMPOK 5",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: _textChocolate.withOpacity(0.6),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.0,
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