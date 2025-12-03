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
    // Cek lebar layar untuk responsivitas (Responsive Layout)
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 800; // Jika lebar > 800px (Web/Tablet), pakai layout samping-sampingan

    return BlocProvider(
      create: (_) => ContactCubit(ApiService()),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
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
                          Colors.black.withOpacity(0.5),
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
                            style: GoogleFonts.poppins(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 2.5,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(height: 4, width: 80, color: Colors.orangeAccent),
                        ],
                      ),
                    ),
                  ),

                  // ============================================
                  // 2. MAIN CONTENT (INFO & FORM)
                  // ============================================
                  // FIX: Menggunakan Transform.translate agar tidak error margin negatif
                  Transform.translate(
                    offset: const Offset(0, -40), // Geser ke atas 40 pixel
                    child: Container(
                      width: isWide ? 1000 : double.infinity, 
                      // Hapus margin top negatif, gunakan bottom saja
                      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 40), 
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: isWide
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // KIRI: Info Toko & Sosmed
                                Expanded(flex: 4, child: _buildInfoSection()),
                                
                                // GARIS PEMISAH VERTIKAL
                                Container(
                                  width: 1, 
                                  height: 400, 
                                  color: Colors.grey[300], 
                                  margin: const EdgeInsets.symmetric(horizontal: 40),
                                ),

                                // KANAN: Form Pesan
                                Expanded(flex: 5, child: _buildFormSection(state, context)),
                              ],
                            )
                          : Column(
                              children: [
                                _buildInfoSection(),
                                const SizedBox(height: 40),
                                const Divider(thickness: 1.5),
                                const SizedBox(height: 40),
                                _buildFormSection(state, context),
                              ],
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
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[800],
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
            fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700],
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
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.brown[700],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Punya kritik, saran, atau pertanyaan? Isi formulir di bawah ini.",
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
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
                            // Mengakses Cubit via ctx
                            ctx.read<ContactCubit>().sendContact(msg);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
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
        Icon(icon, color: Colors.pink.shade400, size: 26),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87)),
              const SizedBox(height: 4),
              Text(content, style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700], height: 1.5)),
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
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.pinkAccent)),
      ),
      validator: validator,
    );
  }
}