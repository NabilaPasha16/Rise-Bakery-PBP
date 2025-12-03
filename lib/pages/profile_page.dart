import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

// --- WARNA TEMA (GLOBAL) ---
final Color bgCream = const Color(0xFFFFF3E0);
final Color bgPeach = const Color(0xFFFFE0B2);
final Color textChocolate = const Color(0xFF5D4037);
final Color accentPink = const Color(0xFFD81B60);
final Color buttonGold = const Color(0xFFFFCA28);

typedef OnProfileSave =
    Future<void> Function(String name, String email, String avatarPath);

class _EditProfileForm extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialAvatar;
  final OnProfileSave onSave;

  const _EditProfileForm({
    Key? key,
    required this.initialName,
    required this.initialEmail,
    required this.initialAvatar,
    required this.onSave,
  }) : super(key: key);

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _avatarCtrl;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _avatarCtrl = TextEditingController(text: widget.initialAvatar);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _avatarCtrl.dispose();
    super.dispose();
  }

  Widget _avatarPreview() {
    final path = _avatarCtrl.text.trim();
    ImageProvider img;
    if (path.isEmpty) {
      return CircleAvatar(radius: 50, backgroundColor: Colors.grey.shade300, child: Icon(Icons.person, size: 50, color: Colors.white));
    } else if (path.startsWith('http')) {
      img = NetworkImage(path);
    } else {
      img = AssetImage(path);
    }
    
    // Tambahkan border emas agar mewah
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: buttonGold, width: 3),
        boxShadow: [
          BoxShadow(
            color: textChocolate.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: CircleAvatar(radius: 48, backgroundImage: img),
    );
  }

  Future<void> _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await widget.onSave(
        _nameCtrl.text.trim(),
        _emailCtrl.text.trim(),
        _avatarCtrl.text.trim().isEmpty
            ? 'assets/profil.png'
            : _avatarCtrl.text.trim(),
      );
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(child: _avatarPreview()),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () async {
              final ctrl = TextEditingController(text: _avatarCtrl.text);
              final result = await showDialog<String?>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Ganti Foto', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textChocolate)),
                  content: TextField(
                    controller: ctrl,
                    decoration: const InputDecoration(
                      hintText: 'assets/profil.png atau URL...',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, null),
                      child: const Text('Batal'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
                      child: Text('OK', style: TextStyle(color: accentPink, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );

              if (result != null) setState(() => _avatarCtrl.text = result);
            },
            icon: Icon(Icons.camera_alt_outlined, color: accentPink),
            label: Text('Ganti Foto', style: GoogleFonts.poppins(color: accentPink, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 20),
          
          // Custom Text Field Style
          _buildTextField(_nameCtrl, 'Nama Lengkap', Icons.person_outline),
          const SizedBox(height: 16),
          _buildTextField(_emailCtrl, 'Email', Icons.email_outlined, validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Email wajib diisi';
            final email = v.trim();
            if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(email))
              return 'Format email salah';
            return null;
          }),
          
          const SizedBox(height: 30),
          
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _saving ? null : () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: textChocolate.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('Batal', style: GoogleFonts.poppins(color: textChocolate)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _saving ? null : _onSavePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentPink,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 5,
                    shadowColor: accentPink.withOpacity(0.4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Simpan', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(color: textChocolate),
      validator: validator ?? (v) => v == null || v.trim().isEmpty ? 'Wajib diisi' : null,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: textChocolate.withOpacity(0.6)),
        prefixIcon: Icon(icon, color: buttonGold),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: textChocolate.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: accentPink, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  final String email;
  const ProfilePage({super.key, required this.email});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // no device info state needed
  String? _displayName;
  String? _avatarPath;
  PermissionStatus? _cameraPermission;
  PermissionStatus? _storagePermission;
  PermissionStatus? _photosPermission;
  PermissionStatus? _mediaLibraryPermission;

  @override
  void initState() {
    super.initState();

    _loadProfile();
    _updatePermissionStatuses();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _displayName =
          prefs.getString('displayName') ?? _displayNameFromEmail(widget.email);
      _avatarPath = prefs.getString('avatarPath') ?? 'assets/profil.png';
    });
  }

  Future<void> _saveProfile({String? name, String? avatarPath}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString('displayName', name);
    if (avatarPath != null) await prefs.setString('avatarPath', avatarPath);
  }

  // Permission helpers
  Future<void> _updatePermissionStatuses() async {
    try {
      final cam = await Permission.camera.status;
      final stor = await Permission.storage.status;
      final photos = await Permission.photos.status;
      final mediaLibrary = await Permission.mediaLibrary.status;
      if (mounted) {
        setState(() {
          _cameraPermission = cam;
          _storagePermission = stor;
          _photosPermission = photos;
          _mediaLibraryPermission = mediaLibrary;
        });
      }
    } catch (_) {}
  }

  Future<void> _requestPermission(Permission permission) async {
    final status = await permission.request();
    if (mounted) {
      setState(() {
        if (permission == Permission.camera) _cameraPermission = status;
        if (permission == Permission.storage) _storagePermission = status;
        if (permission == Permission.photos) _photosPermission = status;
        if (permission == Permission.mediaLibrary)
          _mediaLibraryPermission = status;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = widget.email;

    return Scaffold(
      extendBodyBehindAppBar: true, // Agar gradient full screen
      appBar: AppBar(
        title: Text('Edit Profil', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: textChocolate)),
        backgroundColor: Colors.transparent, // Transparan
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: textChocolate),
      ),
      body: Container(
        // BACKGROUND GRADIENT TEMA
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [bgCream, bgPeach],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView( // Tambahkan scroll agar aman di layar kecil
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Permission panel (Card Putih Mewah)
                  Card(
                    elevation: 4,
                    shadowColor: textChocolate.withOpacity(0.1),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.security, color: accentPink, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Izin Aplikasi',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: textChocolate,
                                  fontSize: 16
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildPermissionRow('Kamera', _cameraPermission, Permission.camera),
                          const SizedBox(height: 8),
                          _buildPermissionRow('Penyimpanan', _storagePermission, Permission.storage),
                          const SizedBox(height: 8),
                          _buildPermissionRow('Foto', _photosPermission, Permission.photos),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Form Edit Profile (Card Putih Mewah)
                  Card(
                    elevation: 4,
                    shadowColor: textChocolate.withOpacity(0.1),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _EditProfileForm(
                        initialName: _displayName ?? _displayNameFromEmail(email),
                        initialEmail: email,
                        initialAvatar: _avatarPath ?? 'assets/profil.png',
                        onSave: (name, emailValue, avatar) async {
                          setState(() {
                            _displayName = name;
                            _avatarPath = avatar;
                          });
                          await _saveProfile(name: name, avatarPath: avatar);

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('email', emailValue);

                          if (mounted)
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Profil berhasil disimpan', style: GoogleFonts.poppins()),
                                backgroundColor: Colors.green,
                              ),
                            );
                        },
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

  Widget _buildPermissionRow(String label, PermissionStatus? status, Permission permission) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '$label: ${status?.toString().split('.').last ?? 'unknown'}',
            style: GoogleFonts.poppins(fontSize: 13, color: textChocolate.withOpacity(0.8)),
          ),
        ),
        SizedBox(
          height: 32,
          child: ElevatedButton(
            onPressed: () => _requestPermission(permission),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonGold,
              foregroundColor: textChocolate,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: Text('Minta', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  String _displayNameFromEmail(String email) {
    if (email.isEmpty) return 'Guest';
    final local = email.split('@').first;
    if (local.isEmpty) return 'Guest';
    final parts = local.replaceAll(RegExp(r'[._]'), ' ').split(' ');
    final transformed = parts
        .map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.substring(1)}')
        .join(' ');
    return transformed;
  }
}