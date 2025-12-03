import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/contact_cubit.dart';
import '../bloc/contact_state.dart';
import '../model/contact_message.dart';
import '../services/api_service.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _msgC = TextEditingController();

  // --- WARNA TEMA ---
  final Color bgCream = const Color(0xFFFFF3E0);
  final Color bgPeach = const Color(0xFFFFE0B2);
  final Color textChocolate = const Color(0xFF5D4037);
  final Color accentPink = const Color(0xFFD81B60);
  final Color buttonGold = const Color(0xFFFFCA28);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _msgC.dispose();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak dapat membuka browser")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 800; 

    return BlocProvider(
      create: (_) => ContactCubit(ApiService()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: textChocolate),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
        body: BlocConsumer<ContactCubit, ContactState>(
          listener: (context, state) {
            if (state is ContactSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: Colors.green),
              );
              _nameCtrl.clear();
              _emailCtrl.clear();
              _msgC.clear();
            }
            if (state is ContactFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error), backgroundColor: Colors.red),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  // ============================================
                  // 1. HERO BANNER
                  // ============================================
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/background.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          textChocolate.withOpacity(0.6), // Overlay Coklat
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Text(
                            "CONTACT US",
                            style: GoogleFonts.playfairDisplay( // Font Mewah
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: buttonGold, // Warna Emas
                              letterSpacing: 2.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(height: 4, width: 80, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                  // ============================================
                  // 2. MAIN CONTENT (INFO & FORM)
                  // ============================================
                  Container(
                    // Background Gradient Theme untuk sisa halaman
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [bgCream, bgPeach],
                      ),
                    ),
                    child: Transform.translate(
                      offset: const Offset(0, -40), 
                      child: Container(
                        width: isWide ? 1000 : double.infinity, 
                        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 40), 
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24), // Rounded lebih halus
                          boxShadow: [
                            BoxShadow(
                              color: textChocolate.withOpacity(0.15), // Shadow Coklat
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: isWide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(flex: 4, child: _buildInfoSection()),
                                  Container(
                                    width: 1, 
                                    height: 400, 
                                    color: bgPeach, 
                                    margin: const EdgeInsets.symmetric(horizontal: 40),
                                  ),
                                  Expanded(flex: 5, child: _buildFormSection(state, context)),
                                ],
                              )
                            : Column(
                                children: [
                                  _buildInfoSection(),
                                  const SizedBox(height: 40),
                                  Divider(thickness: 1.5, color: bgPeach),
                                  const SizedBox(height: 40),
                                  _buildFormSection(state, context),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // --- BAGIAN KIRI: Info Toko & Sosmed ---
  Widget _buildInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo & Judul
        Center(
          child: Column(
            children: [
              Image.asset('assets/logo.png', height: 100, fit: BoxFit.contain),
              const SizedBox(height: 12),
              Text(
                "RISE BAKERY",
                style: GoogleFonts.playfairDisplay( // Font Mewah
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textChocolate,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),

        // Info Kontak
        _buildContactInfo(
          Icons.location_on,
          "Alamat Outlet",
          "Jl. Ahmad Yani No. 45, Kec. Magetan,\nKab. Magetan, Jawa Timur 63311",
        ),
        const SizedBox(height: 20),
        _buildContactInfo(
          Icons.access_time,
          "Jam Operasional",
          "Setiap Hari: 07.00 - 21.00 WIB",
        ),
        const SizedBox(height: 30),

        // Sosial Media
        Text(
          "Temukan Kami di:",
          style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w600, color: textChocolate.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSocialButton("WhatsApp", Icons.chat, Colors.green, "https://www.google.com/search?q=WhatsApp+Rise+Bakery"),
            _buildSocialButton("Instagram", Icons.camera_alt, Colors.purple, "https://www.google.com/search?q=Instagram+Rise+Bakery"),
            _buildSocialButton("Website", Icons.language, Colors.blue, "https://www.google.com"),
          ],
        ),
      ],
    );
  }

  // --- BAGIAN KANAN: Form Pesan ---
  Widget _buildFormSection(ContactState state, BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Kirim Pesan Langsung",
          style: GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textChocolate,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Punya kritik, saran, atau pertanyaan? Isi formulir di bawah ini.",
          style: GoogleFonts.poppins(fontSize: 14, color: textChocolate.withOpacity(0.6)),
        ),
        const SizedBox(height: 30),

        Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _nameCtrl,
                label: "Nama Lengkap",
                icon: Icons.person_outline,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailCtrl,
                label: "Email",
                icon: Icons.email_outlined,
                validator: (v) => v!.contains("@") ? null : "Email tidak valid",
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _msgC,
                label: "Isi Pesan",
                icon: Icons.message_outlined,
                maxLines: 5,
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: state is ContactSending
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            final msg = ContactMessage(
                              name: _nameCtrl.text,
                              email: _emailCtrl.text,
                              message: _msgC.text,
                            );
                            ctx.read<ContactCubit>().sendContact(msg);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPink, // Tombol Pink Mewah
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: accentPink.withOpacity(0.4),
                  ),
                  child: state is ContactSending
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Kirim Pesan Sekarang", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- HELPER WIDGETS ---

  Widget _buildContactInfo(IconData icon, String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: accentPink, size: 26),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: textChocolate)),
              const SizedBox(height: 4),
              Text(content, style: GoogleFonts.poppins(fontSize: 14, color: textChocolate.withOpacity(0.8), height: 1.5)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(String label, IconData icon, Color color, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 85,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(label, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 14, color: textChocolate),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: textChocolate.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: buttonGold),
        filled: true,
        fillColor: bgCream.withOpacity(0.3), // Background input cream tipis
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: textChocolate.withOpacity(0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: accentPink, width: 2)),
      ),
      validator: validator,
    );
  }
}